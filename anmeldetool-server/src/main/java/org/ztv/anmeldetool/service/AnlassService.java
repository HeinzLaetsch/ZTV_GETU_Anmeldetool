package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;

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

	public List<Person> getVerfuegbareWertungsrichter(UUID anlassId, UUID orgId, WertungsrichterBrevetEnum brevet) {
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		List<Person> personen = personRepository.findByOrganisationId(organisation.getId());
		List<Person> wrs = personen.stream().filter(person -> {
			return (person.getWertungsrichter() != null && person.getWertungsrichter().getBrevet().equals(brevet));
		}).collect(Collectors.toList());

		List<PersonAnlassLink> eingeteilteWrs = getEingeteilteWertungsrichter(anlassId, orgId, brevet);

		List<Person> verfuegbare = wrs.stream().filter(person -> {
			if (eingeteilteWrs.size() == 0) {
				return true;
			}
			boolean already = eingeteilteWrs.stream().filter(pal -> {
				log.debug("verfügbar: {}, eingeteilt: {}, gleich: {}", person.getId(), pal.getPerson().getId(),
						pal.getPerson().getId().equals(person.getId()));
				return !pal.getPerson().getId().equals(person.getId());
			}).count() == eingeteilteWrs.size();
			log.debug("Person {} ist eingeteilt {}", person.getBenutzername(), already);
			return already;
		}).collect(Collectors.toList());
		return verfuegbare;
	}

	public List<PersonAnlassLink> getEingeteilteWertungsrichter(UUID anlassId) {
		Anlass anlass = this.findAnlassById(anlassId);
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlass(anlass);
		return pals;
	}

	public List<PersonAnlassLink> getEingeteilteWertungsrichter(UUID anlassId, UUID orgId,
			WertungsrichterBrevetEnum brevet) {
		Anlass anlass = this.findAnlassById(anlassId);
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlassAndOrganisation(anlass, organisation);
		pals = pals.stream().filter(pal -> {
			return pal.getPerson().getWertungsrichter().getBrevet().equals(brevet);
		}).collect(Collectors.toList());
		return pals;
	}

	public ResponseEntity<PersonAnlassLinkDTO> updateEingeteilteWertungsrichter(UUID anlassId, UUID orgId,
			UUID personId, String kommentar, boolean add) throws Exception {

		PersonAnlassLink pal = getAnlassLink(anlassId, orgId, personId);
		if (add) {
			if (pal != null) {
				return ResponseEntity.badRequest().build();
			}
			Anlass anlass = this.findAnlassById(anlassId);
			Organisation organisation = organisationSrv.findOrganisationById(orgId);
			Person person = this.personSrv.findPersonById(personId);
			pal = new PersonAnlassLink();
			pal.setAktiv(true);
			pal.setAnlass(anlass);
			pal.setOrganisation(organisation);
			pal.setPerson(person);
			pal.setKommentar(kommentar);
			pal = personAnlassLinkRepository.save(pal);
			PersonAnlassLinkDTO palDTO = PersonAnlassLinkDTO.builder().anlassId(pal.getAnlass().getId())
					.organisationId(pal.getOrganisation().getId()).personId(pal.getPerson().getId()).build();
			return ResponseEntity.ok(palDTO);
		} else {
			if (pal == null) {
				return ResponseEntity.badRequest().build();
			}
			personAnlassLinkRepository.delete(pal);
			PersonAnlassLinkDTO palDTO = PersonAnlassLinkDTO.builder().anlassId(pal.getAnlass().getId())
					.organisationId(pal.getOrganisation().getId()).personId(pal.getPerson().getId()).build();
			return ResponseEntity.ok(palDTO);
		}
	}

	public PersonAnlassLink getAnlassLink(UUID anlassId, UUID orgId, UUID personId) throws Exception {
		Anlass anlass = this.findAnlassById(anlassId);
		if (anlass == null) {
		}
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		Person person = this.personSrv.findPersonById(personId);
		if (anlass == null || organisation == null || person == null) {
			return null;
		}
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person,
				organisation, anlass);
		if (pals.size() > 1) {
			log.error("Elements: {}", pals.size());
			throw new Exception("too many elements");
		}
		if (pals.size() == 0) {
			return null;
		}
		return pals.get(0);
	}

	public PersonAnlassLink updateAnlassLink(PersonAnlassLink pal) {
		return personAnlassLinkRepository.save(pal);
	}

	public List<Anlass> getAllAnlaesse() {
		List<Anlass> anlaesse = anlassRepo.findByAktivOrderByStartDate(true);
		return anlaesse;
	}

	public List<TeilnehmerAnlassLink> getTeilnahmen(UUID anlassId, UUID OrgId) {
		Anlass anlass = this.findAnlassById(anlassId);
		Organisation organisation = organisationSrv.findOrganisationById(OrgId);
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisation(anlass,
				organisation);
		if (teilnahmen.size() > 0) {
			log.debug("Teilnehmer {}", teilnahmen.get(0).getKategorie());
			try {
				log.debug("Teilnehmer {}", teilnahmen.get(0).getTeilnehmer().getName());
			} catch (Exception ex) {
				log.warn("Kein Teilnehmer message: {} ", ex.getMessage());
			}
			log.debug("Teilnehmer {}", teilnahmen.get(0).getOrganisation().getName());
		}
		return teilnahmen;
	}

	public OrganisationAnlassLink getVereinStarts(UUID anlassId, UUID orgId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return null;
		}
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return null;
		}

		List<OrganisationAnlassLink> teilnahmen = orgAnlassRepo.findByOrganisationAndAnlass(organisation, anlass);
		if (teilnahmen != null && teilnahmen.size() == 1) {
			// TODO Check if Date stays
			return teilnahmen.get(0);
		}
		return null;
	}

	public List<Organisation> getVereinsStarts(UUID anlassId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return new ArrayList<Organisation>();
		}
		List<OrganisationAnlassLink> orgLinks = anlass.getOrganisationenLinks();
		List<Organisation> orgs = orgLinks.stream().map(orgLink -> {
			return orgLink.getOrganisation();
		}).collect(Collectors.toList());
		return orgs;
	}

	public Anlass findAnlassById(UUID anlassId) {
		Optional<Anlass> optAnlass = anlassRepo.findById(anlassId);
		return optAnlass.get();
	}

	public OrganisationAnlassLink updateTeilnehmendeVereine(UUID anlassId, UUID orgId, OrganisationAnlassLinkDTO oal) {

		Anlass anlass = findAnlassById(anlassId);

		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return null;
		}

		List<OrganisationAnlassLink> teilnahmen = orgAnlassRepo.findByOrganisationAndAnlass(organisation, anlass);
		OrganisationAnlassLink organisationAnlassLink;
		if (teilnahmen.size() != 0) {
			organisationAnlassLink = teilnahmen.get(0);
			organisationAnlassLink.setAktiv(oal.isStartet());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
			organisationAnlassLink.setVerlaengerungsDate(oal.getVerlaengerungsDate());
		} else {
			organisationAnlassLink = new OrganisationAnlassLink();
			organisationAnlassLink.setAktiv(oal.isStartet());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
			organisationAnlassLink.setVerlaengerungsDate(oal.getVerlaengerungsDate());
		}
		organisationAnlassLink = orgAnlassRepo.save(organisationAnlassLink);

		return organisationAnlassLink;
	}

}
