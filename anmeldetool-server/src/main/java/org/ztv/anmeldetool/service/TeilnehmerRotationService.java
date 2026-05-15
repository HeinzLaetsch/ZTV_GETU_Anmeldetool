package org.ztv.anmeldetool.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service("teilnehmerRotationService")
@Slf4j
@RequiredArgsConstructor

public class TeilnehmerRotationService {
  public final AnlassService anlassSrv;
  public final TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

  public List<TeilnehmerAnlassLink> rotateTeilnehmer(Anlass anlass, List<TeilnehmerAnlassLink> tals) {
    Map<KategorieEnum, Anlass> vorherigeAnlaesse = getVorherigeAnlaesse(anlass);
    tals = rotateTeilnehmerTiTu(vorherigeAnlaesse, tals, TiTuEnum.Ti);
    tals = rotateTeilnehmerTiTu(vorherigeAnlaesse, tals, TiTuEnum.Tu);
    return tals;
  }
  public List<TeilnehmerAnlassLink> rotateTeilnehmerTiTu(Map<KategorieEnum, Anlass> vorherigeAnlaesse, List<TeilnehmerAnlassLink> tals, TiTuEnum tiTu) {
    Map<KategorieEnum, AbteilungEnum> numberOfAbteilungen = getAnzahlAbteilungPerKategorie(vorherigeAnlaesse, tiTu);
    Map<KategorieEnum, Map<Organisation, AbteilungStartgeraet>> result = getAbteilungenForVereine(vorherigeAnlaesse, tiTu);
    tals = rotateAbteilungAndStartgeraet(tals, numberOfAbteilungen, result, tiTu);
    return tals;
  }

  private List<TeilnehmerAnlassLink> rotateAbteilungAndStartgeraet(List<TeilnehmerAnlassLink> tals,
      Map<KategorieEnum, AbteilungEnum> numberOfAbteilungen,
      Map<KategorieEnum, Map<Organisation, AbteilungStartgeraet>> result, TiTuEnum tiTu) {
    tals.stream().filter(tal -> tal.getTeilnehmer().getTiTu().equals(tiTu)).forEach(tal -> {
      KategorieEnum k = tal.getKategorie();
      AbteilungEnum maxAbteilung = numberOfAbteilungen.get(k);
      if (AbteilungEnum.UNDEFINED.equals(maxAbteilung)) {
        maxAbteilung = AbteilungEnum.UNDEFINED;
      }
      if (result.containsKey(k)) {
        Map<Organisation, AbteilungStartgeraet> abteilungen = result.get(k);
        if (tal.getOrganisation() != null && abteilungen.containsKey(tal.getOrganisation())) {
          AbteilungStartgeraet abteilungStargeraet = abteilungen.get(tal.getOrganisation());
          AbteilungEnum newAbteilung;
          if (AbteilungEnum.UNDEFINED.equals(abteilungStargeraet.abteilungEnum)) {
            newAbteilung = AbteilungEnum.UNDEFINED;
          } else {
            if (KategorieEnum.K6.equals(tal.getKategorie())) {
              System.out.println(tal.getTeilnehmer().getName()+ " "+tal.getTeilnehmer().getName().equals("Cides"));
              if (tal.getTeilnehmer().getName().equals("Cides")) {
                System.out.println("Found");
              }
            }
            int newOrd = abteilungStargeraet.abteilungEnum.ordinal() + 1;
            if (newOrd > maxAbteilung.ordinal()) {
              newAbteilung = AbteilungEnum.values()[0];
            } else {
              newAbteilung = AbteilungEnum.values()[newOrd];
            }
          }
          if (abteilungStargeraet.geraetEnum != null && !abteilungStargeraet.geraetEnum.equals(GeraetEnum.UNDEFINED)) {
            tal.setStartgeraet(getNextGeraet(abteilungStargeraet.geraetEnum, abteilungStargeraet.hasBarren));
          }
          tal.setAnlage(abteilungStargeraet.anlageEnum);
          tal.setAbteilung(newAbteilung);
        }
      }
    });
    return tals;
  }

  private GeraetEnum getNextGeraet(GeraetEnum aktuell, boolean includeBarren) {
    GeraetEnum[] values = GeraetEnum.values();
    int nextIndex = (aktuell.ordinal() + 1);
    if (nextIndex ==  GeraetEnum.BARREN.ordinal() && !includeBarren) {
      nextIndex = GeraetEnum.UNDEFINED.ordinal();
    }

    GeraetEnum neu = values[nextIndex];
    if (GeraetEnum.BARREN.equals(neu)) {
      System.out.println("Found");
    }

    return neu == GeraetEnum.UNDEFINED ? GeraetEnum.RECK : neu;
  }
/*
  private GeraetEnum getNextGeraet(GeraetEnum aktuell, boolean includeBarren) {
    GeraetEnum neu = GeraetEnum.values()[aktuell.ordinal() + 1];
    if (includeBarren && GeraetEnum.UNDEFINED.equals(neu)) {
      neu = GeraetEnum.RECK;
    } else if (!includeBarren && GeraetEnum.BARREN.equals(neu)) {
      neu = GeraetEnum.RECK;
    }
    return neu;
  }
*/
  private Map<KategorieEnum, Map<Organisation, AbteilungStartgeraet>> getAbteilungenForVereine(Map<KategorieEnum, Anlass> vorherigeAnlaesse, TiTuEnum tiTu) {
    Map<KategorieEnum, Map<Organisation, AbteilungStartgeraet>> result = new HashMap<>();
    vorherigeAnlaesse.forEach((k, a) -> {
      Map<Organisation, AbteilungStartgeraet> abteilungen = getAbteilungenForVereineByKategorie(a, k, tiTu);
      result.put(k, abteilungen);
    });
    return result;
  }

  private Map<KategorieEnum, Anlass> getVorherigeAnlaesse(Anlass anlass) {
    Map<KategorieEnum, Anlass> vorherigeAnlaesse = KategorieEnum.stream()
        .filter(k -> k.ordinal() >= anlass.getTiefsteKategorie().ordinal() &&
            k.ordinal() <= anlass.getHoechsteKategorie().ordinal())
        .collect(Collectors.toMap(
            k -> k,
            k -> anlassSrv.findPreviousAnlass(anlass, k).orElse(null)
        ));
    return vorherigeAnlaesse;
  }

  private Map<KategorieEnum, AbteilungEnum> getAnzahlAbteilungPerKategorie(Map<KategorieEnum, Anlass> vorherigeAnlaesse, TiTuEnum tiTu) {
    Map<KategorieEnum, AbteilungEnum> result = new HashMap<>();
    vorherigeAnlaesse.forEach((k, a) -> {
      if (a != null) {
        AbteilungEnum highestAbteilung = getAnzahlAbteilungenForKategorie(a, k, tiTu);
        result.put(k, highestAbteilung);
      }
    });
    return result;
  }

  private AbteilungEnum getAnzahlAbteilungenForKategorie(Anlass anlass, KategorieEnum kategorieEnum, TiTuEnum tiTu) {
    List<AbteilungEnum> alle = teilnehmerAnlassLinkRepository.findDistinctAbteilungenByAnlassAndKategorieAndTiTu(anlass, kategorieEnum, tiTu);
    if (alle.isEmpty()) {
      return AbteilungEnum.UNDEFINED;
    }
    return alle.getLast();
  }

  private Map<Organisation, AbteilungStartgeraet> getAbteilungenForVereineByKategorie(Anlass anlass, KategorieEnum k, TiTuEnum tiTu) {
    List<Object[]> abteilungForVereine = teilnehmerAnlassLinkRepository.findDistinctAbteilungenUndOrganisatorenByAnlassAndKategorie(anlass,
        k, tiTu);
    // TODO Debug
    if(KategorieEnum.K5B.equals(k)) {
      System.out.println("Found");
    }

    boolean hasBarren = abteilungForVereine.stream().filter(o -> GeraetEnum.BARREN.equals(o[3])).count()>0;
    Map<Organisation, AbteilungStartgeraet> result = new HashMap<>();
    abteilungForVereine.stream()
        .filter(afv -> afv[1] != null)
        .forEach(o -> result.put((Organisation) o[0], new AbteilungStartgeraet((AbteilungEnum) o[1],(AnlageEnum) o[2], (GeraetEnum) o[3], hasBarren)));
    return result;
  }

  private record AbteilungStartgeraet(AbteilungEnum abteilungEnum, AnlageEnum anlageEnum, GeraetEnum geraetEnum, boolean hasBarren){};
}
