package org.ztv.anmeldetool.service;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.transfer.StartlisteDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StartlisteService {

  private static final Collator VEREIN_COLLATOR = Collator.getInstance(Locale.of("de", "CH"));

  // Unassigned (null / UNDEFINED) Abteilungen are listed last.
  private static final Comparator<AbteilungEnum> ABTEILUNG_ORDER = Comparator.nullsLast(
      Comparator.comparing((AbteilungEnum abteilung) -> abteilung == AbteilungEnum.UNDEFINED)
          .thenComparing(Comparator.naturalOrder()));

  private final AnlassService anlassService;
  private final TeilnehmerAnlassLinkService teilnehmerAnlassLinkService;

  @Transactional(readOnly = true)
  public StartlisteDTO getStartliste(UUID anlassId) {
    Anlass anlass = anlassService.findById(anlassId);
    List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkService.findAnlassTeilnahmen(anlassId);
    return build(anlass.getAnlassBezeichnung(), anlass.getOrt(), teilnahmen);
  }

  static StartlisteDTO build(String anlassBezeichnung, String ort, List<TeilnehmerAnlassLink> teilnahmen) {
    Map<KategorieEnum, Map<TiTuEnum, List<TeilnehmerAnlassLink>>> byKategorieAndTiTu = teilnahmen.stream()
        .filter(tal -> tal.getKategorie() != null && tal.getKategorie() != KategorieEnum.KEIN_START)
        .collect(Collectors.groupingBy(TeilnehmerAnlassLink::getKategorie, TreeMap::new,
            Collectors.groupingBy(tal -> tal.getTeilnehmer().getTiTu(), TreeMap::new, Collectors.toList())));

    List<StartlisteDTO.Section> sections = byKategorieAndTiTu.entrySet().stream()
        .flatMap(kategorie -> kategorie.getValue().entrySet().stream()
            .map(tiTu -> new StartlisteDTO.Section(kategorie.getKey(), tiTu.getKey(),
                toAbteilungen(tiTu.getValue()))))
        .toList();
    return new StartlisteDTO(anlassBezeichnung, ort, sections);
  }

  private static List<StartlisteDTO.Abteilung> toAbteilungen(List<TeilnehmerAnlassLink> teilnahmen) {
    Map<AbteilungEnum, List<TeilnehmerAnlassLink>> byAbteilung = new TreeMap<>(ABTEILUNG_ORDER);
    teilnahmen.forEach(tal -> byAbteilung.computeIfAbsent(tal.getAbteilung(), key -> new ArrayList<>())
        .add(tal));

    return byAbteilung.entrySet().stream()
        .map(entry -> new StartlisteDTO.Abteilung(entry.getKey(), toVereine(entry.getValue())))
        .toList();
  }

  private static List<StartlisteDTO.VereinStarter> toVereine(List<TeilnehmerAnlassLink> teilnahmen) {
    Map<String, Long> countByVerein = teilnahmen.stream()
        .collect(Collectors.groupingBy(tal -> tal.getOrganisation().cleanName().strip(), Collectors.counting()));

    return countByVerein.entrySet().stream()
        .sorted(Map.Entry.comparingByKey(VEREIN_COLLATOR))
        .map(entry -> new StartlisteDTO.VereinStarter(entry.getKey(), entry.getValue()))
        .toList();
  }
}
