package org.ztv.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.tuple;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.transfer.StartlisteDTO;
import org.ztv.anmeldetool.transfer.StartlisteDTO.VereinStarter;

class StartlisteServiceTest {

  private final Organisation moenchaltorf = Organisation.builder().name("Getu Mönchaltorf").build();
  private final Organisation mettmenstetten = Organisation.builder().name("TV Mettmenstetten ").build();
  private final Organisation niederglatt = Organisation.builder().name("Geräteriege Niederglatt").build();

  @Test
  void groupsByKategorieTiTuAndAbteilungAndCountsStartersPerVerein() {
    StartlisteDTO startliste = StartlisteService.build("Meeting", "Bülach", List.of(
        tal(KategorieEnum.K2, TiTuEnum.Tu, AbteilungEnum.ABTEILUNG_1, niederglatt),
        tal(KategorieEnum.K1, TiTuEnum.Tu, AbteilungEnum.ABTEILUNG_1, niederglatt),
        tal(KategorieEnum.K1, TiTuEnum.Ti, AbteilungEnum.ABTEILUNG_2, niederglatt),
        tal(KategorieEnum.K1, TiTuEnum.Ti, AbteilungEnum.ABTEILUNG_1, niederglatt),
        tal(KategorieEnum.K1, TiTuEnum.Ti, AbteilungEnum.ABTEILUNG_1, moenchaltorf),
        tal(KategorieEnum.K1, TiTuEnum.Ti, AbteilungEnum.ABTEILUNG_1, mettmenstetten),
        tal(KategorieEnum.K1, TiTuEnum.Ti, AbteilungEnum.ABTEILUNG_1, moenchaltorf)));

    assertThat(startliste.sections()).extracting(StartlisteDTO.Section::kategorie, StartlisteDTO.Section::tiTu)
        .containsExactly(
            tuple(KategorieEnum.K1, TiTuEnum.Ti),
            tuple(KategorieEnum.K1, TiTuEnum.Tu),
            tuple(KategorieEnum.K2, TiTuEnum.Tu));

    StartlisteDTO.Section k1Ti = startliste.sections().getFirst();
    assertThat(k1Ti.abteilungen()).extracting(StartlisteDTO.Abteilung::abteilung)
        .containsExactly(AbteilungEnum.ABTEILUNG_1, AbteilungEnum.ABTEILUNG_2);
    assertThat(k1Ti.abteilungen().getFirst().vereine()).containsExactly(
        new VereinStarter("Mettmenstetten", 1),
        new VereinStarter("Mönchaltorf", 2),
        new VereinStarter("Niederglatt", 1));
  }

  @Test
  void listsUnassignedAbteilungenLastAndSkipsKeinStart() {
    StartlisteDTO startliste = StartlisteService.build("Meeting", "Bülach", List.of(
        tal(KategorieEnum.K1, TiTuEnum.Ti, null, niederglatt),
        tal(KategorieEnum.K1, TiTuEnum.Ti, AbteilungEnum.UNDEFINED, niederglatt),
        tal(KategorieEnum.K1, TiTuEnum.Ti, AbteilungEnum.ABTEILUNG_3, niederglatt),
        tal(KategorieEnum.KEIN_START, TiTuEnum.Ti, AbteilungEnum.ABTEILUNG_1, niederglatt)));

    assertThat(startliste.sections()).hasSize(1);
    assertThat(startliste.sections().getFirst().abteilungen()).extracting(StartlisteDTO.Abteilung::abteilung)
        .containsExactly(AbteilungEnum.ABTEILUNG_3, AbteilungEnum.UNDEFINED, null);
  }

  private static TeilnehmerAnlassLink tal(KategorieEnum kategorie, TiTuEnum tiTu, AbteilungEnum abteilung,
      Organisation organisation) {
    TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
    tal.setKategorie(kategorie);
    tal.setAbteilung(abteilung);
    tal.setOrganisation(organisation);
    tal.setTeilnehmer(Teilnehmer.builder().name("Name").vorname("Vorname").tiTu(tiTu).build());
    return tal;
  }
}
