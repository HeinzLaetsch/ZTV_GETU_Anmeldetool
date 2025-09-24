package org.ztv.anmeldetool.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.anyBoolean;
import static org.mockito.Mockito.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
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
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerStartDTO;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class TeilnehmerAnlassLinkServiceTest {

  @Mock
  OrganisationService organisationSrv;

  @Mock
  AnlassService anlassSrv;

  @Mock
  TeilnehmerRepository teilnehmerRepository;

  @Mock
  TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

  @Mock
  OrganisationAnlassLinkRepository organisationAnlassLinkRepository;

  @InjectMocks
  TeilnehmerAnlassLinkService service;

  // helpers
  private Teilnehmer createTeilnehmer(String name, String vorname, TiTuEnum titu) {
    Teilnehmer t = new Teilnehmer();
    t.setName(name);
    t.setVorname(vorname);
    t.setTiTu(titu);
    t.setId(UUID.randomUUID());
    return t;
  }

  private Organisation createOrganisation(String name) {
    Organisation o = new Organisation();
    o.setName(name);
    o.setId(UUID.randomUUID());
    return o;
  }

  private Anlass createAnlass() {
    Anlass a = new Anlass();
    a.setId(UUID.randomUUID());
    return a;
  }

  private TeilnehmerAnlassLink createTal(Anlass a, Teilnehmer t, Organisation o) {
    TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
    tal.setAnlass(a);
    tal.setTeilnehmer(t);
    tal.setOrganisation(o);
    tal.setId(UUID.randomUUID());
    tal.setAktiv(true);
    return tal;
  }

  // helper to create OrganisationAnlassLink instances (avoid double-brace initializers)
  private OrganisationAnlassLink createOAL(Organisation org) {
    OrganisationAnlassLink oal = new OrganisationAnlassLink();
    oal.setOrganisation(org);
    return oal;
  }

  @Nested
  class FindAndSaveTests {

    @Test
    void findById_delegatesToRepository() {
      UUID id = UUID.randomUUID();
      TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
      tal.setId(id);
      when(teilnehmerAnlassLinkRepository.findById(id)).thenReturn(Optional.of(tal));

      Optional<TeilnehmerAnlassLink> res = service.findTeilnehmerAnlassLinkById(id);
      assertTrue(res.isPresent());
      assertEquals(id, res.get().getId());
    }

    @Test
    void findByAnlassAndTeilnehmer_delegatesToRepository() {
      Anlass a = createAnlass();
      Teilnehmer t = createTeilnehmer("Mueller", "Max", TiTuEnum.Ti);
      TeilnehmerAnlassLink tal = createTal(a, t, createOrganisation("V1"));
      when(teilnehmerAnlassLinkRepository.findByAnlassAndTeilnehmer(a, t)).thenReturn(
          Optional.of(tal));

      Optional<TeilnehmerAnlassLink> res = service.findTeilnehmerAnlassLinkByAnlassAndTeilnehmer(a,
          t);
      assertTrue(res.isPresent());
      assertEquals(tal, res.get());
    }

    @Test
    void findByTeilnehmer_delegatesToRepository() {
      Teilnehmer t = createTeilnehmer("X", "Y", TiTuEnum.Ti);
      List<TeilnehmerAnlassLink> list = List.of(new TeilnehmerAnlassLink());
      when(teilnehmerAnlassLinkRepository.findByTeilnehmer(t)).thenReturn(list);

      List<TeilnehmerAnlassLink> res = service.findTeilnehmerAnlassLinkByTeilnehmer(t);
      assertEquals(1, res.size());
    }

    @Test
    void save_delegatesToRepository_and_returnsSaved() {
      TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
      when(teilnehmerAnlassLinkRepository.saveAndFlush(tal)).thenReturn(tal);

      TeilnehmerAnlassLink res = service.save(tal);
      assertNotNull(res);
      verify(teilnehmerAnlassLinkRepository).saveAndFlush(tal);
    }
  }

  @Nested
  class FindAnlassTeilnahmenTests {

    @Test
    void findAnlassTeilnahmen_throwsWhenAnlassNotFound() {
      UUID id = UUID.randomUUID();
      when(anlassSrv.findAnlassById(id)).thenReturn(null);
      ServiceException ex = assertThrows(ServiceException.class,
          () -> service.findAnlassTeilnahmen(id));
      assertTrue(ex.getMessage().contains("Could not find Anlass"));
    }

    @Test
    void findAnlassTeilnahmen_returnsResults() throws Exception {
      UUID id = UUID.randomUUID();
      Anlass a = new Anlass();
      a.setId(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(a);
      Organisation org = createOrganisation("V1");
      OrganisationAnlassLink oal = new OrganisationAnlassLink();
      oal.setOrganisation(org);
      when(organisationAnlassLinkRepository.findByAnlassAndAktiv(a, true)).thenReturn(List.of(oal));

      TeilnehmerAnlassLink tal = createTal(a, createTeilnehmer("A", "B", TiTuEnum.Ti), org);
      when(teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(a, true,
          Arrays.asList(MeldeStatusEnum.ABGEMELDET_1, MeldeStatusEnum.ABGEMELDET_2,
              MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG), List.of(org)))
          .thenReturn(List.of(tal));

      List<TeilnehmerAnlassLink> res = service.findAnlassTeilnahmen(id);
      assertEquals(1, res.size());
      assertEquals(tal, res.get(0));
    }
  }

  @Nested
  class MaxStartnummerTests {

    @Test
    void findMaxStartNummer_returnsOneWhenNoMax() {
      when(
          teilnehmerAnlassLinkRepository.findTopByStartnummerNotNullOrderByStartnummerDesc()).thenReturn(
          Optional.empty());
      int res = service.findMaxStartNummer();
      assertEquals(1, res);
    }

    @Test
    void findMaxStartNummer_returnsNextWhenFound() {
      TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
      tal.setStartnummer(42);
      when(
          teilnehmerAnlassLinkRepository.findTopByStartnummerNotNullOrderByStartnummerDesc()).thenReturn(
          Optional.of(tal));
      int res = service.findMaxStartNummer();
      assertEquals(43, res);
    }
  }

  @Nested
  class StartgeraetAndStatisticTests {

    @Test
    void getTeilnehmerForStartgeraet_filtersByMeldeStatus_and_search() throws Exception {
      UUID id = UUID.randomUUID();
      Anlass a = createAnlass();
      a.setId(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(a);

      Teilnehmer t1 = createTeilnehmer("Smith", "John", TiTuEnum.Ti);
      Organisation o = createOrganisation("Vere1");
      TeilnehmerAnlassLink tal1 = createTal(a, t1, o);
      tal1.setMeldeStatus(MeldeStatusEnum.STARTET);

      Teilnehmer t2 = createTeilnehmer("Andere", "Foo", TiTuEnum.Tu);
      Organisation o2 = createOrganisation("Vere2");
      TeilnehmerAnlassLink tal2 = createTal(a, t2, o2);
      tal2.setMeldeStatus(MeldeStatusEnum.ABGEMELDET_1);

      when(organisationAnlassLinkRepository.findByAnlassAndAktiv(a, true)).thenReturn(
          List.of(createOAL(o), createOAL(o2)));

      when(teilnehmerAnlassLinkRepository.findByAnlass(a, null, null, null, null)).thenReturn(
          List.of(tal1, tal2));

      List<TeilnehmerStartDTO> res = service.getTeilnehmerForStartgeraet(id, null,
          AbteilungEnum.UNDEFINED, null, null, Optional.empty());
      // tal2 is excluded due to ABGEMELDET_1 (not in allowed set)
      assertEquals(1, res.size());
      assertEquals("Smith", res.get(0).getName());

      // search filter
      List<TeilnehmerStartDTO> res2 = service.getTeilnehmerForStartgeraet(id, null,
          AbteilungEnum.UNDEFINED, null, null, Optional.of("smith"));
      assertEquals(1, res2.size());
    }

    @Test
    void getStatisticForAnlass_countsStatuses() throws Exception {
      UUID id = UUID.randomUUID();
      Anlass a = createAnlass();
      a.setId(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(a);

      Teilnehmer t1 = createTeilnehmer("A", "B", TiTuEnum.Ti);
      TeilnehmerAnlassLink tal1 = createTal(a, t1, createOrganisation("V1"));
      tal1.setMeldeStatus(null); // startet

      Teilnehmer t2 = createTeilnehmer("C", "D", TiTuEnum.Tu);
      TeilnehmerAnlassLink tal2 = createTal(a, t2, createOrganisation("V2"));
      tal2.setMeldeStatus(MeldeStatusEnum.NEUMELDUNG);

      OrganisationAnlassLink oal1 = new OrganisationAnlassLink() {
        {
          setOrganisation(tal1.getOrganisation());
        }
      };
      OrganisationAnlassLink oal2 = new OrganisationAnlassLink() {
        {
          setOrganisation(tal2.getOrganisation());
        }
      };

      when(organisationAnlassLinkRepository.findByAnlassAndAktiv(a, true)).thenReturn(
          List.of(oal1, oal2));
      when(teilnehmerAnlassLinkRepository.findByAnlass(a, null, null, null, null)).thenReturn(
          List.of(tal1, tal2));

      var stats = service.getStatisticForAnlass(id, null, AbteilungEnum.UNDEFINED, null, null,
          Optional.empty());
      assertEquals(2, stats.getTotal());
      assertEquals(1, stats.getStartet());
      assertEquals(1, stats.getNeumeldung());
    }
  }

  @Nested
  class MutationAndUpdateTests {

    @Test
    void getMutationenForAnlass_filtersNonNullMeldeStatus() throws Exception {
      UUID id = UUID.randomUUID();
      Anlass a = createAnlass();
      a.setId(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(a);

      TeilnehmerAnlassLink tal1 = createTal(a, createTeilnehmer("A", "B", TiTuEnum.Ti),
          createOrganisation("V1"));
      tal1.setMeldeStatus(MeldeStatusEnum.STARTET);
      TeilnehmerAnlassLink tal2 = createTal(a, createTeilnehmer("C", "D", TiTuEnum.Tu),
          createOrganisation("V2"));
      tal2.setMeldeStatus(MeldeStatusEnum.ABGEMELDET_1);

      when(organisationAnlassLinkRepository.findByAnlassAndAktiv(a, true)).thenReturn(
          List.of(createOAL(tal1.getOrganisation()), createOAL(tal2.getOrganisation())));
      when(teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(a, true,
          Arrays.asList(MeldeStatusEnum.STARTET),
          List.of(tal1.getOrganisation(), tal2.getOrganisation())))
          .thenReturn(List.of(tal1, tal2));

      List<TeilnehmerAnlassLink> res = service.getMutationenForAnlass(id);
      // both have non-null status, so returned
      assertEquals(2, res.size());
    }

    @Test
    void getAllTeilnehmerForAnlassAndUpdateStartnummern_updatesMissingStartnummers()
        throws Exception {
      UUID id = UUID.randomUUID();
      Anlass a = createAnlass();
      a.setId(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(a);

      Organisation org = createOrganisation("V1");
      when(organisationAnlassLinkRepository.findByAnlassAndAktiv(a, true)).thenReturn(
          List.of(createOAL(org)));

      TeilnehmerAnlassLink tal1 = createTal(a, createTeilnehmer("A", "B", TiTuEnum.Ti), org);
      tal1.setStartnummer(null);
      TeilnehmerAnlassLink tal2 = createTal(a, createTeilnehmer("C", "D", TiTuEnum.Tu), org);
      tal2.setStartnummer(10);

      when(teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(a, true,
          Arrays.asList(MeldeStatusEnum.ABGEMELDET_1, MeldeStatusEnum.ABGEMELDET_2,
              MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG), List.of(org)))
          .thenReturn(List.of(tal1, tal2));

      // Simulate existing max = 5 -> next startnummer = 6
      TeilnehmerAnlassLink maxTal = new TeilnehmerAnlassLink();
      maxTal.setStartnummer(5);
      when(
          teilnehmerAnlassLinkRepository.findTopByStartnummerNotNullOrderByStartnummerDesc()).thenReturn(
          Optional.of(maxTal));
      when(teilnehmerAnlassLinkRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

      List<TeilnehmerAnlassLink> res = service.getAllTeilnehmerForAnlassAndUpdateStartnummern(id);
      // tal1 should now have startnummer assigned
      assertNotNull(res.stream().filter(t -> t.getId().equals(tal1.getId())).findFirst().get()
          .getStartnummer());
    }

    @Test
    void updateAnlassTeilnahmen_updatesMatchingEntries_and_returnsCount() throws Exception {
      UUID id = UUID.randomUUID();
      Anlass a = createAnlass();
      a.setId(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(a);

      Organisation org = createOrganisation("V1");
      when(organisationAnlassLinkRepository.findByAnlassAndAktiv(a, true)).thenReturn(
          List.of(createOAL(org)));

      TeilnehmerAnlassLink tal = createTal(a, createTeilnehmer("A", "B", TiTuEnum.Ti), org);
      tal.setStartnummer(1);

      when(teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(a, true,
          Arrays.asList(MeldeStatusEnum.ABGEMELDET_1, MeldeStatusEnum.ABGEMELDET_2,
              MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG), List.of(org)))
          .thenReturn(List.of(tal));

      TeilnehmerAnlassLinkCsvDTO dto = new TeilnehmerAnlassLinkCsvDTO(id,
          tal.getTeilnehmer().getId(), org.getId(), 1, "A", "B", 2000, "V1", KategorieEnum.K1,
          AbteilungEnum.ABTEILUNG_2, AnlageEnum.ANLAGE_1,
          GeraetEnum.SPRUNG,
          TiTuEnum.Ti, null);
      when(teilnehmerAnlassLinkRepository.saveAll(any())).thenReturn(List.of(tal));

      int count = service.updateAnlassTeilnahmen(id, List.of(dto));
      assertEquals(1, count);
    }

    @Test
    void updateAnlassTeilnahmen_throwsWhenSaveCountMismatch() throws Exception {
      UUID id = UUID.randomUUID();
      Anlass a = createAnlass();
      a.setId(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(a);

      Organisation org = createOrganisation("V1");
      when(organisationAnlassLinkRepository.findByAnlassAndAktiv(a, true)).thenReturn(
          List.of(createOAL(org)));

      TeilnehmerAnlassLink tal = createTal(a, createTeilnehmer("A", "B", TiTuEnum.Ti), org);
      tal.setStartnummer(1);

      when(teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(a, true,
          Arrays.asList(MeldeStatusEnum.ABGEMELDET_1, MeldeStatusEnum.ABGEMELDET_2,
              MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG), List.of(org)))
          .thenReturn(List.of(tal));

      TeilnehmerAnlassLinkCsvDTO dto = new TeilnehmerAnlassLinkCsvDTO(id,
          tal.getTeilnehmer().getId(), org.getId(), 1, "A", "B", 2000, "V1", KategorieEnum.K1,
          AbteilungEnum.ABTEILUNG_2, AnlageEnum.ANLAGE_1,
          GeraetEnum.SPRUNG,
          TiTuEnum.Ti, null);
      // simulate saveAll returning empty list -> mismatch
      when(teilnehmerAnlassLinkRepository.saveAll(any())).thenReturn(List.of());

      assertThrows(ServiceException.class, () -> service.updateAnlassTeilnahmen(id, List.of(dto)));
    }

    @Test
    void updateAnlassTeilnahme_updatesAndDeletesWhenAbgemeldet() throws Exception {
      UUID id = UUID.randomUUID();
      TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
      tal.setId(id);
      tal.setAktiv(true);
      when(teilnehmerAnlassLinkRepository.findById(id)).thenReturn(Optional.of(tal));

      TeilnehmerStartDTO dto = TeilnehmerStartDTO.builder().id(id).name("X").vorname("Y")
          .verein("V").tiTu(TiTuEnum.Ti).abteilung(null).anlage(null).startgeraet(null)
          .kategorie(null).meldeStatus(MeldeStatusEnum.ABGEMELDET).build();

      service.updateAnlassTeilnahme(dto);
      // after processing, tal should be marked deleted and inactive
      verify(teilnehmerAnlassLinkRepository).save(tal);
      assertTrue(tal.isDeleted());
      assertFalse(tal.isAktiv());
    }

    @Test
    void updateAnlassTeilnahme_throwsWhenNotFound() {
      UUID id = UUID.randomUUID();
      when(teilnehmerAnlassLinkRepository.findById(id)).thenReturn(Optional.empty());
      TeilnehmerStartDTO dto = TeilnehmerStartDTO.builder().id(id).build();
      assertThrows(ServiceException.class, () -> service.updateAnlassTeilnahme(dto));
    }
  }

  @Nested
  class SimpleDelegationTests {

    @Test
    void findWettkampfMethods_delegateToRepository() throws Exception {
      Anlass a = createAnlass();
      when(
          teilnehmerAnlassLinkRepository.findByAnlassAndAktivAndKategorieAndTiTuOrderByOrganisation(
              any(), anyBoolean(), any(), any(), any())).thenReturn(List.of());
      when(teilnehmerAnlassLinkRepository.findByAnlassAndKategorieAndTiTu(any(), any(), any(),
          any())).thenReturn(List.of());

      List<TeilnehmerAnlassLink> r1 = service.findWettkampfTeilnahmenByKategorieAndTiTuOrderByOrganisation(
          a, KategorieEnum.K1, TiTuEnum.Ti);
      List<TeilnehmerAnlassLink> r2 = service.findWettkampfTeilnahmenByKategorieAndTiTu(a,
          KategorieEnum.K1, TiTuEnum.Ti);
      assertNotNull(r1);
      assertNotNull(r2);
    }

    @Test
    void findAbteilungenAndAnlagen_delegateToRepository() throws Exception {
      Anlass a = createAnlass();
      when(teilnehmerAnlassLinkRepository.findDistinctByAnlassAndAktivAndKategorie(any(),
          anyBoolean(), anyString())).thenReturn(List.of(AbteilungEnum.ABTEILUNG_1));
      when(
          teilnehmerAnlassLinkRepository.findDistinctByAnlassAndAktivAndKategorieAndAbteilung(any(),
              anyBoolean(), anyString(), anyString())).thenReturn(List.of(AnlageEnum.ANLAGE_1));

      List<AbteilungEnum> ab = service.findAbteilungenByKategorie(a, KategorieEnum.K1);
      List<AnlageEnum> an = service.findAnlagenByKategorieAndAbteilung(a, KategorieEnum.K1,
          AbteilungEnum.ABTEILUNG_1);
      assertEquals(1, ab.size());
      assertEquals(1, an.size());
    }
  }
}
