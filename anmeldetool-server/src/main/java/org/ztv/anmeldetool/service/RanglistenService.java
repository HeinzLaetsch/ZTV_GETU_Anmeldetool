package org.ztv.anmeldetool.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.NotenblaetterRepository;
import org.ztv.anmeldetool.repositories.RanglisteConfigurationRepository;
import org.ztv.anmeldetool.transfer.RanglisteConfigurationDTO;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;
import org.ztv.anmeldetool.transfer.TeamwertungDTO;
import org.ztv.anmeldetool.util.RanglistenConfigurationMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkRanglistenMapper;

@Service("ranglistenService")
@Slf4j
//TODO Compare with Grid
@AllArgsConstructor
public class RanglistenService {

  private final TeilnehmerAnlassLinkService talService;

  private final AnlassService anlassService;

  private final NotenblaetterRepository notenblaetterRepo;

  private final RanglisteConfigurationRepository ranglisteConfigurationRepo;

  private final TeilnehmerAnlassLinkRanglistenMapper talrMapper;
  private final RanglistenConfigurationMapper ranglistenConfigurationMapper;

  public List<RanglistenEntryDTO> getRanglistenPerVereinDtos(UUID anlassId, TiTuEnum tiTu,
      KategorieEnum kategorie)
      throws ServiceException {
    Anlass anlass = anlassService.findById(anlassId);
    List<TeilnehmerAnlassLink> tals = getRanglistePerVerein(anlass, tiTu, kategorie);

    List<RanglistenEntryDTO> ranglistenDTOs = tals.stream().map(tal -> talrMapper.fromEntity(tal)).collect(Collectors.toList());
    return ranglistenDTOs;
  }
  public List<TeamwertungDTO> getTeamwertung(UUID anlassId, TiTuEnum tiTu, KategorieEnum kategorie)
      throws ServiceException {
    if (TiTuEnum.Ti.equals(tiTu)) {
      return getTeamwertungTi(anlassId, kategorie);
    } else {
      return getTeamwertungTu(anlassId, kategorie);
    }
  }

  public List<TeamwertungDTO> getTeamwertungTi(UUID anlassId, KategorieEnum kategorie)
      throws ServiceException {
    Map<String, TeamwertungDTO> teamwertungen = new HashMap<>();
    List<RanglistenEntryDTO> entries = getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti, kategorie);
    for (RanglistenEntryDTO entry : entries) {
      TeamwertungDTO teamwertung;
      if (teamwertungen.containsKey(entry.getVerein())) {
        teamwertung = teamwertungen.get(entry.getVerein());
      } else {
        teamwertung = new TeamwertungDTO();
        teamwertung.setVerein(entry.getVerein());
        teamwertung.setGesamtPunktzahl(BigDecimal.ZERO);
        teamwertungen.put(entry.getVerein(), teamwertung);
      }
      if ((teamwertung.getAnzahlResultate() <= 3
          && kategorie.ordinal() <= KategorieEnum.K4.ordinal())
          || (teamwertung.getAnzahlResultate() <= 2
          && kategorie.ordinal() > KategorieEnum.K4.ordinal())) {
        teamwertung.setAnzahlResultate(teamwertung.getAnzahlResultate() + 1);
        teamwertung.setGesamtPunktzahl(
            teamwertung.getGesamtPunktzahl().add(BigDecimal.valueOf(entry.getGesamtPunktzahl())));
      }
    }
    List<TeamwertungDTO> unsortedResult = teamwertungen.values().stream().filter(tw -> {
      if (kategorie.ordinal() <= KategorieEnum.K4.ordinal()) {
        return tw.getAnzahlResultate() == 4;
      } else {
        return tw.getAnzahlResultate() == 3;
      }
    }).collect(Collectors.toList());

    List<TeamwertungDTO> sortedResult = sortAndSetRank(unsortedResult);
    return sortedResult;

    /*
     *
     * List<TeamwertungDTO> result = result1.stream()
     * .sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(),
     * Comparator.reverseOrder())) .collect(Collectors.toList()); int rang = 0;
     * float gesamtpunktzahl = 0.0f; for (TeamwertungDTO tw : result) { if
     * (tw.getGesamtPunktzahl() == gesamtpunktzahl) { tw.setRang(rang); } else {
     * tw.setRang(++rang); } gesamtpunktzahl = tw.getGesamtPunktzahl(); } return
     * result;
     */
  }

  public List<TeamwertungDTO> getTeamwertungTu(UUID anlassId, KategorieEnum kategorie)
      throws ServiceException {
    List<TeamwertungDTO> unsortedResult = null;
    Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe = new HashMap<>();
    if (kategorie.isJugend()) {
      prepareKategory(teamListe, anlassId, KategorieEnum.K1, 3);
      prepareKategory(teamListe, anlassId, KategorieEnum.K2, 3);
      prepareKategory(teamListe, anlassId, KategorieEnum.K3, 3);
      prepareKategory(teamListe, anlassId, KategorieEnum.K4, 3);

      cleanUp(teamListe);
      sortTeam(teamListe);
      unsortedResult = calcTeamResult(teamListe, 4);
    } else {
      prepareKategory(teamListe, anlassId, KategorieEnum.K5, 2);
      prepareKategory(teamListe, anlassId, KategorieEnum.K6, 2);
      prepareKategory(teamListe, anlassId, KategorieEnum.KH, 2);
      prepareKategory(teamListe, anlassId, KategorieEnum.K7, 2);

      cleanUp(teamListe);
      sortTeam(teamListe);
      unsortedResult = calcTeamResult(teamListe, 3);
    }
    List<TeamwertungDTO> sortedResult = sortAndSetRank(unsortedResult);
    return sortedResult;
  }

  /*
   * public List<TeamwertungDTO> getTeamwertungTu(UUID anlassId, KategorieEnum
   * kategorie) throws ServiceException { List<TeamwertungDTO> unsortedResult =
   * null; Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe =
   * new HashMap<>(); if (kategorie.isJugend()) { prepareKategory(teamListe,
   * anlassId, KategorieEnum.K1, 3); prepareKategory(teamListe, anlassId,
   * KategorieEnum.K2, 3); prepareKategory(teamListe, anlassId, KategorieEnum.K3,
   * 3); prepareKategory(teamListe, anlassId, KategorieEnum.K4, 3);
   *
   * cleanUp(teamListe); sortTeam(teamListe); unsortedResult =
   * calcTeamResult(teamListe, 4); } else { prepareKategory(teamListe, anlassId,
   * KategorieEnum.K5, 2); prepareKategory(teamListe, anlassId, KategorieEnum.K6,
   * 2); prepareKategory(teamListe, anlassId, KategorieEnum.KH, 2);
   * prepareKategory(teamListe, anlassId, KategorieEnum.K7, 2);
   *
   * cleanUp(teamListe); sortTeam(teamListe); unsortedResult =
   * calcTeamResult(teamListe, 3); } List<TeamwertungDTO> sortedResult =
   * sortAndSetRank(unsortedResult); return sortedResult; }
   */
  private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> prepareKategory(
      Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe, UUID anlassId,
      KategorieEnum kategorie,
      int maxProKategorie) throws ServiceException {
    List<RanglistenEntryDTO> entries = getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, kategorie);
    selectBestResults(teamListe, entries, kategorie, maxProKategorie);
    return teamListe;
  }
  /*
   * private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>>
   * prepareKategory( Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>>
   * teamListe, UUID anlassId, KategorieEnum kategorie, int maxProKategorie)
   * throws ServiceException { List<RanglistenEntryDTO> entries =
   * getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, kategorie);
   * selectBestResults(teamListe, entries, kategorie, maxProKategorie); return
   * teamListe; }
   */

  private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> selectBestResults(
      Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe,
      List<RanglistenEntryDTO> entries,
      KategorieEnum kategorie, int maxKategorieResults) {
    entries.forEach(entry -> {
      List<RanglistenEntryDTO> ranglistenDtos = null;
      Map<KategorieEnum, List<RanglistenEntryDTO>> perKategorieMap = null;
      if (teamListe.containsKey(entry.getVerein())) {
        perKategorieMap = teamListe.get(entry.getVerein());
      } else {
        perKategorieMap = new HashMap<>();
        teamListe.put(entry.getVerein(), perKategorieMap);
      }
      if (perKategorieMap.containsKey(kategorie)) {
        ranglistenDtos = perKategorieMap.get(kategorie);
      } else {
        ranglistenDtos = new ArrayList<>();
        perKategorieMap.put(kategorie, ranglistenDtos);
      }
      if (ranglistenDtos.size() < maxKategorieResults) {
        ranglistenDtos.add(entry);
        if (perKategorieMap.containsKey(KategorieEnum.KEIN_START)) {
          ranglistenDtos = perKategorieMap.get(KategorieEnum.KEIN_START);
        } else {
          ranglistenDtos = new ArrayList<>();
          perKategorieMap.put(KategorieEnum.KEIN_START, ranglistenDtos);
        }
        ranglistenDtos.add(entry);
      }
    });
    return teamListe;
  }
  /*
   * private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>>
   * selectBestResults( Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>>
   * teamListe, List<RanglistenEntryDTO> entries, KategorieEnum kategorie, int
   * maxKategorieResults) { entries.forEach(entry -> { List<RanglistenEntryDTO>
   * ranglistenDtos = null; Map<KategorieEnum, List<RanglistenEntryDTO>>
   * perKategorieMap = null; if (teamListe.containsKey(entry.getVerein())) {
   * perKategorieMap = teamListe.get(entry.getVerein()); } else { perKategorieMap
   * = new HashMap<>(); teamListe.put(entry.getVerein(), perKategorieMap); } if
   * (perKategorieMap.containsKey(kategorie)) { ranglistenDtos =
   * perKategorieMap.get(kategorie); } else { ranglistenDtos = new ArrayList<>();
   * perKategorieMap.put(kategorie, ranglistenDtos); } if (ranglistenDtos.size() <
   * maxKategorieResults) { ranglistenDtos.add(entry); if
   * (perKategorieMap.containsKey(KategorieEnum.KEIN_START)) { ranglistenDtos =
   * perKategorieMap.get(KategorieEnum.KEIN_START); } else { ranglistenDtos = new
   * ArrayList<>(); perKategorieMap.put(KategorieEnum.KEIN_START, ranglistenDtos);
   * } ranglistenDtos.add(entry); } }); return teamListe; }
   */

  private List<TeamwertungDTO> calcTeamResult(
      Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe,
      int teamSize) {
    List<TeamwertungDTO> unsortedResult = new ArrayList<>();
    teamListe.values().forEach(team -> {
      if (team.get(KategorieEnum.KEIN_START) != null
          && team.get(KategorieEnum.KEIN_START).size() >= teamSize) {
        TeamwertungDTO teamWertungDto = new TeamwertungDTO();
        teamWertungDto.setGesamtPunktzahl(BigDecimal.ZERO);
        team.get(KategorieEnum.KEIN_START).forEach(entry -> {
          teamWertungDto.setVerein(entry.getVerein());
          if (teamWertungDto.getAnzahlResultate() < teamSize) {
            teamWertungDto.setAnzahlResultate(teamWertungDto.getAnzahlResultate() + 1);
            teamWertungDto.setGesamtPunktzahl(teamWertungDto.getGesamtPunktzahl()
                .add(BigDecimal.valueOf(entry.getGesamtPunktzahl())));
          }
        });
        if (teamWertungDto.getVerein() != null) {
          unsortedResult.add(teamWertungDto);
        }
      }
    });
    return unsortedResult;
  }
  /*
   * private List<TeamwertungDTO> calcTeamResult(Map<String, Map<KategorieEnum,
   * List<RanglistenEntryDTO>>> teamListe, int teamSize) { List<TeamwertungDTO>
   * unsortedResult = new ArrayList<>(); teamListe.values().forEach(team -> { if
   * (team.get(KategorieEnum.KEIN_START) != null &&
   * team.get(KategorieEnum.KEIN_START).size() >= teamSize) { TeamwertungDTO
   * teamWertungDto = new TeamwertungDTO();
   * team.get(KategorieEnum.KEIN_START).forEach(entry -> {
   * teamWertungDto.setVerein(entry.getVerein()); if
   * (teamWertungDto.getAnzahlResultate() < teamSize) {
   * teamWertungDto.setAnzahlResultate(teamWertungDto.getAnzahlResultate() + 1);
   * teamWertungDto .setGesamtPunktzahl(teamWertungDto.getGesamtPunktzahl() +
   * entry.getGesamtPunktzahl()); } }); if (teamWertungDto.getVerein() != null) {
   * unsortedResult.add(teamWertungDto); } } }); return unsortedResult; }
   */

  private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> sortTeam(
      Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe) {
    teamListe.values().forEach(team -> {
      team.values().forEach(kategorie -> {
        List<RanglistenEntryDTO> sortedList = kategorie.stream()
            .sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(), Comparator.reverseOrder()))
            .collect(Collectors.toList());
        kategorie.clear();
        kategorie.addAll(sortedList);
      });
    });
    return teamListe;
  }

  /*
   * private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> sortTeam(
   * Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe) {
   * teamListe.values().forEach(team -> { team.values().forEach(kategorie -> {
   * List<RanglistenEntryDTO> sortedList = kategorie.stream()
   * .sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(),
   * Comparator.reverseOrder())) .collect(Collectors.toList()); kategorie.clear();
   * kategorie.addAll(sortedList); }); }); return teamListe; }
   *
   */
  private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> cleanUp(
      Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe) {
    teamListe.values().forEach(team -> {
      if (team.size() < 2) {
        team.clear();
      }
    });
    teamListe.values().forEach(team -> {
      List<RanglistenEntryDTO> alle = new ArrayList<>();
      team.values().forEach(perKategorieMapEntry -> {
        alle.addAll(perKategorieMapEntry);
      });
    });
    return teamListe;
  }

  /*
   * private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> cleanUp(
   * Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe) {
   * teamListe.values().forEach(team -> { if (team.size() < 2) { team.clear(); }
   * }); teamListe.values().forEach(team -> { List<RanglistenEntryDTO> alle = new
   * ArrayList<>(); team.values().forEach(perKategorieMapEntry -> {
   * alle.addAll(perKategorieMapEntry); }); }); return teamListe; }
   *
   */
  private List<TeamwertungDTO> sortAndSetRank(List<TeamwertungDTO> unsortedResult) {
    List<TeamwertungDTO> result = unsortedResult.stream()
        .sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(), Comparator.reverseOrder()))
        .collect(Collectors.toList());
    int same = -1;
    int rang = 0;
    BigDecimal gesamtPunktzahl = BigDecimal.ZERO;

    for (TeamwertungDTO tw : result) {
      rang++;
      if (gesamtPunktzahl.compareTo(tw.getGesamtPunktzahl()) != 0) {
        tw.setRang(rang);
        same = -1;
      } else {
        if (same == -1) {
          same = rang - 1;
        }
        tw.setRang(same);
      }
      gesamtPunktzahl = tw.getGesamtPunktzahl();
    }
    return result;
  }

  /*
   * private List<TeamwertungDTO> sortAndSetRank(List<TeamwertungDTO>
   * unsortedResult) { List<TeamwertungDTO> result = unsortedResult.stream()
   * .sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(),
   * Comparator.reverseOrder())) .collect(Collectors.toList()); int rang = 0; for
   * (TeamwertungDTO tw : result) { tw.setRang(++rang); } return result; }
   */

  public Notenblatt saveNotenblatt(Notenblatt notenblatt) {
    if (notenblatt != null) {
      return notenblaetterRepo.save(notenblatt);
    }
    return null;
  }

  public RanglisteConfigurationDTO saveRanglisteConfigurationDto(RanglisteConfigurationDTO rc) {
    return ranglistenConfigurationMapper.fromEntity(
        saveRanglisteConfiguration(ranglistenConfigurationMapper.toEntity(rc)));
  }

  public RanglisteConfiguration saveRanglisteConfiguration(RanglisteConfiguration rc) {
    Optional<RanglisteConfiguration> entityOpt = ranglisteConfigurationRepo.findById(rc.getId());
    if (entityOpt.isPresent()) {
      entityOpt.get().setMaxAuszeichnungen(rc.getMaxAuszeichnungen());
      return ranglisteConfigurationRepo.save(entityOpt.get());
    }
    return ranglisteConfigurationRepo.save(rc);
  }

  public List<TeilnehmerAnlassLink> getRanglistePerVerein(Anlass anlass, TiTuEnum tiTu,
      KategorieEnum kategorie)
      throws ServiceException {
    List<TeilnehmerAnlassLink> tals = talService
        .findWettkampfTeilnahmenByKategorieAndTiTuOrderByOrganisation(anlass, kategorie, tiTu);
    return tals;
  }

  public RanglisteConfigurationDTO getRanglisteConfigurationDto(UUID anlassId,
      KategorieEnum kategorie,
      TiTuEnum tiTu) {
    return ranglistenConfigurationMapper.fromEntity(
        getRanglisteConfiguration(anlassId, kategorie, tiTu));
  }

  public RanglisteConfiguration getRanglisteConfiguration(UUID anlassId, KategorieEnum kategorie,
      TiTuEnum tiTu) {
    Anlass anlass = this.anlassService.findById(anlassId);
    return getRanglisteConfiguration(anlass, kategorie, tiTu);
  }

  public RanglisteConfiguration getRanglisteConfiguration(Anlass anlass, KategorieEnum kategorie,
      TiTuEnum tiTu) {
    Optional<RanglisteConfiguration> ranglistenConfigOpt = anlass.getRanglisteConfigurationen()
        .stream()
        .filter(conf -> conf.getKategorie().equals(kategorie) && conf.getTiTu().equals(tiTu))
        .findFirst();
    RanglisteConfiguration ranglistenConfig;
    ranglistenConfig = ranglistenConfigOpt.orElseGet(
        () -> new RanglisteConfiguration(anlass, kategorie, tiTu, 0));
    return ranglistenConfig;
  }

  public int calcMaxAuszeichnungen(List<TeilnehmerAnlassLink> tals, int maxAuszeichung)
      throws ServiceException {
    if (maxAuszeichung == 0) {
      maxAuszeichung = (int) Math.ceil(tals.size() * 0.4);
    }
    return maxAuszeichung;
  }

  public List<TeilnehmerAnlassLink> getTeilnehmerSorted(Anlass anlass, KategorieEnum kategorie,
      TiTuEnum titu)
      throws ServiceException {
    List<TeilnehmerAnlassLink> tals = talService.findWettkampfTeilnahmenByKategorieAndTiTu(anlass,
        kategorie, titu);

    tals = tals
        .stream().filter(tal -> tal.getNotenblatt() != null).sorted(Comparator
            .comparing(tal -> tal.getNotenblatt().getGesamtPunktzahl(), Comparator.reverseOrder()))
        .collect(Collectors.toList());

    return tals;
  }

  public List<TeilnehmerAnlassLink> createRangliste(List<TeilnehmerAnlassLink> tals,
      int maxAuszeichung)
      throws ServiceException {

    int rang = 0;
    int pos = 0;
    float last = 0.0f;
    for (TeilnehmerAnlassLink tal : tals) {
      pos++;
      float actual = tal.getNotenblatt().getGesamtPunktzahl();
      if (last != actual) {
        rang = pos;
        last = actual;
      }
      tal.getNotenblatt().setRang(rang);
      if (rang <= maxAuszeichung) {
        tal.getNotenblatt().setAuszeichnung(true);
      } else {
        tal.getNotenblatt().setAuszeichnung(false);
      }
    }
    return tals;
  }

  public List<RanglistenEntryDTO> generateRangliste(UUID anlassId, TiTuEnum tiTu,
      KategorieEnum kategorie,
      Optional<Integer> maxAuszeichungenOpt) throws ServiceException {
    Anlass anlass = anlassService.findById(anlassId);
    RanglisteConfiguration ranglistenConfig = getRanglisteConfiguration(anlass,
        kategorie, tiTu);
    List<TeilnehmerAnlassLink> tals = getTeilnehmerSorted(anlass, kategorie,
        tiTu);

    int maxAuszeichnungen = calcMaxAuszeichnungen(tals,
        ranglistenConfig.getMaxAuszeichnungen());
    if (maxAuszeichungenOpt.isPresent() && maxAuszeichungenOpt.get() > 0) {
      maxAuszeichnungen = maxAuszeichungenOpt.get();
      ranglistenConfig.setMaxAuszeichnungen(maxAuszeichnungen);
      saveRanglisteConfiguration(ranglistenConfig);
    }
    tals = createRangliste(tals, maxAuszeichnungen);

    List<RanglistenEntryDTO> ranglistenDTOs = tals.stream().map(tal -> {
      saveNotenblatt(tal.getNotenblatt());
      return talrMapper.fromEntity(tal);
    }).collect(Collectors.toList());

    ranglistenDTOs = sortByGeraet(ranglistenDTOs);
    return ranglistenDTOs;
  }

  private List<RanglistenEntryDTO> sortByGeraet(List<RanglistenEntryDTO> ranglistenDTOs) {
    // Reck
    ranglistenDTOs = ranglistenDTOs.stream()
        .sorted(Comparator.comparing(RanglistenEntryDTO::getNoteReck, Comparator.reverseOrder()))
        .collect(Collectors.toList());

    int rang = 0;
    int pos = 0;
    float currentNote = 0.0f;
    for (RanglistenEntryDTO dto : ranglistenDTOs) {
      pos++;
      if (dto.getNoteReck() != currentNote) {
        rang = pos;
        currentNote = dto.getNoteReck();
      }
      dto.setRangReck(rang);
    }
    // Boden
    ranglistenDTOs = ranglistenDTOs.stream()
        .sorted(Comparator.comparing(RanglistenEntryDTO::getNoteBoden, Comparator.reverseOrder()))
        .collect(Collectors.toList());

    rang = 0;
    pos = 0;
    currentNote = 0.0f;
    for (RanglistenEntryDTO dto : ranglistenDTOs) {
      pos++;
      if (dto.getNoteBoden() != currentNote) {
        rang = pos;
        currentNote = dto.getNoteBoden();
      }
      dto.setRangBoden(rang);
    }
    // Ring
    ranglistenDTOs = ranglistenDTOs.stream()
        .sorted(Comparator.comparing(RanglistenEntryDTO::getNoteSchaukelringe,
            Comparator.reverseOrder()))
        .collect(Collectors.toList());

    rang = 0;
    pos = 0;
    currentNote = 0.0f;
    for (RanglistenEntryDTO dto : ranglistenDTOs) {
      pos++;
      if (dto.getNoteSchaukelringe() != currentNote) {
        rang = pos;
        currentNote = dto.getNoteSchaukelringe();
      }
      dto.setRangSchaukelringe(rang);
    }
    // Sprung
    ranglistenDTOs = ranglistenDTOs.stream()
        .sorted(
            Comparator.comparing(RanglistenEntryDTO::getNoteZaehlbar, Comparator.reverseOrder()))
        .collect(Collectors.toList());

    rang = 0;
    pos = 0;
    currentNote = 0.0f;
    for (RanglistenEntryDTO dto : ranglistenDTOs) {
      pos++;
      if (dto.getNoteZaehlbar() != currentNote) {
        rang = pos;
        currentNote = dto.getNoteZaehlbar();
      }
      dto.setRangSprung(rang);
    }
    // Barren
    ranglistenDTOs = ranglistenDTOs.stream()
        .sorted(Comparator.comparing(RanglistenEntryDTO::getNoteBarren, Comparator.reverseOrder()))
        .collect(Collectors.toList());

    rang = 0;
    pos = 0;
    currentNote = 0.0f;
    for (RanglistenEntryDTO dto : ranglistenDTOs) {
      pos++;
      if (dto.getNoteBarren() != currentNote) {
        rang = pos;
        currentNote = dto.getNoteBarren();
      }
      dto.setRangBarren(rang);
    }

    ranglistenDTOs = ranglistenDTOs.stream()
        .sorted(Comparator.comparing(RanglistenEntryDTO::getRang, Comparator.naturalOrder()))
        .collect(Collectors.toList());
    return ranglistenDTOs;
  }
}
