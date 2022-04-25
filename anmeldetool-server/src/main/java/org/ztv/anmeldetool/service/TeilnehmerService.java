package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;
import org.ztv.anmeldetool.util.TeilnehmerHelper;

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

	@Autowired
	TeilnehmerAnlassLinkMapper talMapper;

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
			List<TeilnehmerAnlassLink> tals = teilnehmerAnlassLinkRepository.findByTeilnehmer(teilnehmer);
			Optional<TeilnehmerAnlassLink> res = tals.stream().max((tal1, tal2) -> {
				if (KategorieEnum.KEIN_START.equals(tal1.getKategorie())) {
					return -1;
				}
				return tal1.getKategorie().compareTo(tal2.getKategorie());
			});
			KategorieEnum letzteKategorie = null;
			if (res.isPresent()) {
				letzteKategorie = res.get().getKategorie();
			}
			TeilnehmerDTO teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, orgId, letzteKategorie);
			teilnehmerDTOs.add(teilnehmerDTO);
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

	public ResponseEntity<TeilnehmerDTO> create(UUID orgId, TiTuEnum tiTu) {
		TeilnehmerDTO teilnehmerDTO = TeilnehmerDTO.builder().aktiv(false).id(UUID.randomUUID()).organisationid(orgId)
				.tiTu(tiTu).dirty(true).build();
		return create(teilnehmerDTO);
	}

	public ResponseEntity<TeilnehmerDTO> create(TeilnehmerDTO teilnehmerDTO) {
		Organisation organisation = organisationSrv.findOrganisationById(teilnehmerDTO.getOrganisationid());
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}

		Teilnehmer teilnehmer = TeilnehmerHelper.createTeilnehmer(teilnehmerDTO);
		teilnehmer.setOrganisation(organisation);

		teilnehmer = teilnehmerRepository.save(teilnehmer);

		teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, organisation);
		return ResponseEntity.ok(teilnehmerDTO);
	}

	public Teilnehmer create(Teilnehmer teilnehmer) {
		return teilnehmerRepository.save(teilnehmer);
	}

	public ResponseEntity<Boolean> delete(UUID orgId, UUID teilnehmerId) {
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(teilnehmerId);
		if (teilnehmerOptional.isEmpty()) {
			return ResponseEntity.notFound().build();
		}
		List<TeilnehmerAnlassLink> links = this.teilnehmerAnlassLinkRepository
				.findByTeilnehmer(teilnehmerOptional.get());
		this.teilnehmerAnlassLinkRepository.deleteAll(links);
		teilnehmerRepository.delete(teilnehmerOptional.get());
		return ResponseEntity.ok(true);
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
			log.warn("Could not find Teilnehmer with ID: {}", teilnehmerDTO.getId());
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
		teilnehmer.setStvNummer(teilnehmer2.getStvNummer());

		teilnehmer = create(teilnehmer);
		teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, organisation);
		return ResponseEntity.ok(teilnehmerDTO);
	}

	public ResponseEntity updateAnlassTeilnahmen(UUID anlassId, UUID teilnehmerId, TeilnehmerAnlassLinkDTO tal) {

		Anlass anlass = anlassSrv.findAnlassById(anlassId);

		Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(teilnehmerId);
		if (teilnehmerOptional.isEmpty()) {
			return ResponseEntity.notFound().build();
		}

		Iterable<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository
				.findByTeilnehmerAndAnlass(teilnehmerOptional.get(), anlass);
		TeilnehmerAnlassLink teilnehmerAnlassLink;
		if (teilnahmen.iterator().hasNext()) {
			teilnehmerAnlassLink = teilnahmen.iterator().next();
		} else {
			teilnehmerAnlassLink = new TeilnehmerAnlassLink();
		}

		teilnehmerAnlassLink.setAnlass(anlass);
		teilnehmerAnlassLink.setOrganisation(teilnehmerOptional.get().getOrganisation());
		teilnehmerAnlassLink.setTeilnehmer(teilnehmerOptional.get());
		teilnehmerAnlassLink.setAktiv(true);
		if (KategorieEnum.KEIN_START.toString().equals(tal.getKategorie())) {
			teilnehmerAnlassLink.setAktiv(false);
		} else {
			teilnehmerAnlassLink.setAktiv(true);
		}
		if (tal.getKategorie() != null) {
			teilnehmerAnlassLink.setKategorie(tal.getKategorie());
		}
		MeldeStatusEnum neuerStatus = MeldeStatusEnum.valueOf(tal.getMeldeStatus().toUpperCase());
		if (tal.getMeldeStatus() != null && !(teilnehmerAnlassLink.getMeldeStatus() == MeldeStatusEnum.NEUMELDUNG
				&& neuerStatus == MeldeStatusEnum.STARTET)) {
			teilnehmerAnlassLink.setMeldeStatus(neuerStatus);
		}
		teilnehmerAnlassLinkRepository.save(teilnehmerAnlassLink);

		return ResponseEntity.ok().build();
	}
}
