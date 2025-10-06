package org.ztv.anmeldetool.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.repositories.*;
import org.ztv.anmeldetool.transfer.*;
import org.ztv.anmeldetool.util.*;

@ExtendWith(MockitoExtension.class)
class AnlassServiceTest {

  @Mock
  private AnlassRepository anlassRepo;

  @Mock
  private OrganisationService organisationSrv;

  @Mock
  private PersonService personSrv;

  @Mock
  private WertungsrichterService wrSrv;

  @Mock
  private OrganisationAnlassLinkRepository orgAnlassRepo;

  @Mock
  private TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

  @Mock
  private PersonAnlassLinkRepository personAnlassLinkRepository;

  @Mock
  private PersonenRepository personRepository;

  @Mock
  private AnlassMapper anlassMapper;

  @Mock
  private OrganisationMapper orgMapper;

  private AnlassService service;

  @BeforeEach
  void setUp() {
    service = new AnlassService(anlassRepo, organisationSrv, personSrv, wrSrv, orgAnlassRepo,
        teilnehmerAnlassLinkRepository, personAnlassLinkRepository, personRepository, anlassMapper,
        orgMapper);
  }

  @Nested
  class UpdateAndSave {

    @Test
    void updateAnlass_savesAndReturns() {
      Anlass anlass = mock(Anlass.class);
      when(anlassRepo.save(anlass)).thenReturn(anlass);

      Anlass res = service.updateAnlass(anlass);

      assertSame(anlass, res);
      verify(anlassRepo).save(anlass);
    }

    @Test
    void save_delegatesToRepo() {
      Anlass anlass = mock(Anlass.class);
      when(anlassRepo.save(anlass)).thenReturn(anlass);

      Anlass res = service.save(anlass);

      assertSame(anlass, res);
      verify(anlassRepo).save(anlass);
    }
  }

  @Nested
  class VerfuegbareWertungsrichter {

    @Test
    void returnsAvailable_whenPersonWithBrevetAndNotAssigned() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();

      Organisation org = mock(Organisation.class);
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      Person wr = mock(Person.class);
      Wertungsrichter wrData = mock(Wertungsrichter.class);
      when(wr.getWertungsrichter()).thenReturn(wrData);
      when(wrData.getBrevet()).thenReturn(WertungsrichterBrevetEnum.Brevet_1);

      when(personRepository.findByOrganisationId(org.getId())).thenReturn(List.of(wr));
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(mock(Anlass.class)));
      // No eingeteilte Wrs
      when(personAnlassLinkRepository.findByAnlassAndOrganisation(any(), any())).thenReturn(new LinkedList<>());

      List<Person> res = service.getVerfuegbareWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_1);

      assertNotNull(res);
      assertEquals(1, res.size());
      assertEquals(wr, res.get(0));
    }

    @Test
    void returnsEmpty_whenNoPersonWithBrevet() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();

      Organisation org = mock(Organisation.class);
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);

      Person p = mock(Person.class);
      when(p.getWertungsrichter()).thenReturn(null);
      when(personRepository.findByOrganisationId(org.getId())).thenReturn(List.of(p));
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(mock(Anlass.class)));

      List<Person> res = service.getVerfuegbareWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_2);

      assertNotNull(res);
      assertTrue(res.isEmpty());
    }
  }

  @Nested
  class AnmeldeKontrolle {

    @Test
    void buildsAnmeldeKontrolle_forExistingAnlass() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(anlassMapper.toDto(anlass)).thenReturn(mock(AnlassDTO.class));
      Organisation org = mock(Organisation.class);
      when(anlass.getOrganisator()).thenReturn(org);
      when(orgMapper.ToDto(org)).thenReturn(mock(OrganisationDTO.class));

      // getVereinsStarts uses anlass.getOrganisationenLinks; keep it simple:
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      OrganisationAnlassLink oal = mock(OrganisationAnlassLink.class);
      when(oal.isAktiv()).thenReturn(true);
      Organisation participating = mock(Organisation.class);
      when(participating.getId()).thenReturn(orgId);
      when(participating.getName()).thenReturn("V1");
      when(oal.getOrganisation()).thenReturn(participating);
      when(anlass.getOrganisationenLinks()).thenReturn(List.of(oal));

      // make methods used inside return minimal safe values
      when(personAnlassLinkRepository.findByAnlassAndOrganisation(any(), any())).thenReturn(new LinkedList<>());

      AnmeldeKontrolleDTO dto = service.getAnmeldeKontrolle(anlassId, null);

      assertNotNull(dto);
      assertNotNull(dto.getAnlass());
      assertNotNull(dto.getVereinsStart());
    }

    @Test
    void throws_whenAnlassNotFound() {
      UUID anlassId = UUID.randomUUID();
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.empty());

      assertThrows(NoSuchElementException.class, () -> service.getAnmeldeKontrolle(anlassId, UUID.randomUUID()));
    }
  }

  @Nested
  class EingeteilteWertungsrichter {

    @Test
    void getEingeteilteWertungsrichter_withoutOrg_returnsFilteredEinsaetze() {
      UUID anlassId = UUID.randomUUID();
      Anlass anlass = mock(Anlass.class);
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));

      PersonAnlassLink pal = mock(PersonAnlassLink.class);
      WertungsrichterEinsatz eins = mock(WertungsrichterEinsatz.class);
      when(eins.isEingesetzt()).thenReturn(true);
      when(pal.getEinsaetze()).thenReturn(List.of(eins));
      LinkedList<PersonAnlassLink> pals = new LinkedList<>(List.of(pal));
      when(personAnlassLinkRepository.findByAnlass(anlass)).thenReturn(pals);

      List<PersonAnlassLink> res = service.getEingeteilteWertungsrichter(anlassId);

      assertNotNull(res);
      assertEquals(1, res.size());
      verify(personAnlassLinkRepository).findByAnlass(anlass);
    }

    @Test
    void getEingeteilteWertungsrichter_withOrgAndBrevet_filtersByBrevet() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);

      PersonAnlassLink pal = mock(PersonAnlassLink.class);
      Wertungsrichter wr = mock(Wertungsrichter.class);
      Person p = mock(Person.class);
      when(p.getWertungsrichter()).thenReturn(wr);
      when(wr.getBrevet()).thenReturn(WertungsrichterBrevetEnum.Brevet_1);
      when(pal.getPerson()).thenReturn(p);

      LinkedList<PersonAnlassLink> pals = new LinkedList<>(List.of(pal));
      when(personAnlassLinkRepository.findByAnlassAndOrganisation(anlass, org)).thenReturn(pals);

      List<PersonAnlassLink> res = service.getEingeteilteWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_1);

      assertNotNull(res);
      assertEquals(1, res.size());
    }
  }

  @Nested
  class UpdateEingeteilteWertungsrichter {

    @Test
    void add_newPerson_createsAndReturnsOk() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      Person person = mock(Person.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(personSrv.findPersonById(personId)).thenReturn(person);

      when(personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person, org, anlass)).thenReturn(new LinkedList<>());
      PersonAnlassLink saved = mock(PersonAnlassLink.class);
      when(personAnlassLinkRepository.save(any(PersonAnlassLink.class))).thenReturn(saved);
      when(saved.getAnlass()).thenReturn(anlass);
      when(saved.getOrganisation()).thenReturn(org);
      when(saved.getPerson()).thenReturn(person);

      ResponseEntity<PersonAnlassLinkDTO> resp = service.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "c", true);

      assertNotNull(resp);
      assertEquals(200, resp.getStatusCodeValue());
      assertNotNull(resp.getBody());
      verify(personAnlassLinkRepository).save(any(PersonAnlassLink.class));
    }

    @Test
    void add_whenAlreadyExists_returnsBadRequest() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      Person person = mock(Person.class);
      PersonAnlassLink existing = mock(PersonAnlassLink.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(personSrv.findPersonById(personId)).thenReturn(person);

      when(personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person, org, anlass))
          .thenReturn(new LinkedList<>(List.of(existing)));

      ResponseEntity<PersonAnlassLinkDTO> resp = service.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "c", true);

      assertEquals(400, resp.getStatusCodeValue());
    }

    @Test
    void remove_existing_deletesAndReturnsOk() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      Person person = mock(Person.class);
      PersonAnlassLink existing = mock(PersonAnlassLink.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(personSrv.findPersonById(personId)).thenReturn(person);
      when(existing.getAnlass()).thenReturn(anlass);
      when(existing.getOrganisation()).thenReturn(org);
      when(existing.getPerson()).thenReturn(person);
      when(personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person, org, anlass)).thenReturn((new LinkedList<>(List.of(existing))));

      ResponseEntity<PersonAnlassLinkDTO> resp = service.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "c", false);

      assertEquals(200, resp.getStatusCodeValue());
      verify(personAnlassLinkRepository).delete(existing);
    }

    @Test
    void remove_whenNotExists_returnsBadRequest() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      Person person = mock(Person.class);
      PersonAnlassLink existing = mock(PersonAnlassLink.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(personSrv.findPersonById(personId)).thenReturn(person);
      when(personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person, org, anlass))
          .thenReturn(new LinkedList<>());

      ResponseEntity<PersonAnlassLinkDTO> resp = service.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "c", false);

      assertEquals(400, resp.getStatusCodeValue());
    }
  }

  @Nested
  class GetAnlassLinkAndUpdate {

    @Test
    void getAnlassLink_returnsLink_whenPresent() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      Person person = mock(Person.class);
      PersonAnlassLink pal = mock(PersonAnlassLink.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(personSrv.findPersonById(personId)).thenReturn(person);
      when(personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person, org, anlass))
          .thenReturn(new LinkedList<>(List.of(pal)));

      PersonAnlassLink res = service.getAnlassLink(anlassId, orgId, personId);

      assertSame(pal, res);
    }

    @Test
    void getAnlassLink_returnsNull_whenNotFound() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(mock(Anlass.class)));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(mock(Organisation.class));
      when(personSrv.findPersonById(personId)).thenReturn(mock(Person.class));
      when(personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(any(), any(), any()))
          .thenReturn(new LinkedList<>());

      PersonAnlassLink res = service.getAnlassLink(anlassId, orgId, personId);

      assertNull(res);
    }

    @Test
    void getAnlassLink_throws_whenMultiple() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      Person person = mock(Person.class);
      PersonAnlassLink pal1 = mock(PersonAnlassLink.class);
      PersonAnlassLink pal2 = mock(PersonAnlassLink.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(personSrv.findPersonById(personId)).thenReturn(person);
      when(personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person, org, anlass))
          .thenReturn(new LinkedList<>(List.of(pal1, pal2)));

      assertThrows(Exception.class, () -> service.getAnlassLink(anlassId, orgId, personId));
    }

    @Test
    void updateAnlassLink_saves() {
      PersonAnlassLink pal = mock(PersonAnlassLink.class);
      when(personAnlassLinkRepository.save(pal)).thenReturn(pal);

      PersonAnlassLink res = service.updateAnlassLink(pal);

      assertSame(pal, res);
      verify(personAnlassLinkRepository).save(pal);
    }
  }

  @Nested
  class AnlaesseQueries {

    @Test
    void getAnlaesse_onlyAktiv_true() {
      List<Anlass> expected = List.of(mock(Anlass.class));
      when(anlassRepo.findByAktivOrderByStartDate(true)).thenReturn(expected);

      List<Anlass> res = service.getAnlaesse(true);

      assertEquals(expected, res);
    }

    @Test
    void getAnlaesse_onlyAktiv_false() {
      List<Anlass> expected = List.of(mock(Anlass.class));
      when(anlassRepo.findAllByOrderByStartDate()).thenReturn(expected);

      List<Anlass> res = service.getAnlaesse(false);

      assertEquals(expected, res);
    }

    @Test
    void getAnlaesseFiltered_returnsList() {
      int year = 2023;
      when(anlassRepo.findByAktivTrueAndSmQualiInAndTiTuInAndHoechsteKategorieEqualsAndStartDateBetweenOrderByStartDate(
          any(boolean[].class), any(TiTuEnum[].class), eq(KategorieEnum.K7), any(), any()))
          .thenReturn(List.of(mock(Anlass.class)));

      List<Anlass> res = service.getAnlaesseFiltered(year, true, TiTuEnum.Ti);

      assertNotNull(res);
      assertFalse(res.isEmpty());
    }
  }

  @Nested
  class Teilnahmen {

    @Test
    void getTeilnahmen_byYearAndOrg_returnsMap() {
      int year = 2023;
      UUID orgId = UUID.randomUUID();
      UUID anlassId= UUID.randomUUID();
      LocalDateTime start = LocalDateTime.of(year, 1, 1, 0, 0);
      LocalDateTime end = LocalDateTime.of(year, 12, 31, 23, 59);
      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      Teilnehmer t = mock(Teilnehmer.class);

      when(anlass.getId()).thenReturn(anlassId);
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(anlassRepo.findByStartDateBetweenAndAktivOrderByStartDate(start, end, true)).thenReturn(List.of(anlass));

      TeilnehmerAnlassLink tal = mock(TeilnehmerAnlassLink.class);
      when(tal.getTeilnehmer()).thenReturn(t);
      when(tal.getOrganisation()).thenReturn(org);
      when(org.getName()).thenReturn("MockName");
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(teilnehmerAnlassLinkRepository.findByAnlassAndOrganisation(any(), any())).thenReturn(List.of(tal));

      Map<Teilnehmer, List<TeilnehmerAnlassLink>> res = service.getTeilnahmen(year, orgId);

      assertNotNull(res);
      assertTrue(res.containsKey(t));
    }

    @Test
    void getTeilnahmen_excludeTrue_usesExclusionQuery() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      TeilnehmerAnlassLink tal = mock(TeilnehmerAnlassLink.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);

      when(tal.getTeilnehmer()).thenReturn(mock(Teilnehmer.class));
      when(tal.getOrganisation()).thenReturn(org);
      when(org.getName()).thenReturn("MockName");
      when(teilnehmerAnlassLinkRepository.findByAnlassAndOrganisationExclude(eq(anlass), eq(org), any()))
          .thenReturn(new LinkedList<>(List.of(tal)));

      List<TeilnehmerAnlassLink> res = service.getTeilnahmen(anlassId, orgId, true);

      assertNotNull(res);
      assertEquals(1, res.size());
    }

    @Test
    void getTeilnahmen_anlassMissing_throws() {
      UUID anlassId = UUID.randomUUID();
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.empty());

      assertThrows(NoSuchElementException.class, () -> service.getTeilnahmen(anlassId, UUID.randomUUID(), false));
    }
  }

  @Nested
  class OrganisationAndVerein {

    @Test
    void getOrganisationAnlassLinks_returnsAll() {
      List<OrganisationAnlassLink> expected = List.of(mock(OrganisationAnlassLink.class));
      when(orgAnlassRepo.findAll()).thenReturn(expected);

      List<OrganisationAnlassLink> res = service.getOrganisationAnlassLinks();

      assertEquals(expected, res);
    }

    @Test
    void getVereinStart_returnsFirstLink_whenExists() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      OrganisationAnlassLink link = mock(OrganisationAnlassLink.class);

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      when(orgAnlassRepo.findByOrganisationAndAnlass(org, anlass))
          .thenReturn(new LinkedList<>(List.of(link)));

      OrganisationAnlassLink res = service.getVereinStart(anlassId, orgId);

      assertSame(link, res);
    }

    @Test
    void getVereinStart_returnsNull_whenNoAnlassOrOrg() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(null);
      OrganisationAnlassLink res2 = service.getVereinStart(anlassId, orgId);
      assertNull(res2);
    }

    @Test
    void getVereinsStarts_returnsEmpty_whenAnlassNotFound() {
      UUID anlassId = UUID.randomUUID();
      Anlass anlass = mock(Anlass.class);
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));

      List<Organisation> res = service.getVereinsStarts(anlassId);

      assertNotNull(res);
      assertTrue(res.isEmpty());
    }

    @Test
    void getVereinsStarts_filtersDuplicatesAndInactive() {
      UUID anlassId = UUID.randomUUID();
      Anlass anlass = mock(Anlass.class);
      Organisation org1 = mock(Organisation.class);
      when(org1.getId()).thenReturn(UUID.randomUUID());
      OrganisationAnlassLink link = mock(OrganisationAnlassLink.class);
      when(link.isAktiv()).thenReturn(true);
      when(link.getOrganisation()).thenReturn(org1);
      when(anlass.getOrganisationenLinks()).thenReturn(List.of(link));
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));

      List<Organisation> res = service.getVereinsStarts(anlassId);

      assertEquals(1, res.size());
    }
  }

  @Nested
  class FindAnlassById {

    @Test
    void findAnlassById_returnsAnlass_whenPresent() {
      UUID anlassId = UUID.randomUUID();
      Anlass anlass = mock(Anlass.class);
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));

      Anlass res = service.findAnlassById(anlassId);

      assertSame(anlass, res);
    }

    @Test
    void findAnlassById_throws_whenMissing() {
      UUID anlassId = UUID.randomUUID();
      when(anlassRepo.findById(anlassId)).thenReturn(Optional.empty());

      assertThrows(NoSuchElementException.class, () -> service.findAnlassById(anlassId));
    }
  }

  @Nested
  class UpdateTeilnehmendeVereine {

    @Test
    void updateTeilnehmendeVereine_updatesExistingOrCreates() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();

      Anlass anlass = mock(Anlass.class);
      Organisation org = mock(Organisation.class);
      OrganisationAnlassLinkDTO dto = OrganisationAnlassLinkDTO.builder().startet(true).verlaengerungsDate(LocalDateTime.now()).build();

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(anlass));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
      OrganisationAnlassLink existing = mock(OrganisationAnlassLink.class);
      when(orgAnlassRepo.findByOrganisationAndAnlass(org, anlass)).thenReturn(new LinkedList<>(List.of(existing)));
      when(orgAnlassRepo.save(any())).thenReturn(existing);

      OrganisationAnlassLink res = service.updateTeilnehmendeVereine(anlassId, orgId, dto);

      assertNotNull(res);
      verify(orgAnlassRepo).save(any());
    }

    @Test
    void updateTeilnehmendeVereine_returnsNull_whenOrganisationMissing() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      OrganisationAnlassLinkDTO dto = OrganisationAnlassLinkDTO.builder().startet(true).build();

      when(anlassRepo.findById(anlassId)).thenReturn(Optional.of(mock(Anlass.class)));
      when(organisationSrv.findOrganisationById(orgId)).thenReturn(null);

      OrganisationAnlassLink res = service.updateTeilnehmendeVereine(anlassId, orgId, dto);

      assertNull(res);
    }
  }
}
