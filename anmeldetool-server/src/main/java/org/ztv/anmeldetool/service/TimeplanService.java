package org.ztv.anmeldetool.service;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.TimeplanVorschlag;
import org.ztv.anmeldetool.repositories.TimeplanVorschlagRepository;
import org.ztv.anmeldetool.transfer.TimeplanInputDTO;
import org.ztv.anmeldetool.transfer.TimeplanVorschlagDTO;

import lombok.RequiredArgsConstructor;

/**
 * Proposes how many Anlagen and Abteilungen each Kategorie (Turnerinnen and Turner separately) needs. Teilnehmer
 * are not assigned; only the structure is calculated.
 */
@Service
@RequiredArgsConstructor
public class TimeplanService {

  static final int ZIEL_GRUPPEN_GROESSE = 9;
  static final int MAX_ANLAGEN = AnlageEnum.values().length - 1;
  static final int MAX_ABTEILUNGEN = AbteilungEnum.values().length - 1;

  static final List<GeraetEnum> GERAETE_TURNERINNEN = List.of(GeraetEnum.BODEN, GeraetEnum.RECK, GeraetEnum.SPRUNG,
      GeraetEnum.SCHAUKELRINGE);
  static final List<GeraetEnum> GERAETE_TURNER = List.of(GeraetEnum.BODEN, GeraetEnum.RECK, GeraetEnum.SPRUNG,
      GeraetEnum.SCHAUKELRINGE, GeraetEnum.BARREN);

  private static final double EPSILON = 1e-9;

  private final AnlassService anlassService;
  private final TeilnehmerAnlassLinkService teilnehmerAnlassLinkService;
  private final TimeplanVorschlagRepository timeplanRepository;

  record Key(KategorieEnum kategorie, TiTuEnum tiTu) implements Comparable<Key> {
    @Override
    public int compareTo(Key other) {
      return Comparator.comparing(Key::kategorie).thenComparing(Key::tiTu).compare(this, other);
    }
  }

  record Berechnung(int teilnehmer, int gruppen, int anlagen, int abteilungen) {
    int gruppenGroesseMin() {
      return gruppen == 0 ? 0 : teilnehmer / gruppen;
    }

    int gruppenGroesseMax() {
      return gruppen == 0 ? 0 : Math.ceilDiv(teilnehmer, gruppen);
    }

    int gruppenProAnlage() {
      return gruppen == 0 ? 0 : Math.ceilDiv(gruppen, anlagen * abteilungen);
    }
  }

  /**
   * Returns the stored proposals plus (unsaved) default proposals for every Kategorie/TiTu with Teilnehmer that has
   * no stored proposal yet.
   */
  @Transactional(readOnly = true)
  public List<TimeplanVorschlagDTO> getVorschlaege(UUID anlassId) {
    anlassService.findById(anlassId);
    Map<Key, Integer> teilnehmer = countTeilnehmer(teilnehmerAnlassLinkService.findAnlassTeilnahmen(anlassId));
    Map<Key, TimeplanVorschlag> gespeichert = timeplanRepository.findByAnlassId(anlassId).stream()
        .collect(Collectors.toMap(v -> new Key(v.getKategorie(), v.getTiTu()), Function.identity()));

    TreeMap<Key, TimeplanVorschlagDTO> result = new TreeMap<>();
    gespeichert.forEach((key, vorschlag) -> result.put(key, toDto(vorschlag, teilnehmer.getOrDefault(key, 0))));
    teilnehmer.forEach((key, anzahl) -> result.computeIfAbsent(key, k -> {
      Berechnung berechnung = berechne(anzahl, geraete(k.tiTu()).size(), MAX_ANLAGEN, MAX_ABTEILUNGEN);
      return toDto(k, MAX_ANLAGEN, MAX_ABTEILUNGEN, berechnung, anzahl, false);
    }));
    return List.copyOf(result.values());
  }

  /** Calculates the proposals for the given maxima with the current Teilnehmer counts and stores them. */
  @Transactional
  public List<TimeplanVorschlagDTO> speichereVorschlaege(UUID anlassId, List<TimeplanInputDTO> inputs)
      throws ServiceException {
    for (TimeplanInputDTO input : inputs) {
      validate(input);
    }
    Anlass anlass = anlassService.findById(anlassId);
    Map<Key, Integer> teilnehmer = countTeilnehmer(teilnehmerAnlassLinkService.findAnlassTeilnahmen(anlassId));
    Map<Key, TimeplanVorschlag> gespeichert = timeplanRepository.findByAnlassId(anlassId).stream()
        .collect(Collectors.toMap(v -> new Key(v.getKategorie(), v.getTiTu()), Function.identity()));

    for (TimeplanInputDTO input : inputs) {
      Key key = new Key(input.kategorie(), input.tiTu());
      Berechnung berechnung = berechne(teilnehmer.getOrDefault(key, 0), geraete(key.tiTu()).size(),
          input.maxAnlagen(), input.maxAbteilungen());
      TimeplanVorschlag vorschlag = gespeichert.computeIfAbsent(key, k -> {
        TimeplanVorschlag neu = new TimeplanVorschlag();
        neu.setAktiv(true);
        neu.setAnlass(anlass);
        neu.setKategorie(k.kategorie());
        neu.setTiTu(k.tiTu());
        return neu;
      });
      vorschlag.setMaxAnlagen(input.maxAnlagen());
      vorschlag.setMaxAbteilungen(input.maxAbteilungen());
      vorschlag.setAnzahlTeilnehmer(berechnung.teilnehmer());
      vorschlag.setAnzahlGruppen(berechnung.gruppen());
      vorschlag.setAnzahlAnlagen(berechnung.anlagen());
      vorschlag.setAnzahlAbteilungen(berechnung.abteilungen());
      timeplanRepository.save(vorschlag);
    }
    return getVorschlaege(anlassId);
  }

  /**
   * Finds the number of Gruppen, Anlagen and Abteilungen. Every Gerät of an Anlage holds at most one Gruppe per
   * Abteilung and every used Anlage/Abteilung holds at least one Gruppe. Preferred is the average Gruppen size
   * closest to {@value #ZIEL_GRUPPEN_GROESSE}, then the fewest Abteilungen, then the fewest Anlagen.
   */
  static Berechnung berechne(int teilnehmer, int geraete, int maxAnlagen, int maxAbteilungen) {
    if (teilnehmer <= 0) {
      return new Berechnung(0, 0, 0, 0);
    }
    int untereGruppen = teilnehmer / ZIEL_GRUPPEN_GROESSE;
    int obereGruppen = Math.ceilDiv(teilnehmer, ZIEL_GRUPPEN_GROESSE);
    Berechnung best = null;
    double bestAbweichung = Double.MAX_VALUE;
    // Iteration order (Abteilungen, Anlagen, Gruppen ascending) lets the first candidate win on equal deviation.
    for (int abteilungen = 1; abteilungen <= maxAbteilungen; abteilungen++) {
      for (int anlagen = 1; anlagen <= maxAnlagen; anlagen++) {
        int minGruppen = anlagen * abteilungen;
        int maxGruppen = Math.min(minGruppen * geraete, teilnehmer);
        if (minGruppen > maxGruppen) {
          continue;
        }
        for (int kandidat : new int[] { untereGruppen, obereGruppen }) {
          int gruppen = Math.clamp(kandidat, minGruppen, maxGruppen);
          double abweichung = Math.abs((double) teilnehmer / gruppen - ZIEL_GRUPPEN_GROESSE);
          if (abweichung < bestAbweichung - EPSILON) {
            bestAbweichung = abweichung;
            best = new Berechnung(teilnehmer, gruppen, anlagen, abteilungen);
          }
        }
      }
    }
    return best;
  }

  static List<GeraetEnum> geraete(TiTuEnum tiTu) {
    return tiTu.isTurner() ? GERAETE_TURNER : GERAETE_TURNERINNEN;
  }

  static Map<Key, Integer> countTeilnehmer(List<TeilnehmerAnlassLink> teilnahmen) {
    return teilnahmen.stream()
        .filter(tal -> tal.getKategorie() != null && tal.getKategorie() != KategorieEnum.KEIN_START)
        .filter(tal -> tal.getTeilnehmer() != null && tal.getTeilnehmer().getTiTu() != null)
        .collect(Collectors.groupingBy(tal -> new Key(tal.getKategorie(), tal.getTeilnehmer().getTiTu()),
            TreeMap::new, Collectors.summingInt(tal -> 1)));
  }

  private static void validate(TimeplanInputDTO input) throws ServiceException {
    if (input.kategorie() == null || input.kategorie() == KategorieEnum.KEIN_START || input.tiTu() == null
        || input.tiTu() == TiTuEnum.Alle) {
      throw new ServiceException(TimeplanService.class, "Ungültige Kategorie oder Turnerinnen/Turner");
    }
    if (input.maxAnlagen() < 1 || input.maxAnlagen() > MAX_ANLAGEN) {
      throw new ServiceException(TimeplanService.class,
          "Anzahl Anlagen muss zwischen 1 und " + MAX_ANLAGEN + " liegen");
    }
    if (input.maxAbteilungen() < 1 || input.maxAbteilungen() > MAX_ABTEILUNGEN) {
      throw new ServiceException(TimeplanService.class,
          "Anzahl Abteilungen muss zwischen 1 und " + MAX_ABTEILUNGEN + " liegen");
    }
  }

  private static TimeplanVorschlagDTO toDto(TimeplanVorschlag vorschlag, int aktuelleTeilnehmer) {
    Berechnung berechnung = new Berechnung(vorschlag.getAnzahlTeilnehmer(), vorschlag.getAnzahlGruppen(),
        vorschlag.getAnzahlAnlagen(), vorschlag.getAnzahlAbteilungen());
    return toDto(new Key(vorschlag.getKategorie(), vorschlag.getTiTu()), vorschlag.getMaxAnlagen(),
        vorschlag.getMaxAbteilungen(), berechnung, aktuelleTeilnehmer, true);
  }

  private static TimeplanVorschlagDTO toDto(Key key, int maxAnlagen, int maxAbteilungen, Berechnung berechnung,
      int aktuelleTeilnehmer, boolean gespeichert) {
    return new TimeplanVorschlagDTO(key.kategorie(), key.tiTu(), maxAnlagen, maxAbteilungen,
        berechnung.teilnehmer(), aktuelleTeilnehmer, berechnung.gruppen(), berechnung.gruppenGroesseMin(),
        berechnung.gruppenGroesseMax(), berechnung.anlagen(), berechnung.abteilungen(), berechnung.gruppenProAnlage(),
        geraete(key.tiTu()), gespeichert);
  }
}
