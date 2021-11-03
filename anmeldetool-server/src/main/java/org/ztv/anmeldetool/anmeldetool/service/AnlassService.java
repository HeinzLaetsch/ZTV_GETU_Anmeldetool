package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.util.AnlassHelper;
import org.ztv.anmeldetool.anmeldetool.util.TeilnehmerAnlassLinkHelper;

import lombok.extern.slf4j.Slf4j;

/**
 * 
 * @author heinz
 */
@Service("anlassService")
@Slf4j
public class AnlassService {

	@Autowired
	AnlassRepository anlassRepo;

	@Autowired
	OrganisationService organisationSrv;

	@Autowired
	PersonService personSrv;

	@Autowired
	WertungsrichterService wrSrv;

	@Autowired
	OrganisationAnlassLinkRepository orgAnlassRepo;

	@Autowired
	TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

	@Autowired
	PersonAnlassLinkRepository personAnlassLinkRepository;

	@Autowired
	PersonenRepository personRepository;

	public List<Person> getVerfuegbareWertungsrichter(UUID anlassId, UUID orgId, int brevet) {
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		List<Person> personen = personRepository.findByOrganisationId(organisation.getId());
		List<Person> wrs = personen.stream().filter(person -> {
			return (person.getWertungsrichter() != null && person.getWertungsrichter().getBrevet() == brevet);
		}).collect(Collectors.toList());

		List<PersonAnlassLink> eingeteilteWrs = getEingeteilteWertungsrichter(anlassId, orgId, brevet);

		List<Person> verfuegbare = wrs.stream().filter(person -> {
			if (eingeteilteWrs.size() == 0) {
				return true;
			}
			return eingeteilteWrs.stream().filter(pal -> {
				return !pal.getPerson().getId().equals(person.getId());
			}).count() > 0;
		}).collect(Collectors.toList());
		return verfuegbare;
	}

	public List<PersonAnlassLink> getEingeteilteWertungsrichter(UUID anlassId, UUID orgId, int brevet) {
		Anlass anlass = this.findAnlassById(anlassId);
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlassAndOrganisation(anlass, organisation);
		pals = pals.stream().filter(pal -> {
			return pal.getPerson().getWertungsrichter().getBrevet() == brevet;
		}).collect(Collectors.toList());
		return pals;
	}

	public ResponseEntity<PersonAnlassLinkDTO> updateEingeteilteWertungsrichter(UUID anlassId, UUID orgId,
			UUID personId, boolean add) {
		Anlass anlass = this.findAnlassById(anlassId);
		if (anlass == null) {
			// return ResponseEntity.notFound("Anlass mit Id " + anlassId + " nicht
			// gefunden").build();
		}
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		Person person = this.personSrv.findPersonById(personId);
		if (anlass == null || organisation == null || person == null) {
			return ResponseEntity.notFound().build();
		}
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person,
				organisation, anlass);
		if (add) {
			if (pals.size() > 0) {
				return ResponseEntity.badRequest().build();
			} else {
				PersonAnlassLink pal = new PersonAnlassLink();
				pal.setAktiv(true);
				pal.setAnlass(anlass);
				pal.setOrganisation(organisation);
				pal.setPerson(person);
				pal = personAnlassLinkRepository.save(pal);
				PersonAnlassLinkDTO palDTO = PersonAnlassLinkDTO.builder().anlassId(pal.getAnlass().getId())
						.organisationId(pal.getOrganisation().getId()).personId(pal.getPerson().getId()).build();
				return ResponseEntity.ok(palDTO);
			}
		} else {
			if (pals.size() == 0) {
				return ResponseEntity.badRequest().build();
			} else {
				personAnlassLinkRepository.delete(pals.get(0));
				PersonAnlassLinkDTO palDTO = PersonAnlassLinkDTO.builder().anlassId(pals.get(0).getAnlass().getId())
						.organisationId(pals.get(0).getOrganisation().getId()).personId(pals.get(0).getPerson().getId())
						.build();
				return ResponseEntity.ok(palDTO);
			}
		}
	}

	public ResponseEntity<Collection<AnlassDTO>> getAllAnlaesse() {
		Collection<AnlassDTO> anlaessDto = new ArrayList<AnlassDTO>();
		Iterable<Anlass> anlaesse = anlassRepo.findByAktivOrderByAnlassBezeichnung(true);
		for (Anlass anlass : anlaesse) {
			log.debug("Anlass: " + anlass);
			// Collection<OrganisationenDTO> orgDTOs =
			// OrganisationAnlassLinkHelper.getOrganisationDTOForAnlassLink(anlass.getOrganisationenLinks());
			AnlassDTO anlassDTO = AnlassHelper.createAnlassDTO(anlass);
			anlaessDto.add(anlassDTO);
		}
		return ResponseEntity.ok(anlaessDto);
	}

	public ResponseEntity<Collection<TeilnehmerAnlassLinkDTO>> getTeilnahmen(UUID anlassId, UUID OrgId) {
		Anlass anlass = this.findAnlassById(anlassId);
		Organisation organisation = organisationSrv.findOrganisationById(OrgId);
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisation(anlass,
				organisation);
		return ResponseEntity
				.ok(TeilnehmerAnlassLinkHelper.getTeilnehmerAnlassLinkDTOForTeilnehmerAnlassLink(teilnahmen));
	}

	public ResponseEntity<Boolean> getVereinStarts(UUID anlassId, UUID orgId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return ResponseEntity.notFound().build();
		}
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}

		OrganisationAnlassLink teilnahme = orgAnlassRepo.findFirstByOrganisationAndAnlass(organisation, anlass);
		if (teilnahme != null && teilnahme.isAktiv()) {
			return ResponseEntity.ok(true);

		}
		return ResponseEntity.notFound().build();
	}

	public ResponseEntity<Collection<OrganisationenDTO>> getVereinsStarts(UUID anlassId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return ResponseEntity.notFound().build();
		}
		// Collection<OrganisationenDTO> orgDTOs =
		// OrganisationAnlassLinkHelper.getOrganisationDTOForAnlassLink(anlass.getOrganisationenLinks());
		AnlassDTO anlassDTO = AnlassHelper.createAnlassDTO(anlass);
		return ResponseEntity.ok(anlassDTO.getOrganisationen());
	}

	public Anlass findAnlassById(UUID anlassId) {
		Optional<Anlass> optAnlass = anlassRepo.findById(anlassId);
		return optAnlass.get();
	}

	public ResponseEntity updateTeilnehmendeVereine(UUID anlassId, UUID orgId, OrganisationAnlassLinkDTO oal) {

		Anlass anlass = findAnlassById(anlassId);

		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}

		OrganisationAnlassLink teilnahme = orgAnlassRepo.findFirstByOrganisationAndAnlass(organisation, anlass);
		OrganisationAnlassLink organisationAnlassLink;
		if (teilnahme != null) {
			organisationAnlassLink = teilnahme;
			organisationAnlassLink.setAktiv(oal.isStarted());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
		} else {
			organisationAnlassLink = new OrganisationAnlassLink();
			organisationAnlassLink.setAktiv(oal.isStarted());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
		}
		orgAnlassRepo.save(organisationAnlassLink);

		return ResponseEntity.ok().build();
	}

}
