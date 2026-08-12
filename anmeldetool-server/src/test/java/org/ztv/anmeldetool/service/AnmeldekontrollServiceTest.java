package org.ztv.anmeldetool.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertIterableEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;
import org.ztv.anmeldetool.util.OrganisationPersonLinkMapper;

@ExtendWith(MockitoExtension.class)
class AnmeldekontrollServiceTest {

  @Mock
  private OrganisationPersonLinkMapper organisationPersonLinkMapper;

  @Mock
  private OrganisationAnlassLinkService organisationAnlassLinkService;

  @Mock
  private AnlassMapper anlassMapper;

  @Mock
  private OrganisationMapper organisationMapper;

  @Mock
  private PersonAnlassLinkService personAnlassLinkService;

  @Mock
  private AnlassService anlassService;

  @InjectMocks
  private AnmeldekontrolService anmeldekontrolService;

  @Test
  void sortParticipants_shouldSortAccordingToComparatorChain() {
    TeilnehmerAnlassLink tuK1 = createLink(
        TiTuEnum.Tu,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.BODEN);
    TeilnehmerAnlassLink tiK2 = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K2,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.BODEN);
    TeilnehmerAnlassLink tiAbteilung2 = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_2,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.BODEN);
    TeilnehmerAnlassLink tiAnlage2 = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_2,
        GeraetEnum.BODEN);
    TeilnehmerAnlassLink tiReck = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.RECK);
    TeilnehmerAnlassLink tiBoden = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.BODEN);

    List<TeilnehmerAnlassLink> participants = new ArrayList<>(
        List.of(tuK1, tiK2, tiAbteilung2, tiAnlage2, tiReck, tiBoden));

    Collections.shuffle(participants);

    List<TeilnehmerAnlassLink> sortedParticipants = anmeldekontrolService.sortParticipants(participants);

    //assertSame(participants, sortedParticipants);
    assertIterableEquals(
        List.of(tiReck, tiBoden, tuK1, tiAnlage2, tiAbteilung2, tiK2),
        sortedParticipants);
  }

  @Test
  void sortParticipants_shouldPlaceNullParticipantsAtTheBeginning() {
    TeilnehmerAnlassLink firstParticipant = createLink(
        TiTuEnum.Tu,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.BODEN);
    TeilnehmerAnlassLink secondParticipant = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.RECK);
    List<TeilnehmerAnlassLink> participants = new ArrayList<>(
        Arrays.asList(firstParticipant, null, secondParticipant));

    List<TeilnehmerAnlassLink> sortedParticipants = anmeldekontrolService.sortParticipants(participants);

    assertNotNull(sortedParticipants.getFirst());
    assertIterableEquals(Arrays.asList(secondParticipant, firstParticipant), sortedParticipants);
  }

  @Test
  void sortParticipants_shouldUseSubsequentFieldsForTieBreaking() {
    TeilnehmerAnlassLink laterStartgeraet = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.SPRUNG);
    TeilnehmerAnlassLink earlierAnlage = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.RECK);
    TeilnehmerAnlassLink laterAbteilung = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K1,
        AbteilungEnum.ABTEILUNG_2,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.BODEN);
    TeilnehmerAnlassLink laterKategorie = createLink(
        TiTuEnum.Ti,
        KategorieEnum.K2,
        AbteilungEnum.ABTEILUNG_1,
        AnlageEnum.ANLAGE_1,
        GeraetEnum.BODEN);

    List<TeilnehmerAnlassLink> participants = new ArrayList<>(
        List.of(laterStartgeraet, laterKategorie, laterAbteilung, earlierAnlage));

    List<TeilnehmerAnlassLink> sortedParticipants = anmeldekontrolService.sortParticipants(participants);

    assertIterableEquals(
        List.of(earlierAnlage, laterStartgeraet, laterAbteilung, laterKategorie),
        sortedParticipants);
  }

  @Test
  void getAufgeteilteRiegen_shouldKeepCategoryFalseWhenOrganisationStaysOnSameStation() {
    Anlass anlass = new Anlass();
    Organisation organisation = createOrganisation("TV Uster");
    List<TeilnehmerAnlassLink> participations = new ArrayList<>(List.of(
        createLink(TiTuEnum.Ti, KategorieEnum.K2, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, GeraetEnum.RECK),
        createLink(TiTuEnum.Ti, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, GeraetEnum.BODEN),
        createLink(TiTuEnum.Ti, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, GeraetEnum.BODEN),
        createLink(TiTuEnum.Tu, KategorieEnum.K2, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_2, GeraetEnum.BODEN),
        createLink(TiTuEnum.Tu, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_2, GeraetEnum.RECK),
        createLink(TiTuEnum.Tu, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_2, GeraetEnum.RECK)));

    Collections.shuffle(participations);

    when(organisationAnlassLinkService.getVereinsStarts(anlass)).thenReturn(List.of(organisation));
    when(anlassService.getTeilnahmen(anlass, organisation, true)).thenReturn(participations);

    Map<Organisation, HashMap<String, Boolean>> result =
        anmeldekontrolService.getAufgeteilteRiegen(anlass);

    assertEquals(1, result.size());
    assertFalse(result.get(organisation).get(TiTuEnum.Ti.name()+KategorieEnum.K1.name()));
    assertFalse(result.get(organisation).get(TiTuEnum.Ti.name()+KategorieEnum.K2.name()));
  }

  @Test
  void getAufgeteilteRiegen_shouldMarkCategoryTrueWhenStationChangesWithinCategory() {
    Anlass anlass = new Anlass();
    Organisation splitOrganisation = createOrganisation("TV Seen");
    Organisation singleOrganisation = createOrganisation("TV Wetzikon");
    List<TeilnehmerAnlassLink> splitParticipations = new ArrayList<>(List.of(
        createLink(TiTuEnum.Ti, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, GeraetEnum.BODEN),
        createLink(TiTuEnum.Ti, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, GeraetEnum.RECK),
        createLink(TiTuEnum.Ti, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, GeraetEnum.BODEN),
        createLink(TiTuEnum.Ti, KategorieEnum.K2, AbteilungEnum.ABTEILUNG_2, AnlageEnum.ANLAGE_2, GeraetEnum.SPRUNG),
        createLink(TiTuEnum.Ti, KategorieEnum.K2, AbteilungEnum.ABTEILUNG_2, AnlageEnum.ANLAGE_2, GeraetEnum.SPRUNG)));
    List<TeilnehmerAnlassLink> singleParticipations = new ArrayList<>(List.of(
        createLink(TiTuEnum.Tu, KategorieEnum.K3, AbteilungEnum.ABTEILUNG_3, AnlageEnum.ANLAGE_3, GeraetEnum.BARREN),
        createLink(TiTuEnum.Tu, KategorieEnum.K3, AbteilungEnum.ABTEILUNG_3, AnlageEnum.ANLAGE_4, GeraetEnum.BARREN),
        createLink(TiTuEnum.Ti, KategorieEnum.K3, AbteilungEnum.ABTEILUNG_3, AnlageEnum.ANLAGE_3, GeraetEnum.BODEN),
        createLink(TiTuEnum.Ti, KategorieEnum.K3, AbteilungEnum.ABTEILUNG_3, AnlageEnum.ANLAGE_3, GeraetEnum.BODEN)));

    Collections.shuffle(splitParticipations);
    Collections.shuffle(singleParticipations);

    when(organisationAnlassLinkService.getVereinsStarts(anlass))
        .thenReturn(List.of(splitOrganisation, singleOrganisation));
    when(anlassService.getTeilnahmen(anlass, splitOrganisation, true)).thenReturn(splitParticipations);
    when(anlassService.getTeilnahmen(anlass, singleOrganisation, true)).thenReturn(singleParticipations);

    Map<Organisation, HashMap<String, Boolean>> result =
        anmeldekontrolService.getAufgeteilteRiegen(anlass);

    assertTrue(result.get(splitOrganisation).get(TiTuEnum.Ti.name()+KategorieEnum.K1.name()));
    assertFalse(result.get(splitOrganisation).get(TiTuEnum.Ti.name()+KategorieEnum.K2.name()));
    assertTrue(result.get(singleOrganisation).get(TiTuEnum.Tu.name()+KategorieEnum.K3.name()));
  }

  private Organisation createOrganisation(String name) {
    Organisation organisation = new Organisation();
    organisation.setName(name);
    return organisation;
  }

  private TeilnehmerAnlassLink createLink(
      TiTuEnum tiTu,
      KategorieEnum kategorie,
      AbteilungEnum abteilung,
      AnlageEnum anlage,
      GeraetEnum startgeraet) {
    Teilnehmer teilnehmer = new Teilnehmer();
    teilnehmer.setTiTu(tiTu);

    TeilnehmerAnlassLink link = new TeilnehmerAnlassLink();
    link.setTeilnehmer(teilnehmer);
    link.setKategorie(kategorie);
    link.setAbteilung(abteilung);
    link.setAnlage(anlage);
    link.setStartgeraet(startgeraet);
    return link;
  }
}
