package org.ztv.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.assertj.core.api.Assertions.tuple;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.IntStream;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.TimeplanVorschlag;
import org.ztv.anmeldetool.repositories.TimeplanVorschlagRepository;
import org.ztv.anmeldetool.service.TimeplanService.Berechnung;
import org.ztv.anmeldetool.transfer.TimeplanInputDTO;
import org.ztv.anmeldetool.transfer.TimeplanVorschlagDTO;

class TimeplanServiceTest {

  private final UUID anlassId = UUID.randomUUID();
  private final Anlass anlass = new Anlass();
  private final AnlassService anlassService = mock(AnlassService.class);
  private final TeilnehmerAnlassLinkService teilnehmerAnlassLinkService = mock(TeilnehmerAnlassLinkService.class);
  private final TimeplanVorschlagRepository repository = mock(TimeplanVorschlagRepository.class);
  private final TimeplanService service = new TimeplanService(anlassService, teilnehmerAnlassLinkService, repository);

  @BeforeEach
  void setUp() {
    when(anlassService.findById(anlassId)).thenReturn(anlass);
  }

  @Test
  void prefersGroupSizeClosestToNineThenFewestAbteilungenThenFewestAnlagen() {
    assertThat(TimeplanService.berechne(90, 4, 6, 8)).isEqualTo(new Berechnung(90, 10, 3, 1));
    assertThat(TimeplanService.berechne(90, 4, 1, 8)).isEqualTo(new Berechnung(90, 10, 1, 3));
  }

  @Test
  void turnerNeedFewerAnlagenBecauseTheyHaveFiveGeraete() {
    Berechnung turnerinnen = TimeplanService.berechne(150, 4, 6, 8);
    Berechnung turner = TimeplanService.berechne(150, 5, 6, 8);

    assertThat(turnerinnen).isEqualTo(new Berechnung(150, 17, 5, 1));
    assertThat(turner).isEqualTo(new Berechnung(150, 17, 4, 1));
    assertThat(turnerinnen.gruppenGroesseMin()).isEqualTo(8);
    assertThat(turnerinnen.gruppenGroesseMax()).isEqualTo(9);
    assertThat(turnerinnen.gruppenProAnlage()).isEqualTo(4);
  }

  @Test
  void usesLargerGroupsWhenTheMaximaAreTooSmall() {
    Berechnung berechnung = TimeplanService.berechne(200, 5, 2, 2);

    assertThat(berechnung).isEqualTo(new Berechnung(200, 20, 2, 2));
    assertThat(berechnung.gruppenGroesseMax()).isEqualTo(10);
  }

  @Test
  void handlesSmallAndEmptyKategorien() {
    assertThat(TimeplanService.berechne(7, 4, 6, 8)).isEqualTo(new Berechnung(7, 1, 1, 1));
    assertThat(TimeplanService.berechne(0, 4, 6, 8)).isEqualTo(new Berechnung(0, 0, 0, 0));
  }

  @Test
  void turnerinnenAndTurnerHaveTheirOwnGeraete() {
    assertThat(TimeplanService.geraete(TiTuEnum.Ti)).containsExactly(GeraetEnum.BODEN, GeraetEnum.RECK,
        GeraetEnum.SPRUNG, GeraetEnum.SCHAUKELRINGE);
    assertThat(TimeplanService.geraete(TiTuEnum.Tu)).containsExactly(GeraetEnum.BODEN, GeraetEnum.RECK,
        GeraetEnum.SPRUNG, GeraetEnum.SCHAUKELRINGE, GeraetEnum.BARREN);
  }

  @Test
  void proposesDefaultsPerKategorieAndTiTuAndReturnsStoredProposals() {
    List<TeilnehmerAnlassLink> teilnahmen = new ArrayList<>();
    teilnahmen.addAll(tals(KategorieEnum.K2, TiTuEnum.Tu, 20));
    teilnahmen.addAll(tals(KategorieEnum.K1, TiTuEnum.Ti, 90));
    teilnahmen.addAll(tals(KategorieEnum.K1, TiTuEnum.Tu, 12));
    teilnahmen.addAll(tals(KategorieEnum.KEIN_START, TiTuEnum.Ti, 5));
    when(teilnehmerAnlassLinkService.findAnlassTeilnahmen(anlassId)).thenReturn(teilnahmen);
    TimeplanVorschlag stored = vorschlag(KategorieEnum.K1, TiTuEnum.Tu, 1, 1, 10, 1, 1, 1);
    when(repository.findByAnlassId(anlassId)).thenReturn(List.of(stored));

    List<TimeplanVorschlagDTO> vorschlaege = service.getVorschlaege(anlassId);

    assertThat(vorschlaege)
        .extracting(TimeplanVorschlagDTO::kategorie, TimeplanVorschlagDTO::tiTu, TimeplanVorschlagDTO::maxAnlagen,
            TimeplanVorschlagDTO::anzahlTeilnehmer, TimeplanVorschlagDTO::aktuelleTeilnehmer,
            TimeplanVorschlagDTO::anzahlAnlagen, TimeplanVorschlagDTO::anzahlAbteilungen,
            TimeplanVorschlagDTO::gespeichert)
        .containsExactly(
            tuple(KategorieEnum.K1, TiTuEnum.Ti, 6, 90, 90, 3, 1, false),
            tuple(KategorieEnum.K1, TiTuEnum.Tu, 1, 10, 12, 1, 1, true),
            tuple(KategorieEnum.K2, TiTuEnum.Tu, 6, 20, 20, 1, 1, false));
  }

  @Test
  void storesCalculatedProposalForTheGivenMaxima() throws ServiceException {
    when(teilnehmerAnlassLinkService.findAnlassTeilnahmen(anlassId))
        .thenReturn(tals(KategorieEnum.K1, TiTuEnum.Ti, 90));
    when(repository.findByAnlassId(anlassId)).thenReturn(List.of());

    service.speichereVorschlaege(anlassId, List.of(new TimeplanInputDTO(KategorieEnum.K1, TiTuEnum.Ti, 1, 8)));

    ArgumentCaptor<TimeplanVorschlag> captor = ArgumentCaptor.forClass(TimeplanVorschlag.class);
    verify(repository).save(captor.capture());
    TimeplanVorschlag saved = captor.getValue();
    assertThat(saved.getAnlass()).isSameAs(anlass);
    assertThat(saved.isAktiv()).isTrue();
    assertThat(saved).extracting(TimeplanVorschlag::getKategorie, TimeplanVorschlag::getTiTu,
        TimeplanVorschlag::getMaxAnlagen, TimeplanVorschlag::getMaxAbteilungen, TimeplanVorschlag::getAnzahlTeilnehmer,
        TimeplanVorschlag::getAnzahlGruppen, TimeplanVorschlag::getAnzahlAnlagen,
        TimeplanVorschlag::getAnzahlAbteilungen)
        .containsExactly(KategorieEnum.K1, TiTuEnum.Ti, 1, 8, 90, 10, 1, 3);
  }

  @Test
  void rejectsMaximaOutsideTheAvailableAnlagenAndAbteilungen() {
    assertThatThrownBy(() -> service.speichereVorschlaege(anlassId,
        List.of(new TimeplanInputDTO(KategorieEnum.K1, TiTuEnum.Ti, 7, 1)))).isInstanceOf(ServiceException.class);
    assertThatThrownBy(() -> service.speichereVorschlaege(anlassId,
        List.of(new TimeplanInputDTO(KategorieEnum.K1, TiTuEnum.Ti, 1, 0)))).isInstanceOf(ServiceException.class);
    assertThatThrownBy(() -> service.speichereVorschlaege(anlassId,
        List.of(new TimeplanInputDTO(KategorieEnum.K1, TiTuEnum.Alle, 1, 1)))).isInstanceOf(ServiceException.class);
    verify(repository, never()).save(any());
  }

  private static List<TeilnehmerAnlassLink> tals(KategorieEnum kategorie, TiTuEnum tiTu, int anzahl) {
    return IntStream.range(0, anzahl).mapToObj(i -> {
      TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
      tal.setKategorie(kategorie);
      tal.setTeilnehmer(Teilnehmer.builder().name("Name" + i).vorname("Vorname").tiTu(tiTu).build());
      return tal;
    }).toList();
  }

  private static TimeplanVorschlag vorschlag(KategorieEnum kategorie, TiTuEnum tiTu, int maxAnlagen,
      int maxAbteilungen, int teilnehmer, int gruppen, int anlagen, int abteilungen) {
    TimeplanVorschlag vorschlag = new TimeplanVorschlag();
    vorschlag.setKategorie(kategorie);
    vorschlag.setTiTu(tiTu);
    vorschlag.setMaxAnlagen(maxAnlagen);
    vorschlag.setMaxAbteilungen(maxAbteilungen);
    vorschlag.setAnzahlTeilnehmer(teilnehmer);
    vorschlag.setAnzahlGruppen(gruppen);
    vorschlag.setAnzahlAnlagen(anlagen);
    vorschlag.setAnzahlAbteilungen(abteilungen);
    return vorschlag;
  }
}
