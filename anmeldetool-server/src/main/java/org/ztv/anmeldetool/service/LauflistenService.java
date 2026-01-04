package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.models.Einzelnote;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Laufliste;
import org.ztv.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.EinzelnotenRepository;
import org.ztv.anmeldetool.repositories.LauflistenContainerRepository;
import org.ztv.anmeldetool.repositories.LauflistenRepository;
import org.ztv.anmeldetool.repositories.NotenblaetterRepository;
import org.ztv.anmeldetool.transfer.LauflisteDTO;
import org.ztv.anmeldetool.transfer.LauflistenEintragDTO;
import org.ztv.anmeldetool.transfer.LauflistenStatusDTO;

@Service("lauflistenService")
@Slf4j
@AllArgsConstructor
public class LauflistenService {

  private final LauflistenRepository lauflistenRepo;

  private final LauflistenContainerRepository lauflistenContainerRepo;

  private final NotenblaetterRepository notenblaetterRepo;

  private final EinzelnotenRepository einzelnotenRepo;

  private final TeilnehmerAnlassLinkService talService;

  private final AnlassService anlassService;

  public Optional<Laufliste> findLauflisteById(UUID id) {
    return this.lauflistenRepo.findById(id);
  }

  public Optional<Einzelnote> findEinzelnoteById(UUID id) {
    return this.einzelnotenRepo.findById(id);
  }

  public Notenblatt saveNotenblatt(Notenblatt notenblatt) {
    return notenblaetterRepo.save(notenblatt);
  }

  public Einzelnote saveEinzelnote(Einzelnote einzelnote) {
    return einzelnotenRepo.save(einzelnote);
  }

  public List<Einzelnote> saveAllEinzelnoten(List<Einzelnote> einzelnoten) {
    return einzelnotenRepo.saveAll(einzelnoten);
  }

  public LauflisteDTO updateLauflisteStatus(UUID lauflistenId, LauflisteDTO lauflisteDto) {
    Optional<Laufliste> lauflisteOpt = findLauflisteById(lauflistenId);
    if (lauflisteOpt.isPresent()) {
      Laufliste laufliste = lauflisteOpt.get();
      laufliste.setErfasst(lauflisteDto.isErfasst());
      laufliste.setChecked(lauflisteDto.isChecked());
      saveLaufliste(laufliste);
      return lauflisteDto;
    } else {
      throw new NotFoundException(Laufliste.class, lauflisteDto.getId().toString());
    }
  }

  public LauflistenEintragDTO saveLauflistenEintrag(UUID lauflisteneintragId,
      LauflistenEintragDTO lauflistenEintragDto) {
    Optional<TeilnehmerAnlassLink> talOpt = talService.findTeilnehmerAnlassLinkById(
        lauflistenEintragDto.getTal_id());
    Optional<Laufliste> lauflisteOpt = findLauflisteById(lauflistenEintragDto.getLaufliste_id());
    if (talOpt.isPresent() && lauflisteOpt.isPresent()) {
      TeilnehmerAnlassLink tal = talOpt.get();
      Laufliste laufliste = lauflisteOpt.get();
      Einzelnote einzelnote = tal.getNotenblatt().getEinzelnoteForGeraet(laufliste.getGeraet());
      einzelnote.setChecked(lauflistenEintragDto.isChecked());
      if (GeraetEnum.BARREN.equals(laufliste.getGeraet()) && TiTuEnum.Ti.equals(
          tal.getTeilnehmer().getTiTu())) {
        einzelnote.setNote_1(0);
        einzelnote.setNote_2(0);
        einzelnote.setErfasst(true);
        einzelnote.setChecked(true);
      } else {
        einzelnote.setNote_1(lauflistenEintragDto.getNote_1());
        einzelnote.setNote_2(lauflistenEintragDto.getNote_2());
        if (einzelnote.getNote_1() >= 0
            && ((einzelnote.getNote_2() >= 0) || !GeraetEnum.SPRUNG.equals(
            laufliste.getGeraet()))) {
          einzelnote.setErfasst(true);
        } else {
          einzelnote.setErfasst(false);
        }
      }
      einzelnote = saveEinzelnote(einzelnote);
      if (!(GeraetEnum.BARREN.equals(laufliste.getGeraet())
          && TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu()))) {
        Notenblatt notenblatt = updateNotenblatt(tal.getNotenblatt(), tal.getKategorie());
        saveNotenblatt(notenblatt);
      }
      if (tal.isDeleted() && !lauflistenEintragDto.isDeleted()) {
        tal.setDeleted(false);
        tal.setMeldeStatus(MeldeStatusEnum.STARTET);
        talService.save(tal);
      }
      return LauflistenEintragDTO.builder().id(tal.getId())
          .laufliste_id(laufliste.getId())
          .startnummer(tal.getStartnummer()).verein(tal.getOrganisation().getName())
          .name(tal.getTeilnehmer().getName()).vorname(tal.getTeilnehmer().getVorname())
          .note_1(einzelnote.getNote_1()).note_2(einzelnote.getNote_2())
          .checked(einzelnote.isChecked())
          .erfasst(einzelnote.isErfasst()).tal_id(tal.getId()).deleted(tal.isDeleted()).build();
    } else {
      throw new NotFoundException(Laufliste.class,
          lauflistenEintragDto.getLaufliste_id().toString());
    }
  }

  private Notenblatt updateNotenblatt(Notenblatt notenblatt, KategorieEnum kategorie) {
    List<Einzelnote> einzelnoten = notenblatt.getEinzelnoten();
    float gesamtPunktzahl = 0.0f;
    for (Einzelnote einzelnote : einzelnoten) {
      float note = einzelnote.getNote_1();
      if (GeraetEnum.SPRUNG.equals(einzelnote.getGeraet())) {
        if (kategorie.ordinal() == KategorieEnum.K6.ordinal()
            || kategorie.ordinal() == KategorieEnum.K7.ordinal()) {
          note += einzelnote.getNote_2();
          note = note / 2;
        } else {
          if (note < einzelnote.getNote_2()) {
            note = einzelnote.getNote_2();
          }
        }
        einzelnote.setZaehlbar(note);
      }
      gesamtPunktzahl += note;
    }
    notenblatt.setGesamtPunktzahl(gesamtPunktzahl);
    return notenblatt;
  }

 @Transactional
  public Laufliste saveLaufliste(Laufliste laufliste) {
    return lauflistenRepo.save(laufliste);
  }

  @Transactional
  public List<Laufliste> saveAllLauflisten(List<Laufliste> lauflisten) {
    return lauflistenRepo.saveAll(lauflisten);
  }

  @Transactional
  public LauflistenContainer saveLauflistenContainer(LauflistenContainer lauflistenContainer) {
    return lauflistenContainerRepo.save(lauflistenContainer);
  }

  public LauflistenStatusDTO findLauflistenStatusForAnlassAndKategorie(UUID anlassId,
      KategorieEnum kategorie,
      TiTuEnum titu) {
    Anlass anlass = anlassService.findById(anlassId);
    List<LauflistenContainer> containerList = lauflistenContainerRepo
        .findByAnlassAndKategorieOrderByStartgeraetAsc(anlass, kategorie);
    containerList = containerList.stream().filter(container -> {
      if (container.getTeilnehmerAnlassLinks() != null
          && !container.getTeilnehmerAnlassLinks().isEmpty()) {
        TiTuEnum tiTuLocal = container.getTeilnehmerAnlassLinks().getFirst().getTeilnehmer()
            .getTiTu();
        return titu.equals(tiTuLocal);
      }
      return false;
    }).toList();
    long checkedCount = containerList.stream()
        .filter(container -> container.getGeraeteLauflisten().stream().allMatch(
            Laufliste::isChecked)).count();
    long erfasstCount = containerList.stream().filter(container ->
        container.getGeraeteLauflisten().stream().allMatch(Laufliste::isErfasst)).count();
    LauflistenStatusDTO lauflistenStatusDto = new LauflistenStatusDTO();
    lauflistenStatusDto.setAllChecked(containerList.size() == checkedCount);
    lauflistenStatusDto.setAllErfasst(containerList.size() == erfasstCount);
    return lauflistenStatusDto;
  }

  public List<LauflistenContainer> findLauflistenForAnlassAndKategorie(UUID anlassId,
      KategorieEnum kategorie,
      AbteilungEnum abteilung, AnlageEnum anlage) {
    Anlass anlass = anlassService.findById(anlassId);
    List<LauflistenContainer> existierende = lauflistenContainerRepo
        .findByAnlassAndKategorieOrderByStartgeraetAsc(anlass, kategorie);
    log.debug("Found {} Lauflisten for Anlass {} , Kategorie {} , Abteilung {} , Anlage {}",
        existierende.size(),
        anlass.getAnlassBezeichnung(), kategorie.toString(), abteilung.toString(),
        anlage.toString());
    existierende = existierende.stream().filter(container -> {
      if (container.getTeilnehmerAnlassLinks() != null
          && !container.getTeilnehmerAnlassLinks().isEmpty()
          && container.getTeilnehmerAnlassLinks().getFirst().getAbteilung() != null) {
        if (abteilung.equals(AbteilungEnum.UNDEFINED)
            || container.getTeilnehmerAnlassLinks().getFirst().getAbteilung().equals(abteilung)) {
          if (anlage.equals(AnlageEnum.UNDEFINED)
              || container.getTeilnehmerAnlassLinks().getFirst().getAnlage().equals(anlage)) {
            return true;
          }
        }
      }
      return false;
    }).toList();
    return existierende;
  }

  public AnlassLauflisten generateLauflistenForAnlassAndKategorie(UUID anlassId,
      KategorieEnum kategorie,
      AbteilungEnum abteilung, AnlageEnum anlage, boolean tiOnly) throws ServiceException {
    Anlass anlass = anlassService.findById(anlassId);
    List<LauflistenContainer> existierende = findLauflistenForAnlassAndKategorie(anlassId,
        kategorie,
        abteilung,
        anlage);
    if (!existierende.isEmpty()) {
      throw new ServiceException(LauflistenService.class,
          "Es existieren schon Lauflisten für Anlass {} und Kategorie {}".formatted(
              anlass.getAnlassBezeichnung(), kategorie));
    }
    try {
      List<TeilnehmerAnlassLink> tals = talService.findAnlassTeilnahmenByKategorie(anlass,
          kategorie);
      AnlassLauflisten anlasslaufListen = new AnlassLauflisten();
      for (TeilnehmerAnlassLink tal : tals) {
        if (tal.getAbteilung() != null && tal.getAnlage() != null && tal.getStartgeraet() != null
            && (abteilung.equals(AbteilungEnum.UNDEFINED) || tal.getAbteilung().equals(abteilung))
            && (anlage.equals(AnlageEnum.UNDEFINED) || tal.getAnlage().equals(anlage))
            && tal.getMeldeStatus() != MeldeStatusEnum.ABGEMELDET_1
            && tal.getMeldeStatus() != MeldeStatusEnum.ABGEMELDET_2
            && tal.getMeldeStatus() != MeldeStatusEnum.ABGEMELDET_3
            && tal.getMeldeStatus() != MeldeStatusEnum.UMMELDUNG) {
          tal = this.createNotenblatt(tal);
          TiTuEnum titu = anlass.getTiTu();
          if (tiOnly) {
            titu = TiTuEnum.Ti;
          }
          anlasslaufListen.createFromTal(lauflistenRepo, titu, tal, abteilung, anlage);
        }
      }
      persistLauflisten(anlasslaufListen);
      return anlasslaufListen;
    } catch (Exception ex) {
      ex.printStackTrace();
      throw new ServiceException(LauflistenService.class,
          "Fehler beim generieren von Lauflisten für Anlass {} und Kategorie {}, {}".formatted(
              anlass.getAnlassBezeichnung(), kategorie, ex.getMessage()));
    }
  }

  public List<LauflistenContainer> getLauflistenForAnlassAndKategorie(UUID anlassId,
      KategorieEnum kategorie,
      AbteilungEnum abteilung, AnlageEnum anlage) {
    return findLauflistenForAnlassAndKategorie(anlassId, kategorie,
        abteilung,
        anlage);
  }

  public int deleteLauflistenForAnlassAndKategorie(UUID anlassId, KategorieEnum kategorie,
      AbteilungEnum abteilung,
      AnlageEnum anlage) throws ServiceException {
    List<LauflistenContainer> existierende = findLauflistenForAnlassAndKategorie(anlassId,
        kategorie,
        abteilung,
        anlage);
    List<Notenblatt> notenblaetter = new ArrayList<Notenblatt>();
    existierende.forEach(container -> {
      container.getTeilnehmerAnlassLinks().forEach(tal -> {
        if (abteilung.equals(AbteilungEnum.UNDEFINED) || tal.getAbteilung().equals(abteilung)) {
          tal.setLauflistenContainer(null);
          talService.save(tal);
          notenblaetter.add(tal.getNotenblatt());
          tal.setNotenblatt(null);
        }
      });
    });
    notenblaetterRepo.deleteAll(notenblaetter);
    lauflistenContainerRepo.deleteAll(existierende);
    return existierende.size();
  }

  private TeilnehmerAnlassLink createNotenblatt(TeilnehmerAnlassLink tal) {
    Notenblatt notenblatt = new Notenblatt();
    List<Einzelnote> einzelnoten = new ArrayList<>();
    notenblatt.setEinzelnoten(einzelnoten);
    notenblatt.setTal(tal);
    tal.setNotenblatt(notenblatt);
    GeraetEnum[] values = GeraetEnum.values();
    for (GeraetEnum value : values) {
      if (GeraetEnum.UNDEFINED.equals(value)) {
        continue;
      }
      Einzelnote einzelnote = new Einzelnote();
      einzelnote.setNotenblatt(notenblatt);
      einzelnote.setGeraet(value);
      einzelnoten.add(einzelnote);
    }
    return tal;
  }

  public Laufliste findLauflistenForSearch(String search) {
    Optional<Laufliste> lauflistenOpt = lauflistenRepo.findByKey(search);
    return lauflistenOpt.orElseThrow(() -> new NotFoundException(Laufliste.class, search));
  }

  public AnlassLauflisten generateLauflistenPdfForAnlassAndKategorie(UUID anlassId,
      KategorieEnum kategorie, AbteilungEnum abteilung, AnlageEnum anlage,
      Optional<Boolean> optOnlyTi)
      throws ServiceException {
    boolean onlyTi = optOnlyTi.orElse(false);
    AnlassLauflisten anlassLauflisten = generateLauflistenForAnlassAndKategorie(anlassId, kategorie,
        abteilung, anlage, onlyTi);
    anlassLauflisten.getLauflistenContainer().stream().forEach(container -> {
      saveAllLauflisten(container.getGeraeteLauflisten());
      container.getGeraeteLauflisten().stream().forEach(laufliste -> {
        laufliste.getEinzelnoten().stream().forEach(einzelnote -> {
          Einzelnote note = findEinzelnoteById(einzelnote.getId()).get();
          note.setStartOrder(einzelnote.getStartOrder());
          saveEinzelnote(note);
        });
      });
    });
    return anlassLauflisten;
  }

  public List<LauflisteDTO> getLauflistenDtosForFilter(UUID anlassId, KategorieEnum kategorie,
      AbteilungEnum abteilung, AnlageEnum anlage) {
    List<LauflistenContainer> listen = getLauflistenForAnlassAndKategorie(
        anlassId, kategorie,
        abteilung, anlage);
    List<Laufliste> alle = new ArrayList<>();
    for (LauflistenContainer container : listen) {
      alle.addAll(container.getGeraeteLauflisten());
    }

    return alle.stream()
        .map(laufliste -> LauflisteDTO.builder().laufliste(laufliste.getKey()).abteilung(abteilung)
            .anlage(anlage)
            .geraet(laufliste.getGeraet()).id(laufliste.getId()).erfasst(laufliste.isErfasst())
            .checked(laufliste.isChecked()).abloesung(laufliste.getAbloesung()).build())
        .collect(Collectors.toList());
  }

  private void persistLauflisten(AnlassLauflisten anlassLaufListen) {
    List<LauflistenContainer> concated = anlassLaufListen.getLauflistenContainer();
    log.debug("Anzahl Elements {}", concated.size());
    lauflistenContainerRepo.saveAll(concated);
  }

  public LauflisteDTO findLauflisteDtoBySearch(String search) {
    Laufliste laufliste = findLauflistenForSearch(search);

    List<TeilnehmerAnlassLink> tals = laufliste.getLauflistenContainer()
        .getTeilnehmerAnlassLinks();
    if (tals == null || tals.size() == 0) {
      throw new NotFoundException(TeilnehmerAnlassLink.class,
          "Tals not found for Laufliste " + search);
    }
    TeilnehmerAnlassLink firstTal = tals.getFirst();

    List<LauflistenEintragDTO> eintraege = tals.stream().map(tal -> {
      Einzelnote einzelnote = tal.getNotenblatt().getEinzelnoteForGeraet(laufliste.getGeraet());

      return LauflistenEintragDTO.builder().id(tal.getId()).laufliste_id(laufliste.getId())
          .startnummer(tal.getStartnummer()).startOrder(einzelnote.getStartOrder())
          .verein(tal.getOrganisation().getName()).name(tal.getTeilnehmer().getName())
          .vorname(tal.getTeilnehmer().getVorname()).note_1(einzelnote.getNote_1())
          .note_2(einzelnote.getNote_2()).checked(einzelnote.isChecked())
          .erfasst(einzelnote.isErfasst())
          .tal_id(tal.getId()).deleted(tal.isDeleted()).build();
    }).collect(Collectors.toList());

    return LauflisteDTO.builder().laufliste(laufliste.getKey())
        .abteilung(firstTal.getAbteilung()).anlage(firstTal.getAnlage())
        .geraet(laufliste.getGeraet())
        .id(laufliste.getId()).eintraege(eintraege).erfasst(laufliste.isErfasst())
        .checked(laufliste.isChecked()).abloesung(laufliste.getAbloesung()).build();
  }
}
