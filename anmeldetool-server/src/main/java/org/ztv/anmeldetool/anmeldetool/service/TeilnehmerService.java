package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.anmeldetool.util.PersonHelper;
import org.ztv.anmeldetool.anmeldetool.util.TeilnehmerHelper;

import lombok.extern.slf4j.Slf4j;

@Service("teilnehmerService")
@Slf4j
public class TeilnehmerService {

	@Autowired
	OrganisationService organisationSrv;

	@Autowired
	AnlassService anlassSrv;

	@Autowired
	TeilnehmerRepository teilnehmerRepository;
	
	@Autowired
	TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;


	
	public ResponseEntity<Integer> countTeilnehmerByOrganisation(UUID orgId) {
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		int anzahl = teilnehmerRepository.countByOrganisation(organisation);
		return ResponseEntity.ok(anzahl);
	}

	public ResponseEntity<Collection<TeilnehmerDTO>> findTeilnehmerByOrganisation(UUID orgId, Pageable pageable) {
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		Collection<Teilnehmer> teilnehmerListe = teilnehmerRepository.findByOrganisation(organisation, pageable);
		List<TeilnehmerDTO> teilnehmerDTOs = new ArrayList<TeilnehmerDTO>();
		for (Teilnehmer teilnehmer : teilnehmerListe) {
			teilnehmerDTOs.add(TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, orgId));
		}
		return ResponseEntity.ok(teilnehmerDTOs);
	}

	public Teilnehmer findTeilnehmerById(UUID id) {
		Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(id);
		if (teilnehmerOptional.isEmpty()) {
			return null;
		}
		return teilnehmerOptional.get();
	}

	public List<Teilnehmer> findTeilnehmerByBenutzername(String name, String vorname) {
		 List<Teilnehmer> teilnehmerList = teilnehmerRepository.findByNameAndVorname(name, vorname);
		return teilnehmerList;
	}

	public ResponseEntity<TeilnehmerDTO> create(UUID orgId) {
		TeilnehmerDTO teilnehmerDTO = TeilnehmerDTO.builder().aktiv(false).id(UUID.randomUUID()).organisationid(orgId).dirty(true).build();
		return create(teilnehmerDTO);
	}
	public ResponseEntity<TeilnehmerDTO> create(TeilnehmerDTO teilnehmerDTO) {
		Organisation organisation = organisationSrv.findOrganisationById(teilnehmerDTO.getOrganisationid());
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		
		Teilnehmer teilnehmer = TeilnehmerHelper.createTeilnehmer(teilnehmerDTO);
		teilnehmer.setOrganisation(organisation);
		
		teilnehmerRepository.save(teilnehmer);
		
		teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, organisation);
		return ResponseEntity.ok(teilnehmerDTO);
	}

	public Teilnehmer create(Teilnehmer teilnehmer) {
		return teilnehmerRepository.save(teilnehmer);
	}

	public ResponseEntity<TeilnehmerDTO> update(UUID orgId, TeilnehmerDTO teilnehmerDTO) {
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		return update(organisation, teilnehmerDTO);
	}
	public ResponseEntity<TeilnehmerDTO> update(TeilnehmerDTO teilnehmerDTO) {
		return update(teilnehmerDTO.getOrganisationid(), teilnehmerDTO);
	}
	public ResponseEntity<TeilnehmerDTO> update(Organisation organisation, TeilnehmerDTO teilnehmerDTO) {
		Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(teilnehmerDTO.getId());
		if (teilnehmerOptional.isEmpty()) {
			return ResponseEntity.notFound().build();
		}
		Teilnehmer teilnehmer2 = TeilnehmerHelper.createTeilnehmer(teilnehmerDTO);

		Teilnehmer teilnehmer = teilnehmerOptional.get();
		teilnehmer.setAktiv(teilnehmer2.isAktiv());
		teilnehmer.setChangeDate(Calendar.getInstance());

		teilnehmer.setJahrgang(teilnehmer2.getJahrgang());
		teilnehmer.setTiTu(teilnehmer2.getTiTu());
		teilnehmer.setName(teilnehmer2.getName());
		teilnehmer.setVorname(teilnehmer2.getVorname());
		teilnehmer.setDirty(teilnehmer2.isDirty());
		
		teilnehmer = create(teilnehmer);
		teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, organisation);
		return ResponseEntity.ok(teilnehmerDTO);
	}
	
	public ResponseEntity updateAnlassTeilnahmen(UUID anlassId, UUID teilnehmerId, boolean nimmtTeil) {

		Anlass anlass = anlassSrv.findAnlassById(anlassId);

		Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(teilnehmerId);
		if (teilnehmerOptional.isEmpty()) {
			return ResponseEntity.notFound().build();
		}
		
		Iterable<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByTeilnehmerAndAnlass(teilnehmerOptional.get(), anlass);
		TeilnehmerAnlassLink teilnehmerAnlassLink;
		if (teilnahmen.iterator().hasNext()) {
			teilnehmerAnlassLink = teilnahmen.iterator().next(); 
			teilnehmerAnlassLink.setAktiv(nimmtTeil);
			teilnehmerAnlassLink.setAnlass(anlass);
			teilnehmerAnlassLink.setTeilnehmer(teilnehmerOptional.get());
		} else {
			teilnehmerAnlassLink = new TeilnehmerAnlassLink();
			teilnehmerAnlassLink.setAktiv(nimmtTeil);
			teilnehmerAnlassLink.setAnlass(anlass);
			teilnehmerAnlassLink.setTeilnehmer(teilnehmerOptional.get());
		}
		teilnehmerAnlassLinkRepository.save(teilnehmerAnlassLink);			
		
		return ResponseEntity.ok().build();
	}
}
