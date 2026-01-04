package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.transfer.TeilnehmerCsvContestDTO;

import lombok.extern.slf4j.Slf4j;

@Service("stvContestServiceService")
@Slf4j
public class StvContestService {

	@Autowired
	OrganisationService organisationSrv;

	@Autowired
	AnlassService anlassSrv;

	@Autowired
	TeilnehmerRepository teilnehmerRepository;

	@Autowired
	TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

	@Autowired
	OrganisationAnlassLinkRepository organisationAnlassLinkRepository;

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmen(UUID anlassId) throws ServiceException {
		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET_1,
				MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });

		return findAnlassTeilnahmen(anlassId, exclusion, true);
	}

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmen(UUID anlassId, List<MeldeStatusEnum> exclusion,
			boolean linkStatus) throws ServiceException {
		Anlass anlass = anlassSrv.findById(anlassId);
		if (anlass == null) {
			throw new ServiceException(this.getClass(),
					"Could not find Anlass with id: %s".formatted(anlassId.toString()));
		}

		List<OrganisationAnlassLink> orgLinks = organisationAnlassLinkRepository.findByAnlassAndAktiv(anlass, true);
		List<Organisation> orgs = orgLinks.stream().map(oal -> {
			return oal.getOrganisation();
		}).collect(Collectors.toList());
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(anlass, linkStatus,
				exclusion, orgs);
		return teilnahmen;
	}

	public void updateAnlassTeilnahmen(UUID anlassId, List<TeilnehmerCsvContestDTO> contestTeilnehmer) {
		Anlass anlass = this.anlassSrv.findById(anlassId);
		List<OrganisationAnlassLink> orgAlList = new ArrayList<>();
		List<TeilnehmerAnlassLink> contestTals = contestTeilnehmer.stream().map(t -> {
			TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
			Optional<Organisation> optOrganisation = getZTVOrganisation(t);
			if (optOrganisation.isPresent()) {
				saveOrganisationAnlassLink(anlass, optOrganisation.get(), orgAlList);
				tal.setOrganisation(optOrganisation.get());
				tal.setKategorie(getKategorieEnum(t));
				Optional<Teilnehmer> optTeilnehmer = getZTVTeilnehmer(optOrganisation.get(), t);
				if (optTeilnehmer.isPresent()) {
					tal.setTeilnehmer(optTeilnehmer.get());
				} else {
					this.log.warn("Teilnehmer nicht gefunden: {} , {} , {}", t.getVereinsname(), t.getNachname(),
							t.getVorname());
					Teilnehmer teilnehmer = new Teilnehmer(t.getNachname(), t.getVorname(), t.getGeburtsjahr(), "",
							getTiTuEnum(t), false, optOrganisation.get());
					teilnehmer = this.teilnehmerRepository.save(teilnehmer);
					tal.setTeilnehmer(teilnehmer);
				}
			} else {
				this.log.warn("T: {}/{}", t.getVereinsname(), t.cleanName());
			}
			tal.setMeldeStatus(MeldeStatusEnum.STARTET);
			tal.setAktiv(true);
			tal.setAnlass(anlass);
			tal = teilnehmerAnlassLinkRepository.save(tal);
			return tal;
		}).collect(Collectors.toList());
		organisationAnlassLinkRepository.saveAll(orgAlList);
		this.log.debug("Mapped: ");
	}

	private void saveOrganisationAnlassLink(Anlass anlass, Organisation org, List<OrganisationAnlassLink> orgAlList) {
		OrganisationAnlassLink orgAl = new OrganisationAnlassLink();
		orgAl.setAktiv(true);
		orgAl.setAnlass(anlass);
		orgAl.setOrganisation(org);
		orgAlList.add(orgAl);
	}

	private KategorieEnum getKategorieEnum(TeilnehmerCsvContestDTO contestTeilnehmer) {
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.K1.name())) {
			return KategorieEnum.K1;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.K2.name())) {
			return KategorieEnum.K2;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.K3.name())) {
			return KategorieEnum.K3;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.K4.name())) {
			return KategorieEnum.K4;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.K5.name())) {
			return KategorieEnum.K5;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.K6.name())) {
			return KategorieEnum.K6;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.K7.name())) {
			return KategorieEnum.K7;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.KD.name())) {
			return KategorieEnum.KD;
		}
		if (contestTeilnehmer.getKategorie().contains(KategorieEnum.KH.name())) {
			return KategorieEnum.KH;
		}
		return KategorieEnum.KEIN_START;
	}

	private TiTuEnum getTiTuEnum(TeilnehmerCsvContestDTO contestTeilnehmer) {
		TiTuEnum titu = TiTuEnum.Ti;
		if (contestTeilnehmer.getGeschlecht().equals("Mann")) {
			titu = TiTuEnum.Tu;
		}
		return titu;
	}

	private Optional<Teilnehmer> getZTVTeilnehmer(Organisation organisation,
			TeilnehmerCsvContestDTO contestTeilnehmer) {
		List<Teilnehmer> teilnehmer = this.teilnehmerRepository.findByNameAndVorname(contestTeilnehmer.getNachname(),
				contestTeilnehmer.getVorname());
		List<Teilnehmer> filtered = teilnehmer.stream().filter(t -> {
			return t.getOrganisation().equals(organisation);
		}).collect(Collectors.toList());
		if (filtered.size() == 1) {
			return Optional.of(filtered.getFirst());
		}
		log.warn("Mehr als ein Teilnehmer gefunden {} {}", contestTeilnehmer.getNachname(),
				contestTeilnehmer.getVorname());
		return Optional.empty();
	}

	private Optional<Organisation> getZTVOrganisation(TeilnehmerCsvContestDTO contestTeilnehmer) {
		List<Organisation> orgs = this.organisationSrv.getAllZuercherOrganisationen();
		Optional<Organisation> optOrganisation = orgs.stream().filter(o -> {
			// this.log.warn("T: {}/{}, O: {}/{}", t.getVereinsname(), t.cleanName(),
			// o.getName(), o.cleanName());
			if (contestTeilnehmer.cleanName().contains(o.cleanName())) {
				return true;
			}
			return false;
		}).findFirst();
		return optOrganisation;
	}
}
