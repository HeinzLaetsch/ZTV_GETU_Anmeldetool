package org.ztv.anmeldetool.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.*;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;

@ExtendWith(MockitoExtension.class)
@Disabled
class TeilnehmerServiceTest {

    @Mock
    OrganisationService organisationSrv;

    @Mock
    AnlassService anlassSrv;

    @Mock
    TeilnehmerRepository teilnehmerRepository;

    @Mock
    TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

    @Mock
    TeilnehmerAnlassLinkMapper talMapper;

    @InjectMocks
    TeilnehmerService service;

    // helpers
    private Organisation createOrganisation(String name) {
        Organisation o = new Organisation();
        o.setId(UUID.randomUUID());
        o.setName(name);
        return o;
    }

    private Teilnehmer createTeilnehmer(String name, String vorname, Organisation org) {
        Teilnehmer t = Teilnehmer.builder().name(name).vorname(vorname).build();
        t.setId(UUID.randomUUID());
        t.setOrganisation(org);
        return t;
    }

    private Anlass createAnlass() {
        Anlass a = new Anlass();
        a.setId(UUID.randomUUID());
        return a;
    }

    private TeilnehmerAnlassLink createTal(Anlass a, Teilnehmer t, Organisation o, KategorieEnum kat) {
        TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
        tal.setId(UUID.randomUUID());
        tal.setAnlass(a);
        tal.setTeilnehmer(t);
        tal.setOrganisation(o);
        tal.setKategorie(kat);
        return tal;
    }

    private TeilnehmerDTO createTeilnehmerDTO(Organisation org) {
        return TeilnehmerDTO.builder().id(UUID.randomUUID()).organisationid(org.getId()).name("N").vorname("V").jahrgang(2000).tiTu(TiTuEnum.Ti).aktiv(true).dirty(false).build();
    }

    @Nested
    class CountAndFindByOrganisationTests {
        @Test
        void countTeilnehmerByOrganisation_returnsNotFoundWhenOrgMissing() {
            UUID orgId = UUID.randomUUID();
            when(organisationSrv.findById(orgId)).thenReturn(null);
            long res = service.countTeilnehmerByOrganisation(orgId);
        }

        @Test
        void countTeilnehmerByOrganisation_returnsCount() {
            Organisation org = createOrganisation("V1");
            when(organisationSrv.findById(org.getId())).thenReturn(org);
            when(teilnehmerRepository.countByOrganisation(org)).thenReturn(7L);
            long res = service.countTeilnehmerByOrganisation(org.getId());
            assertEquals(7, res);
        }

        @Test
        void findTeilnehmerByOrganisation_returnsNullWhenOrgMissing() {
            Organisation org = createOrganisation("V1");
            UUID orgId = UUID.randomUUID();
            when(organisationSrv.findById(orgId)).thenReturn(null);
            Pageable p = PageRequest.of(0, 10);
            Page<Teilnehmer> res = service.findTeilnehmerByOrganisation(org, p);
            assertNull(res);
        }
    }

    @Nested
    class FindByIdAndByNameTests {
        @Test
        void findTeilnehmerById_returnsNullWhenNotFound() {
            UUID id = UUID.randomUUID();
            when(teilnehmerRepository.findById(id)).thenReturn(Optional.empty());
            assertNull(service.findTeilnehmerById(id));
        }

        @Test
        void findTeilnehmerById_returnsEntityWhenFound() {
            Organisation org = createOrganisation("V");
            Teilnehmer t = createTeilnehmer("N","V",org);
            when(teilnehmerRepository.findById(t.getId())).thenReturn(Optional.of(t));
            Teilnehmer res = service.findTeilnehmerById(t.getId());
            assertNotNull(res);
            assertEquals(t.getId(), res.getId());
        }

        @Test
        void findTeilnehmerByBenutzername_delegatesToRepository() {
            List<Teilnehmer> list = List.of(new Teilnehmer());
            when(teilnehmerRepository.findByNameAndVorname("A","B")).thenReturn(list);
            List<Teilnehmer> res = service.findTeilnehmerByBenutzername("A","B");
            assertEquals(1, res.size());
        }
    }

    @Nested
    class CreateTests {
        @Test
        void create_returnsNotFoundWhenOrganisationMissing() {
            UUID orgId = UUID.randomUUID();
            when(organisationSrv.findById(orgId)).thenReturn(null);
            TeilnehmerDTO input = TeilnehmerDTO.builder().name("X").vorname("Y").organisationid(orgId).build();
            ResponseEntity<TeilnehmerDTO> res = service.create(orgId, input);
            assertEquals(404, res.getStatusCodeValue());
        }

        @Test
        void create_savesAndReturnsDtoWhenOrganisationExists() {
            Organisation org = createOrganisation("V1");
            when(organisationSrv.findById(org.getId())).thenReturn(org);
            TeilnehmerDTO raw = TeilnehmerDTO.builder().name("X").vorname("Y").organisationid(org.getId()).tiTu(TiTuEnum.Ti).build();

            // repository will return a Teilnehmer when saved
            when(teilnehmerRepository.save(any(Teilnehmer.class))).thenAnswer(inv -> {
                Teilnehmer arg = inv.getArgument(0);
                arg.setId(UUID.randomUUID());
                arg.setOrganisation(org);
                return arg;
            });

            ResponseEntity<TeilnehmerDTO> res = service.create(org.getId(), raw);
            assertEquals(200, res.getStatusCodeValue());
            TeilnehmerDTO body = res.getBody();
            assertNotNull(body);
            assertEquals(org.getId(), body.getOrganisationid());
        }

        @Test
        void create_entityCreateDelegatesToRepository() {
            Teilnehmer t = createTeilnehmer("A","B", createOrganisation("V"));
            when(teilnehmerRepository.save(t)).thenReturn(t);
            Teilnehmer res = service.create(t);
            assertEquals(t, res);
        }
    }

    @Nested
    class DeleteTests {
        @Test
        void delete_returnsNotFoundWhenOrganisationMissing() {
            UUID orgId = UUID.randomUUID();
            UUID tid = UUID.randomUUID();
            when(organisationSrv.findById(orgId)).thenReturn(null);
            ResponseEntity<UUID> res = service.delete(orgId, tid);
            assertEquals(404, res.getStatusCodeValue());
        }

        @Test
        void delete_returnsNotFoundWhenTeilnehmerMissing() {
            Organisation org = createOrganisation("V1");
            UUID tid = UUID.randomUUID();
            when(organisationSrv.findById(org.getId())).thenReturn(org);
            when(teilnehmerRepository.findById(tid)).thenReturn(Optional.empty());
            ResponseEntity<UUID> res = service.delete(org.getId(), tid);
            assertEquals(404, res.getStatusCodeValue());
        }

        @Test
        void delete_deletesLinksAndTeilnehmer() {
            Organisation org = createOrganisation("V1");
            Teilnehmer t = createTeilnehmer("N","V",org);
            when(organisationSrv.findById(org.getId())).thenReturn(org);
            when(teilnehmerRepository.findById(t.getId())).thenReturn(Optional.of(t));
            List<TeilnehmerAnlassLink> links = List.of(new TeilnehmerAnlassLink());
            when(teilnehmerAnlassLinkRepository.findByTeilnehmer(t)).thenReturn(links);

            ResponseEntity<UUID> res = service.delete(org.getId(), t.getId());
            assertEquals(200, res.getStatusCodeValue());
            verify(teilnehmerAnlassLinkRepository).deleteAll(links);
            verify(teilnehmerRepository).delete(t);
            assertEquals(t.getId(), res.getBody());
        }
    }

    @Nested
    class UpdateTests {
        @Test
        void update_throwsWhenOrganisationMissing() {
            UUID orgId = UUID.randomUUID();
            TeilnehmerDTO dto = TeilnehmerDTO.builder().id(UUID.randomUUID()).organisationid(orgId).build();
            when(organisationSrv.findById(orgId)).thenReturn(null);
            assertThrows(NotFoundException.class, () -> service.update(orgId, dto));
        }

        @Test
        void update_throwsWhenTeilnehmerMissing() {
            Organisation org = createOrganisation("V");
            TeilnehmerDTO dto = TeilnehmerDTO.builder().id(UUID.randomUUID()).organisationid(org.getId()).build();
            // don't stub organisationSrv here because this test calls update(Organisation, dto) overload
            when(teilnehmerRepository.findById(dto.getId())).thenReturn(Optional.empty());
            assertThrows(NotFoundException.class, () -> service.update(org, dto));
        }

        @Test
        void update_updatesAndReturnsDto() throws Exception {
            Organisation org = createOrganisation("V");
            Teilnehmer existing = createTeilnehmer("Old","Name",org);
            TeilnehmerDTO dto = TeilnehmerDTO.builder().id(existing.getId()).organisationid(org.getId()).name("New").vorname("N").jahrgang(1999).tiTu(TiTuEnum.Ti).aktiv(true).dirty(false).stvNummer("S").build();

            when(organisationSrv.findById(org.getId())).thenReturn(org);
            when(teilnehmerRepository.findById(existing.getId())).thenReturn(Optional.of(existing));
            when(teilnehmerRepository.save(any(Teilnehmer.class))).thenAnswer(inv -> inv.getArgument(0));

            TeilnehmerDTO res = service.update(org.getId(), dto);
            assertNotNull(res);
            assertEquals("New", res.getName());
        }

        @Test
        void update_overload_delegatesToMainUpdate() throws Exception {
            Organisation org = createOrganisation("V");
            Teilnehmer existing = createTeilnehmer("Old","Name",org);
            TeilnehmerDTO dto = TeilnehmerDTO.builder().id(existing.getId()).organisationid(org.getId()).name("New").build();
            when(organisationSrv.findById(org.getId())).thenReturn(org);
            when(teilnehmerRepository.findById(existing.getId())).thenReturn(Optional.of(existing));
            when(teilnehmerRepository.save(any(Teilnehmer.class))).thenAnswer(inv -> inv.getArgument(0));
            TeilnehmerDTO res = service.update(dto);
            assertNotNull(res);
        }
    }

    @Nested
    class UpdateAnlassTeilnahmenTests {
        @Test
        void updateAnlassTeilnahmen_returnsNullWhenTeilnehmerMissing() {
            UUID anlassId = UUID.randomUUID();
            UUID tid = UUID.randomUUID();
            when(teilnehmerRepository.findById(tid)).thenReturn(Optional.empty());
            TeilnehmerAnlassLinkDTO dto = new TeilnehmerAnlassLinkDTO(null, tid, null, null, null, false, 0, null, false, null, false, null, false);
            assertNull(service.updateAnlassTeilnahmen(anlassId, tid, dto));
        }

        @Test
        void updateAnlassTeilnahmen_createsNewLinkAndSetsFields() {
            UUID anlassId = UUID.randomUUID();
            Anlass anlass = createAnlass(); anlass.setId(anlassId);
            Organisation org = createOrganisation("V1");
            Teilnehmer t = createTeilnehmer("N","V",org);

            when(anlassSrv.findById(anlassId)).thenReturn(anlass);
            when(teilnehmerRepository.findById(t.getId())).thenReturn(Optional.of(t));
            when(teilnehmerAnlassLinkRepository.findByTeilnehmerAndAnlass(t, anlass)).thenReturn(List.of());

            TeilnehmerAnlassLinkDTO dto = new TeilnehmerAnlassLinkDTO(anlassId, t.getId(), org.getId(), KategorieEnum.K1, "STARTET", false, 0, AbteilungEnum.UNDEFINED, false, AnlageEnum.ANLAGE_1, false, GeraetEnum.BODEN, false);

            TeilnehmerAnlassLink saved = new TeilnehmerAnlassLink();
            when(teilnehmerAnlassLinkRepository.save(any(TeilnehmerAnlassLink.class))).thenAnswer(inv -> inv.getArgument(0));

            TeilnehmerAnlassLinkDTO res = service.updateAnlassTeilnahmen(anlassId, t.getId(), dto);
            assertNotNull(res);
            assertEquals(KategorieEnum.K1, res.getKategorie());
            assertEquals(MeldeStatusEnum.STARTET, res.getMeldeStatus());
        }

        @Test
        void updateAnlassTeilnahmen_throwsWhenMeldeStatusNull() {
            UUID anlassId = UUID.randomUUID();
            Anlass anlass = createAnlass(); anlass.setId(anlassId);
            Organisation org = createOrganisation("V1");
            Teilnehmer t = createTeilnehmer("N","V",org);

            when(anlassSrv.findById(anlassId)).thenReturn(anlass);
            when(teilnehmerRepository.findById(t.getId())).thenReturn(Optional.of(t));
            when(teilnehmerAnlassLinkRepository.findByTeilnehmerAndAnlass(t, anlass)).thenReturn(List.of());

            TeilnehmerAnlassLinkDTO dto = new TeilnehmerAnlassLinkDTO(anlassId, t.getId(), org.getId(), KategorieEnum.K1, null, false, 0, null, false, null, false, null, false);

            assertThrows(NullPointerException.class, () -> service.updateAnlassTeilnahmen(anlassId, t.getId(), dto));
        }

        @Test
        void updateAnlassTeilnahmen_invalidMeldeStatus_throwsIllegalArgumentException() {
            UUID anlassId = UUID.randomUUID();
            Anlass anlass = createAnlass(); anlass.setId(anlassId);
            Organisation org = createOrganisation("V1");
            Teilnehmer t = createTeilnehmer("N","V",org);

            when(anlassSrv.findById(anlassId)).thenReturn(anlass);
            when(teilnehmerRepository.findById(t.getId())).thenReturn(Optional.of(t));
            when(teilnehmerAnlassLinkRepository.findByTeilnehmerAndAnlass(t, anlass)).thenReturn(List.of());

            TeilnehmerAnlassLinkDTO dto = new TeilnehmerAnlassLinkDTO(anlassId, t.getId(), org.getId(), KategorieEnum.K1, "UNKNOWN_STATUS", false, 0, AbteilungEnum.UNDEFINED, false, AnlageEnum.ANLAGE_1, false, GeraetEnum.BODEN, false);

            assertThrows(IllegalArgumentException.class, () -> service.updateAnlassTeilnahmen(anlassId, t.getId(), dto));
        }

        @Test
        void updateAnlassTeilnahmen_existingNeumeldungNotOverwrittenByStartet() {
            UUID anlassId = UUID.randomUUID();
            Anlass anlass = createAnlass(); anlass.setId(anlassId);
            Organisation org = createOrganisation("V1");
            Teilnehmer t = createTeilnehmer("N","V",org);

            TeilnehmerAnlassLink existing = new TeilnehmerAnlassLink();
            existing.setId(UUID.randomUUID());
            existing.setAnlass(anlass);
            existing.setTeilnehmer(t);
            existing.setOrganisation(org);
            existing.setMeldeStatus(MeldeStatusEnum.NEUMELDUNG);

            when(anlassSrv.findById(anlassId)).thenReturn(anlass);
            when(teilnehmerRepository.findById(t.getId())).thenReturn(Optional.of(t));
            when(teilnehmerAnlassLinkRepository.findByTeilnehmerAndAnlass(t, anlass)).thenReturn(List.of(existing));
            when(teilnehmerAnlassLinkRepository.save(any(TeilnehmerAnlassLink.class))).thenAnswer(inv -> inv.getArgument(0));

            TeilnehmerAnlassLinkDTO dto = new TeilnehmerAnlassLinkDTO(anlassId, t.getId(), org.getId(), KategorieEnum.K1, "STARTET", false, 0, AbteilungEnum.UNDEFINED, false, AnlageEnum.ANLAGE_1, false, GeraetEnum.BODEN, false);

            TeilnehmerAnlassLinkDTO res = service.updateAnlassTeilnahmen(anlassId, t.getId(), dto);
            assertNotNull(res);
            // should remain NEUMELDUNG
            assertEquals(MeldeStatusEnum.NEUMELDUNG, res.getMeldeStatus());
        }

        @Test
        void updateAnlassTeilnahmen_keineStart_setsInactive() {
            UUID anlassId = UUID.randomUUID();
            Anlass anlass = createAnlass(); anlass.setId(anlassId);
            Organisation org = createOrganisation("V1");
            Teilnehmer t = createTeilnehmer("N","V",org);

            when(anlassSrv.findById(anlassId)).thenReturn(anlass);
            when(teilnehmerRepository.findById(t.getId())).thenReturn(Optional.of(t));
            when(teilnehmerAnlassLinkRepository.findByTeilnehmerAndAnlass(t, anlass)).thenReturn(List.of());
            when(teilnehmerAnlassLinkRepository.save(any(TeilnehmerAnlassLink.class))).thenAnswer(inv -> inv.getArgument(0));

            TeilnehmerAnlassLinkDTO dto = new TeilnehmerAnlassLinkDTO(anlassId, t.getId(), org.getId(), KategorieEnum.KEIN_START, "STARTET", false, 0, AbteilungEnum.UNDEFINED, false, AnlageEnum.ANLAGE_1, false, GeraetEnum.BODEN, false);

            TeilnehmerAnlassLinkDTO res = service.updateAnlassTeilnahmen(anlassId, t.getId(), dto);
            assertNotNull(res);
        }
    }
}
