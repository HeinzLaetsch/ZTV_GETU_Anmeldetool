package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.transfer.TeilnahmeStatisticDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerStartDTO;

import lombok.extern.slf4j.Slf4j;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;

@Service("teilnehmerAnlassLinkService")
@Slf4j
@RequiredArgsConstructor
public class TeilnehmerAnlassLinkService {

	//public final OrganisationService organisationSrv;

	public final AnlassService anlassSrv;

	//@Autowired
	//TeilnehmerRepository teilnehmerRepository;

	public final TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

	public final OrganisationAnlassLinkRepository organisationAnlassLinkRepository;

  public final OrganisationService organisationSrv;

  public final TeilnehmerAnlassLinkMapper teilnehmerAnlassLinkMapper;

  public final TeilnehmerAnlassLinkExportImportMapper teilnehmerAnlassLinkMapperExportImport;

  public List<TeilnehmerAnlassLinkCsvDTO> getAllTeilnehmerForAnlassAsCsv(UUID anlassId) {
    List<TeilnehmerAnlassLink> tals = getAllTeilnehmerForAnlassAndUpdateStartnummern(anlassId);
    List<TeilnehmerAnlassLinkCsvDTO> talsCsv = tals.stream().map(tal -> {
      return teilnehmerAnlassLinkMapperExportImport.fromEntity(tal);
    }).toList();
    return talsCsv;
  }

  /*
  public getTeilnahmen() {
    List<TeilnehmerAnlassLink> links = anlassSrv.getTeilnahmen(anlassId, orgId, false);
    List<TeilnehmerAnlassLinkDTO> linksDto = links.stream().map(link -> {
      return teilnehmerAnlassMapper.toDto(link);
    }).collect(Collectors.toList());
    if (linksDto.size() == 0) {
      return getNotFound();
    }
    return ResponseEntity.ok(linksDto);
  } */
 	public Optional<TeilnehmerAnlassLink> findTeilnehmerAnlassLinkById(UUID id) {
		return teilnehmerAnlassLinkRepository.findById(id);
	}

	public Optional<TeilnehmerAnlassLink> findTeilnehmerAnlassLinkByAnlassAndTeilnehmer(Anlass anlass,
			Teilnehmer teilnehmer) {
		return teilnehmerAnlassLinkRepository.findByAnlassAndTeilnehmer(anlass, teilnehmer);
	}

	public List<TeilnehmerAnlassLink> findTeilnehmerAnlassLinkByTeilnehmer(Teilnehmer teilnehmer) {
		return teilnehmerAnlassLinkRepository.findByTeilnehmer(teilnehmer);
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

	public List<AnlageEnum> findAnlagenByKategorieAndAbteilung(UUID anlassId, KategorieEnum kategorie,
			AbteilungEnum abteilung) {

		List<AnlageEnum> anlagen = teilnehmerAnlassLinkRepository
				.findDistinctAnlagenByAnlassAndKategorieAndAbteilung(anlassId, true, kategorie, abteilung);
		return anlagen;
	}

  public List<AbteilungEnum> findAbteilungenByKategorie(UUID anlassId, KategorieEnum kategorie) {
    Anlass anlass = this.anlassSrv.findById(anlassId);
    return findAbteilungenByKategorie(anlass, kategorie);
  }

	public List<AbteilungEnum> findAbteilungenByKategorie(Anlass anlass, KategorieEnum kategorie) {

		UUID anlass_id = anlass.getId();
		List<AbteilungEnum> abteilungen = teilnehmerAnlassLinkRepository
				.findDistinctAbteilungenByAnlassAndKategorie(anlass_id, true, kategorie);
		return abteilungen;
	}

	public TeilnehmerAnlassLink save(TeilnehmerAnlassLink tal) {
		TeilnehmerAnlassLink saved = this.teilnehmerAnlassLinkRepository.saveAndFlush(tal);
		return saved;
	}

  public List<TeilnehmerAnlassLinkDTO> getTeilnahmenDTOByAnlassOrg(UUID anlassId, UUID orgId, boolean exclude) {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = this.organisationSrv.findById(orgId);
    List<TeilnehmerAnlassLink> teilnahmen;
    if (exclude) {
      List<MeldeStatusEnum> exclusion = Arrays
          .asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.ABGEMELDET_1,
              MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });
      teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisationExclude(anlass, organisation,
          exclusion);
    } else {
      teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisation(anlass, organisation);
    }
    // Todo was soll das?
    teilnahmen = teilnahmen.stream().filter(link -> {
      try {
        String name = link.getTeilnehmer().getName();
        return true;
      } catch (Exception ex) {
        return false;
      }
    }).toList();

    /**
    if (teilnahmen.size() > 0) {
      log.debug("Teilnehmer {}", teilnahmen.getFirst().getKategorie());
      try {
        log.debug("Teilnehmer {}", teilnahmen.getFirst().getTeilnehmer().getName());
      } catch (Exception ex) {
        log.warn("Kein Teilnehmer message: {} ", ex.getMessage());
      }
      log.debug("Teilnehmer {}", teilnahmen.getFirst().getOrganisation().getName());
    }
     **/
    return teilnahmen.stream().map(teilnehmerAnlassLinkMapper::toDto).toList();
  }

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmen(UUID anlassId) {
		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET_1,
				MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });

		return findAnlassTeilnahmen(anlassId, exclusion, true);
	}

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmen(UUID anlassId, List<MeldeStatusEnum> exclusion,
			boolean linkStatus) {
		Anlass anlass = anlassSrv.findById(anlassId);
		if (anlass == null) {
			throw new NotFoundException(this.getClass(), anlassId);
		}

		List<OrganisationAnlassLink> orgLinks = organisationAnlassLinkRepository.findByAnlassAndAktiv(anlass, true);
		List<Organisation> orgs = orgLinks.stream().map(oal -> {
			return oal.getOrganisation();
		}).collect(Collectors.toList());
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(anlass, linkStatus,
				exclusion, orgs);
		return teilnahmen;
	}

	public int findMaxStartNummer() {
		Optional<TeilnehmerAnlassLink> max = teilnehmerAnlassLinkRepository
				.findTopByStartnummerNotNullOrderByStartnummerDesc();
		int maxStartnummer = 1;
		if (max.isPresent() && max.get().getStartnummer() != null) {
			maxStartnummer = max.get().getStartnummer() + 1;
		}
		return maxStartnummer;
	}

	private List<TeilnehmerAnlassLink> updateStartNummern(List<TeilnehmerAnlassLink> tals) {

		AtomicInteger maxStartnummerAtomic = new AtomicInteger(findMaxStartNummer());
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
			AbteilungEnum abteilung, AnlageEnum anlage, GeraetEnum geraet) {

		Anlass anlass = anlassSrv.findById(anlassId);

		if (anlass == null) {
			throw new NotFoundException(this.getClass(),
					"Could not find Anlass with id: %s".formatted(anlassId.toString()));
		}
		List<TeilnehmerAnlassLink> tals = null;
		// TODO check wieso !
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
			AbteilungEnum abteilung, AnlageEnum anlage, GeraetEnum geraet, Optional<String> search) {
		List<TeilnehmerAnlassLink> tals = getTeilnehmerAnlassLinks(anlassId, kategorie, abteilung, anlage, geraet);

		tals = tals.stream().filter(tal -> {
			return tal.getMeldeStatus() == null || MeldeStatusEnum.STARTET.equals(tal.getMeldeStatus())
					|| MeldeStatusEnum.NEUMELDUNG.equals(tal.getMeldeStatus());
		}).collect(Collectors.toList());

		if (search.isPresent()) {
			tals = tals.stream().filter(tal -> {
				return tal.getTeilnehmer().getName().toLowerCase().contains(search.get().toLowerCase())
						|| tal.getTeilnehmer().getVorname().toLowerCase().contains(search.get().toLowerCase());
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

	// TODO Adjust to new Data
	public TeilnahmeStatisticDTO getStatisticForAnlass(UUID anlassId, KategorieEnum kategorie, AbteilungEnum abteilung,
			AnlageEnum anlage, GeraetEnum geraet, Optional<String> search) {
		TeilnahmeStatisticDTO teilnahmeStatstic = new TeilnahmeStatisticDTO();
		List<TeilnehmerAnlassLink> tals = getTeilnehmerAnlassLinks(anlassId, kategorie, abteilung, anlage, geraet);
		if (search.isPresent()) {
			tals = tals.stream().filter(tal -> {
				return tal.getTeilnehmer().getName().toLowerCase().contains(search.get().toLowerCase())
						|| tal.getTeilnehmer().getVorname().toLowerCase().contains(search.get().toLowerCase());
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
				case ABGEMELDET_4:
					teilnahmeStatstic.incAbgemeldet_4();
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

  public List<TeilnehmerAnlassLinkCsvDTO> getMutationenDTOForAnlass(UUID anlassId) {
    List<TeilnehmerAnlassLink> tals = getMutationenForAnlass(anlassId);
    return tals.stream().map(teilnehmerAnlassLinkMapperExportImport::fromEntity).toList();
  }
	public List<TeilnehmerAnlassLink> getMutationenForAnlass(UUID anlassId) {
		// MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.UMMELDUNG
		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.STARTET });

		List<TeilnehmerAnlassLink> tals = findAnlassTeilnahmen(anlassId, exclusion, true);
		tals = tals.stream().filter(tal -> tal.getMeldeStatus() != null).toList();
		return tals;
	}

	public List<TeilnehmerAnlassLink> getAllTeilnehmerForAnlassAndUpdateStartnummern(UUID anlassId) {
		List<TeilnehmerAnlassLink> tals = findAnlassTeilnahmen(anlassId);
		tals = updateStartNummern(tals);
		return tals;
	}

	public int updateAnlassTeilnahmen(UUID anlassId, List<TeilnehmerAnlassLinkCsvDTO> talsDto) {
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
			throw new NotFoundException(this.getClass(), anlassId);
		}
		return counter;
	}

	public void updateAnlassTeilnahme(TeilnehmerStartDTO tsDTO) {
		Optional<TeilnehmerAnlassLink> optTal = teilnehmerAnlassLinkRepository.findById(tsDTO.getId());
		if (optTal.isEmpty()) {
			throw new NotFoundException(this.getClass(), tsDTO.getId());
		}
		TeilnehmerAnlassLink tal = optTal.get();
		tal.setAbteilung(tsDTO.getAbteilung());
		tal.setAnlage(tsDTO.getAnlage());
		tal.setStartgeraet(tsDTO.getStartgeraet());
		tal.setMeldeStatus(tsDTO.getMeldeStatus());
		if (MeldeStatusEnum.ABGEMELDET.equals(tal.getMeldeStatus())) {
			tal.setMeldeStatus(MeldeStatusEnum.ABGEMELDET_3);
		}
		if (MeldeStatusEnum.ABGEMELDET_3.equals(tal.getMeldeStatus())) {
			tal.setDeleted(true);
			tal.setAktiv(false);
		}
		teilnehmerAnlassLinkRepository.save(tal);
	}
  public TeilnehmerAnlassLinkDTO markAsDeleted(UUID id, String grund) {
    Optional<TeilnehmerAnlassLink> talOpt = findTeilnehmerAnlassLinkById(id);
    if (talOpt.isEmpty()) {
      throw new NotFoundException(TeilnehmerAnlassLink.class, id);
    }
    TeilnehmerAnlassLink tal = talOpt.get();
    tal.setDeleted(true);
    tal.setAktiv(false);
    if ("nichtAngetreten".equals(grund)) {
      tal.setMeldeStatus(MeldeStatusEnum.NICHTGESTARTET);
    }
    if ("verletzt".equals(grund)) {
      tal.setMeldeStatus(MeldeStatusEnum.VERLETZT);
    }
    tal = save(tal);

    TeilnehmerAnlassLinkDTO talDto = teilnehmerAnlassLinkMapper.toDto(tal);

    return talDto;
  }
}
