package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.transfer.TeilnahmeStatisticDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerStartDTO;

import lombok.extern.slf4j.Slf4j;

@Service("teilnehmerAnlassLinkService")
@Slf4j
public class TeilnehmerAnlassLinkService {

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

	public Optional<TeilnehmerAnlassLink> findTeilnehmerAnlassLinkById(UUID id) {
		return teilnehmerAnlassLinkRepository.findById(id);
	}

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmenByKategorie(Anlass anlass, KategorieEnum kategorie)
			throws ServiceException {
		// TODO check if Verein startet
		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET_1,
				MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktivAndKategorie(anlass,
				true, exclusion, kategorie);
		return teilnahmen;
	}

	public List<TeilnehmerAnlassLink> findWettkampfTeilnahmenByKategorieAndTiTuOrderByOrganisation(Anlass anlass,
			KategorieEnum kategorie, TiTuEnum tiTu) throws ServiceException {
		List<MeldeStatusEnum> exclusion = Arrays
				.asList(new MeldeStatusEnum[] { MeldeStatusEnum.NICHTGESTARTET, MeldeStatusEnum.ABGEMELDET_1,
						MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository
				.findByAnlassAndAktivAndKategorieAndTiTuOrderByOrganisation(anlass, true, exclusion, kategorie, tiTu);
		return teilnahmen;
	}

	public List<TeilnehmerAnlassLink> findWettkampfTeilnahmenByKategorieAndTiTu(Anlass anlass, KategorieEnum kategorie,
			TiTuEnum tiTu) throws ServiceException {

		List<MeldeStatusEnum> exclusion = Arrays
				.asList(new MeldeStatusEnum[] { MeldeStatusEnum.NICHTGESTARTET, MeldeStatusEnum.ABGEMELDET_1,
						MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndKategorieAndTiTu(anlass,
				exclusion, kategorie, tiTu);
		return teilnahmen;
	}

	public List<AnlageEnum> findAnlagenByKategorieAndAbteilung(Anlass anlass, KategorieEnum kategorie,
			AbteilungEnum abteilung) throws ServiceException {

		UUID anlass_id = anlass.getId();
		String kategorieName = kategorie.name();
		String abteilungName = abteilung.name();
		List<AnlageEnum> anlagen = teilnehmerAnlassLinkRepository
				.findDistinctByAnlassAndAktivAndKategorieAndAbteilung(anlass_id, true, kategorieName, abteilungName);
		return anlagen;
	}

	public List<AbteilungEnum> findAbteilungenByKategorie(Anlass anlass, KategorieEnum kategorie)
			throws ServiceException {

		UUID anlass_id = anlass.getId();
		String kategorieName = kategorie.name();
		List<AbteilungEnum> abteilungen = teilnehmerAnlassLinkRepository
				.findDistinctByAnlassAndAktivAndKategorie(anlass_id, true, kategorieName);
		return abteilungen;
	}

	public TeilnehmerAnlassLink save(TeilnehmerAnlassLink tal) {
		TeilnehmerAnlassLink saved = this.teilnehmerAnlassLinkRepository.saveAndFlush(tal);
		return saved;
	}

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmen(UUID anlassId) throws ServiceException {
		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET_1,
				MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });

		return findAnlassTeilnahmen(anlassId, exclusion, true);
	}

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmen(UUID anlassId, List<MeldeStatusEnum> exclusion,
			boolean linkStatus) throws ServiceException {
		Anlass anlass = anlassSrv.findAnlassById(anlassId);
		if (anlass == null) {
			throw new ServiceException(this.getClass(),
					String.format("Could not find Anlass with id: %s", anlassId.toString()));
		}

		List<OrganisationAnlassLink> orgLinks = organisationAnlassLinkRepository.findByAnlassAndAktiv(anlass, true);
		List<Organisation> orgs = orgLinks.stream().map(oal -> {
			return oal.getOrganisation();
		}).collect(Collectors.toList());
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(anlass, linkStatus,
				exclusion, orgs);
		return teilnahmen;
	}

	private List<TeilnehmerAnlassLink> updateStartNummern(List<TeilnehmerAnlassLink> tals) {
		Optional<TeilnehmerAnlassLink> max = teilnehmerAnlassLinkRepository
				.findTopByStartnummerNotNullOrderByStartnummerDesc();
		int maxStartnummer = 1;
		if (max.isPresent() && max.get().getStartnummer() != null) {
			maxStartnummer = max.get().getStartnummer() + 1;
		}
		AtomicInteger maxStartnummerAtomic = new AtomicInteger(maxStartnummer);
		List<TeilnehmerAnlassLink> mustUpdateTal = tals.stream().filter(tal -> {
			if (tal.getStartnummer() == null) {
				tal.setStartnummer(maxStartnummerAtomic.getAndIncrement());
				return true;
			}
			return false;
		}).collect(Collectors.toList());

		teilnehmerAnlassLinkRepository.saveAll(mustUpdateTal);
		return tals;
	}

	private List<TeilnehmerAnlassLink> getTeilnehmerAnlassLinks(UUID anlassId, KategorieEnum kategorie,
			AbteilungEnum abteilung, AnlageEnum anlage, GeraetEnum geraet) throws ServiceException {

		Anlass anlass = anlassSrv.findAnlassById(anlassId);

		if (anlass == null) {
			throw new ServiceException(this.getClass(),
					String.format("Could not find Anlass with id: %s", anlassId.toString()));
		}
		List<TeilnehmerAnlassLink> tals = null;
		if (AbteilungEnum.UNDEFINED.equals(abteilung)) {
			tals = this.teilnehmerAnlassLinkRepository.findByAnlass(anlass, kategorie, null, null, null);
			tals = tals.stream().filter(tal -> {
				return tal.getAbteilung() == null;
			}).collect(Collectors.toList());
		} else {
			tals = this.teilnehmerAnlassLinkRepository.findByAnlass(anlass, kategorie, abteilung, anlage, geraet);
		}
		return tals;
	}

	public List<TeilnehmerStartDTO> getTeilnehmerForStartgeraet(UUID anlassId, KategorieEnum kategorie,
			AbteilungEnum abteilung, AnlageEnum anlage, GeraetEnum geraet, Optional<String> search)
			throws ServiceException {
		List<TeilnehmerAnlassLink> tals = getTeilnehmerAnlassLinks(anlassId, kategorie, abteilung, anlage, geraet);

		tals = tals.stream().filter(tal -> {
			return tal.getMeldeStatus() == null || MeldeStatusEnum.STARTET.equals(tal.getMeldeStatus())
					|| MeldeStatusEnum.NEUMELDUNG.equals(tal.getMeldeStatus());
		}).collect(Collectors.toList());

		if (search.isPresent()) {
			tals = tals.stream().filter(tal -> {
				return tal.getTeilnehmer().getName().contains(search.get());
			}).collect(Collectors.toList());
		}
		List<TeilnehmerStartDTO> tss = tals.stream().map(tal -> {
			return TeilnehmerStartDTO.builder().id(tal.getId()).name(tal.getTeilnehmer().getName())
					.vorname(tal.getTeilnehmer().getVorname()).verein(tal.getOrganisation().getName())
					.tiTu(tal.getTeilnehmer().getTiTu()).kategorie(tal.getKategorie()).abteilung(tal.getAbteilung())
					.anlage(tal.getAnlage()).startgeraet(tal.getStartgeraet()).meldeStatus(tal.getMeldeStatus())
					.build();
		}).collect(Collectors.toList());
		Collections.sort(tss);
		return tss;
	}

	public TeilnahmeStatisticDTO getStatisticForAnlass(UUID anlassId, KategorieEnum kategorie, AbteilungEnum abteilung,
			AnlageEnum anlage, GeraetEnum geraet, Optional<String> search) throws ServiceException {
		TeilnahmeStatisticDTO teilnahmeStatstic = new TeilnahmeStatisticDTO();
		List<TeilnehmerAnlassLink> tals = getTeilnehmerAnlassLinks(anlassId, kategorie, abteilung, anlage, geraet);
		if (search.isPresent()) {
			tals = tals.stream().filter(tal -> {
				return tal.getTeilnehmer().getName().contains(search.get());
			}).collect(Collectors.toList());
		}

		for (TeilnehmerAnlassLink tal : tals) {
			if (tal.getMeldeStatus() == null) {
				teilnahmeStatstic.incStartet();
			} else {
				switch (tal.getMeldeStatus()) {
				case STARTET:
					teilnahmeStatstic.incStartet();
					break;
				case NEUMELDUNG:
					teilnahmeStatstic.incNeumeldung();
					break;
				case ABGEMELDET_1:
					teilnahmeStatstic.incAbgemeldet_1();
					break;
				case ABGEMELDET_2:
					teilnahmeStatstic.incAbgemeldet_2();
					break;
				case ABGEMELDET_3:
					teilnahmeStatstic.incAbgemeldet_3();
					break;
				case UMMELDUNG:
					teilnahmeStatstic.incUmmeldung();
					break;
				case VERLETZT:
					teilnahmeStatstic.incVerletzt();
					break;
				case NICHTGESTARTET:
					teilnahmeStatstic.incNichtGestartet();
					break;
				default:
					teilnahmeStatstic.incStartet();
				}
			}
		}
		return teilnahmeStatstic;
	}

	public List<TeilnehmerAnlassLink> getMutationenForAnlass(UUID anlassId) throws ServiceException {
		// MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.UMMELDUNG
		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.STARTET });

		List<TeilnehmerAnlassLink> tals = findAnlassTeilnahmen(anlassId, exclusion, true);
		tals = tals.stream().filter(tal -> {
			return tal.getMeldeStatus() != null;
		}).collect(Collectors.toList());
		return tals;
	}

	public List<TeilnehmerAnlassLink> getAllTeilnehmerForAnlassAndUpdateStartnummern(UUID anlassId)
			throws ServiceException {
		List<TeilnehmerAnlassLink> tals = findAnlassTeilnahmen(anlassId);
		tals = updateStartNummern(tals);
		return tals;
	}

	public int updateAnlassTeilnahmen(UUID anlassId, List<TeilnehmerAnlassLinkCsvDTO> talsDto) throws ServiceException {
		List<TeilnehmerAnlassLink> tals = findAnlassTeilnahmen(anlassId);
		List<TeilnehmerAnlassLink> toUpdate = new ArrayList<TeilnehmerAnlassLink>();
		int counter = 0;
		for (TeilnehmerAnlassLinkCsvDTO talDto : talsDto) {
			for (TeilnehmerAnlassLink tal : tals) {
				if (tal.getStartnummer() != null && (tal.getStartnummer().compareTo(talDto.getStartnummer()) == 0)
						&& talDto.getTeilnehmerId().equals(tal.getTeilnehmer().getId())) {
					tal.setAbteilung(talDto.getAbteilung());
					tal.setAnlage(talDto.getAnlage());
					tal.setStartgeraet(talDto.getStartgeraet());
					toUpdate.add(tal);
					counter++;
					break;
				}
			}
		}

		toUpdate = teilnehmerAnlassLinkRepository.saveAll(toUpdate);
		if (toUpdate == null || toUpdate.size() != counter) {
			throw new ServiceException(this.getClass(), "Updated fehlgeschlagen");
		}
		return counter;
	}

	public void updateAnlassTeilnahme(TeilnehmerStartDTO tsDTO) throws ServiceException {
		Optional<TeilnehmerAnlassLink> optTal = teilnehmerAnlassLinkRepository.findById(tsDTO.getId());
		if (optTal.isEmpty()) {
			throw new ServiceException(this.getClass(), "Updated fehlgeschlagen, entity not found");
		}
		TeilnehmerAnlassLink tal = optTal.get();
		tal.setAbteilung(tsDTO.getAbteilung());
		tal.setAnlage(tsDTO.getAnlage());
		tal.setStartgeraet(tsDTO.getStartgeraet());
		tal.setMeldeStatus(tsDTO.getMeldeStatus());
		teilnehmerAnlassLinkRepository.save(tal);
	}
}
