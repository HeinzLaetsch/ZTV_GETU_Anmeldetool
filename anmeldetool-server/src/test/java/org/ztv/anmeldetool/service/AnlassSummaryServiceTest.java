package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.transfer.AnlassSummaryDTO;

import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AnlassSummaryServiceTest {

    @Mock
    AnlassService anlassSrv;

    @InjectMocks
    AnlassSummaryService anlassSummaryService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Nested
    class GetAnlassSummariesTests {
        @Test
        void whenAnlaesseNull_thenReturnNull() {
            UUID orgId = UUID.randomUUID();
            when(anlassSrv.getAnlaesse(true)).thenReturn(null);
            assertNull(anlassSummaryService.getAnlassSummaries(orgId, true));
        }

        @Test
        void whenAnlaessePresent_thenReturnCollection() {
            UUID orgId = UUID.randomUUID();
            UUID anlassId = UUID.randomUUID();
            Anlass a = new Anlass();
            a.setId(anlassId);
            when(anlassSrv.getAnlaesse(false)).thenReturn(List.of(a));
            // For this test return null for vereinStart so getAnlassSummary produces started=false DTO
            when(anlassSrv.getVereinStart(anlassId, orgId)).thenReturn(null);

            Collection<AnlassSummaryDTO> summaries = anlassSummaryService.getAnlassSummaries(orgId, false);
            assertNotNull(summaries);
            assertEquals(1, summaries.size());
            AnlassSummaryDTO dto = summaries.iterator().next();
            assertEquals(anlassId, dto.getAnlassId());
            assertEquals(orgId, dto.getOrganisationsId());
            assertFalse(dto.isStartet());
        }
    }

    @Nested
    class GetAnlassSummaryTests {
        @Test
        void whenOalNull_thenReturnNotStartedDto() {
            UUID anlassId = UUID.randomUUID();
            UUID orgId = UUID.randomUUID();
            when(anlassSrv.getVereinStart(anlassId, orgId)).thenReturn(null);
            AnlassSummaryDTO dto = anlassSummaryService.getAnlassSummary(anlassId, orgId);
            assertNotNull(dto);
            assertEquals(anlassId, dto.getAnlassId());
            assertEquals(orgId, dto.getOrganisationsId());
            assertFalse(dto.isStartet());
            assertEquals(0, dto.getStartendeBr1());
            assertEquals(0, dto.getStartendeBr2());
            assertTrue(dto.isBr1Ok());
            assertTrue(dto.isBr2Ok());
        }

        @Test
        void whenOalNotActive_thenReturnDtoWithZeroCounts() {
            UUID anlassId = UUID.randomUUID();
            UUID orgId = UUID.randomUUID();
            OrganisationAnlassLink oal = new OrganisationAnlassLink();
            oal.setAktiv(false);
            oal.setVerlaengerungsDate(LocalDateTime.now());
            when(anlassSrv.getVereinStart(anlassId, orgId)).thenReturn(oal);
            AnlassSummaryDTO dto = anlassSummaryService.getAnlassSummary(anlassId, orgId);
            assertNotNull(dto);
            assertFalse(dto.isStartet());
            assertEquals(0, dto.getStartendeBr1());
            assertEquals(0, dto.getStartendeBr2());
        }

        @Test
        void whenOalActive_thenComputeCountsAndBrevetChecks() {
            UUID anlassId = UUID.randomUUID();
            UUID orgId = UUID.randomUUID();
            OrganisationAnlassLink oal = new OrganisationAnlassLink();
            oal.setAktiv(true);
            LocalDateTime verl = LocalDateTime.of(2025, 9, 23, 12, 0);
            oal.setVerlaengerungsDate(verl);

            // teilnahmen: K1(STARTET), K2(ABGEMELDET), K5(NEUMELDUNG)
            TeilnehmerAnlassLink tal1 = new TeilnehmerAnlassLink();
            tal1.setKategorie(KategorieEnum.K1);
            tal1.setMeldeStatus(MeldeStatusEnum.STARTET);

            TeilnehmerAnlassLink tal2 = new TeilnehmerAnlassLink();
            tal2.setKategorie(KategorieEnum.K2);
            tal2.setMeldeStatus(MeldeStatusEnum.ABGEMELDET);

            TeilnehmerAnlassLink tal3 = new TeilnehmerAnlassLink();
            tal3.setKategorie(KategorieEnum.K5);
            tal3.setMeldeStatus(MeldeStatusEnum.NEUMELDUNG);

            List<TeilnehmerAnlassLink> links = List.of(tal1, tal2, tal3);

            when(anlassSrv.getVereinStart(anlassId, orgId)).thenReturn(oal);
            when(anlassSrv.getTeilnahmen(anlassId, orgId, false)).thenReturn(links);

            // Eingeteilte wertungsrichter: Brevet_1 -> 1, Brevet_2 -> 0
            PersonAnlassLink pal = new PersonAnlassLink();
            when(anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_1))
                    .thenReturn(List.of(pal));
            when(anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_2))
                    .thenReturn(Collections.emptyList());

            AnlassSummaryDTO dto = anlassSummaryService.getAnlassSummary(anlassId, orgId);

            assertNotNull(dto);
            assertTrue(dto.isStartet());
            assertEquals(verl, dto.getVerlaengerungsDate());
            // startBr1 counts youth categories (K1 and K2) => 2
            assertEquals(2, dto.getStartendeBr1());
            // startBr2 counts aktiv categories (K5) => 1
            assertEquals(1, dto.getStartendeBr2());
            // startendeK1 should be 1 (tal1 STARTET)
            assertEquals(1, dto.getStartendeK1());
            // startendeK2 should be 0 (ABGEMELDET)
            assertEquals(0, dto.getStartendeK2());
            // startendeK5 should be 1 (NEUMELDUNG)
            assertEquals(1, dto.getStartendeK5());

            // gemeldeteBr1 = 1, gemeldeteBr2 = 0
            assertEquals(1, dto.getGemeldeteBr1());
            assertEquals(0, dto.getGemeldeteBr2());
            // br1Ok: ceil(2/15)=1 <= 1 -> true
            assertTrue(dto.isBr1Ok());
            // br2Ok: ceil(1/15)=1 <= 0 -> false
            assertFalse(dto.isBr2Ok());
        }

        @Test
        void whenVereinStartThrows_thenPropagateException() {
            UUID anlassId = UUID.randomUUID();
            UUID orgId = UUID.randomUUID();
            when(anlassSrv.getVereinStart(anlassId, orgId)).thenThrow(new RuntimeException("boom"));
            assertThrows(RuntimeException.class, () -> anlassSummaryService.getAnlassSummary(anlassId, orgId));
        }
    }
}
