package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.transfer.*;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class TeilnahmenServiceTest {

    @Mock
    AnlassService anlassSrv;

    @Mock
    TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;

    @Mock
    TeilnehmerService teilnehmerSrv;

    @Mock
    TeilnehmerAnlassLinkMapper teilnehmerAnlassLinkMapper;

    @InjectMocks
    TeilnahmenService teilnahmenService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Nested
    class GetAnlassorganisationStatiTests {
        @Test
        void whenNoTeilnahmen_thenReturnNull() {
            when(anlassSrv.getTeilnahmen(anyInt(), any())).thenReturn(Collections.emptyMap());
            Collection<OrganisationTeilnahmenStatistikDTO> res = teilnahmenService.getAnlassorganisationStati(2025, UUID.randomUUID());
            assertNull(res);
        }

        @Test
        void whenThereAreTeilnahmen_thenGroupByAnlass() {
            UUID orgId = UUID.randomUUID();
            UUID anlassId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            Teilnehmer t = new Teilnehmer(); t.setId(UUID.randomUUID()); t.setOrganisation(org);
            Anlass anlassObj = new Anlass(); anlassObj.setId(anlassId);
            TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink(); tal.setAnlass(anlassObj); tal.getAnlass().setId(anlassId);
            // mapper DTO
            TeilnehmerAnlassLinkDTO talDto = new TeilnehmerAnlassLinkDTO(anlassId, t.getId(), orgId, KategorieEnum.K1, "Startet", false, 0, null, false, null, false, null, false);
            when(teilnehmerSrv.findTeilnehmerByOrganisation(any(), any())).thenReturn(Collections.emptyList());
            Map<Teilnehmer, List<TeilnehmerAnlassLink>> map = new HashMap<>();
            map.put(t, List.of(tal));
            when(anlassSrv.getTeilnahmen(anyInt(), any())).thenReturn(map);
            when(teilnehmerAnlassLinkMapper.toDto(tal)).thenReturn(talDto);
            when(anlassSrv.findAnlassById(anlassId)).thenReturn(anlassObj);

            Collection<OrganisationTeilnahmenStatistikDTO> res = teilnahmenService.getAnlassorganisationStati(2025, orgId);
            assertNotNull(res);
            assertEquals(1, res.size());
            OrganisationTeilnahmenStatistikDTO ots = res.iterator().next();
            assertEquals(anlassId, ots.getAnlassId());
            assertFalse(ots.getKategorieStati().isEmpty());
        }
    }

    @Nested
    class GetTeilnahmenTests {
        @Test
        void whenNoParticipantsAndNoTals_thenReturnEmptyList() {
            UUID orgId = UUID.randomUUID();
            when(anlassSrv.getTeilnahmen(anyInt(), eq(orgId))).thenReturn(Collections.emptyMap());
            when(teilnehmerSrv.findTeilnehmerByOrganisation(eq(orgId), any())).thenReturn(Collections.emptyList());
            List<TeilnahmenDTO> res = teilnahmenService.getTeilnahmen(2025, orgId, false);
            assertTrue(res.isEmpty());
        }

        @Test
        void whenParticipantWithOneTal_thenReturnTeilnahmenDTO() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            Teilnehmer t = new Teilnehmer(); t.setId(UUID.randomUUID()); t.setOrganisation(org);
            Anlass anlass = new Anlass(); anlass.setId(UUID.randomUUID());
            TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink(); tal.setAnlass(anlass); tal.setKategorie(KategorieEnum.K1);
            // prepare map
            Map<Teilnehmer, List<TeilnehmerAnlassLink>> map = new HashMap<>();
            map.put(t, List.of(tal));
            when(anlassSrv.getTeilnahmen(anyInt(), eq(orgId))).thenReturn(map);
            when(teilnehmerSrv.findTeilnehmerByOrganisation(eq(orgId), any())).thenReturn(Collections.emptyList());
            // mapper
            TeilnehmerAnlassLinkDTO talDto = new TeilnehmerAnlassLinkDTO(anlass.getId(), t.getId(), orgId, KategorieEnum.K1, "Startet", false, 0, null, false, null, false, null, false);
            when(teilnehmerAnlassLinkMapper.toDto(tal)).thenReturn(talDto);
            when(anlassSrv.findAnlassById(anlass.getId())).thenReturn(anlass);

            List<TeilnahmenDTO> res = teilnahmenService.getTeilnahmen(2025, orgId, false);
            assertEquals(1, res.size());
            TeilnahmenDTO dto = res.get(0);
            assertEquals(t.getId(), dto.getTeilnehmer().getId());
            assertEquals(1, dto.getTalDTOList().size());
        }
    }

    @Nested
    class UpdateTeilnahmenTests {
        @Test
        void whenAnlassNotFound_thenPropagateEntityNotFound() throws Exception {
            UUID orgId = UUID.randomUUID();
            // create teilnehmer dto
            UUID pid = UUID.randomUUID();
            TeilnehmerDTO teilnDTO = TeilnehmerDTO.builder().id(pid).organisationid(orgId).name("X").vorname("Y").jahrgang(0).stvNummer("").tiTu(TiTuEnum.Ti).aktiv(true).dirty(false).letzteKategorie(null).build();
            TeilnahmenDTO teilnahmenDTO = new TeilnahmenDTO(teilnDTO, new ArrayList<>());
            // create tal dto referencing non-existing anlass
            UUID anlassId = UUID.randomUUID();
            TeilnehmerAnlassLinkDTO talDto = new TeilnehmerAnlassLinkDTO(anlassId, pid, orgId, KategorieEnum.K1, "", false, 0, null, false, null, false, null, false);
            teilnahmenDTO.getTalDTOList().add(talDto);
            // teilnehmer exists
            Teilnehmer persisted = new Teilnehmer(); persisted.setId(pid);
            when(teilnehmerSrv.findTeilnehmerById(pid)).thenReturn(persisted);
            // throw RuntimeException wrapping EntityNotFoundException because Mockito cannot throw checked exceptions for this method
            doAnswer(inv -> { throw new RuntimeException(new org.ztv.anmeldetool.exception.EntityNotFoundException(Anlass.class, anlassId)); })
                    .when(anlassSrv).findAnlassById(anlassId);

            RuntimeException ex = assertThrows(RuntimeException.class, () -> teilnahmenService.updateTeilnahmen(2025, orgId, teilnahmenDTO));
            assertTrue(ex.getCause() instanceof org.ztv.anmeldetool.exception.EntityNotFoundException);
        }

        @Test
        void whenAddingNewTal_thenSaveAndReturnUpdatedList() throws Exception {
            UUID orgId = UUID.randomUUID();
            UUID pid = UUID.randomUUID();
            TeilnehmerDTO teilnDTO = TeilnehmerDTO.builder().id(pid).organisationid(orgId).name("N").vorname("F").jahrgang(0).stvNummer("").tiTu(TiTuEnum.Ti).aktiv(true).dirty(false).letzteKategorie(null).build();
            TeilnahmenDTO teilnahmenDTO = new TeilnahmenDTO(teilnDTO, new ArrayList<>());
            UUID anlassId = UUID.randomUUID();
            TeilnehmerAnlassLinkDTO talDto = new TeilnehmerAnlassLinkDTO(anlassId, pid, orgId, KategorieEnum.K1, "", false, 0, null, false, null, false, null, false);
            teilnahmenDTO.getTalDTOList().add(talDto);

            Teilnehmer persisted = new Teilnehmer(); persisted.setId(pid);
            when(teilnehmerSrv.findTeilnehmerById(pid)).thenReturn(persisted);
            // no existing tal
            Anlass anlass = new Anlass(); anlass.setId(anlassId);
            when(anlassSrv.findAnlassById(anlassId)).thenReturn(anlass);
            when(teilnehmerAnlassLinkSrv.findTeilnehmerAnlassLinkByAnlassAndTeilnehmer(anlass, persisted)).thenReturn(Optional.empty());
            // map DTO->entity
            TeilnehmerAnlassLink talNeu = new TeilnehmerAnlassLink(); talNeu.setKategorie(KategorieEnum.K1);
            talNeu.setAnlass(anlass);
            when(teilnehmerAnlassLinkMapper.toEntity(talDto)).thenReturn(talNeu);
            when(teilnehmerAnlassLinkSrv.findMaxStartNummer()).thenReturn(5);
            // ensure save invoked
            doAnswer(inv -> {
                TeilnehmerAnlassLink arg = inv.getArgument(0);
                // simulate persisted id
                arg.setId(UUID.randomUUID());
                return arg;
            }).when(teilnehmerAnlassLinkSrv).save(any(TeilnehmerAnlassLink.class));
            // after processing, findTeilnehmerAnlassLinkByTeilnehmer returns list with saved tal
            when(teilnehmerAnlassLinkSrv.findTeilnehmerAnlassLinkByTeilnehmer(persisted)).thenReturn(List.of(talNeu));
            // mapper for persisted link back to DTO (used at end of updateTeilnahmen)
            TeilnehmerAnlassLinkDTO persistedDto = new TeilnehmerAnlassLinkDTO(anlassId, pid, orgId, KategorieEnum.K1, "Startet", false, 5, null, false, null, false, null, false);
            when(teilnehmerAnlassLinkMapper.toDto(any(TeilnehmerAnlassLink.class))).thenReturn(persistedDto);

            TeilnahmenDTO res = teilnahmenService.updateTeilnahmen(2025, orgId, teilnahmenDTO);
            assertNotNull(res);
            assertEquals(1, res.getTalDTOList().size());
        }
    }
}
