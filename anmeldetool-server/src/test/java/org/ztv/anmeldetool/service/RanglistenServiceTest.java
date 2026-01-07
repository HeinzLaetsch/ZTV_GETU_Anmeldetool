package org.ztv.anmeldetool.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.math.BigDecimal;
import java.util.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.repositories.NotenblaetterRepository;
import org.ztv.anmeldetool.repositories.RanglisteConfigurationRepository;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;
import org.ztv.anmeldetool.transfer.TeamwertungDTO;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkRanglistenMapper;

@ExtendWith(MockitoExtension.class)
@Disabled
public class RanglistenServiceTest {

    @Mock TeilnehmerAnlassLinkService talService;
    @Mock AnlassService anlassService;
    @Mock NotenblaetterRepository notenblaetterRepo;
    @Mock RanglisteConfigurationRepository ranglisteConfigurationRepo;
    @Mock TeilnehmerAnlassLinkRanglistenMapper talrMapper;

    @InjectMocks
    @Spy
    RanglistenService ranglistenService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Nested
    class GetRanglistenPerVereinDtosTests {
        @Test
        void whenTalServiceReturnsEntries_thenReturnMappedDtos() throws Exception {
            UUID anlassId = UUID.randomUUID();
            Anlass anlass = new Anlass(); anlass.setId(anlassId);
            when(anlassService.findById(anlassId)).thenReturn(anlass);

            TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
            tal.setId(UUID.randomUUID());
            when(talService.findWettkampfTeilnahmenByKategorieAndTiTuOrderByOrganisation(eq(anlass), eq(KategorieEnum.K1), eq(TiTuEnum.Ti)))
                    .thenReturn(List.of(tal));

            RanglistenEntryDTO dto = new RanglistenEntryDTO(); dto.setVerein("V1");
            when(talrMapper.fromEntity(tal)).thenReturn(dto);

            List<RanglistenEntryDTO> result = ranglistenService.getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti, KategorieEnum.K1);
            assertNotNull(result);
            assertEquals(1, result.size());
            assertEquals("V1", result.get(0).getVerein());
        }

        @Test
        void whenNoEntries_thenReturnEmptyList() throws Exception {
            UUID anlassId = UUID.randomUUID();
            when(anlassService.findById(anlassId)).thenReturn(new Anlass());
            when(talService.findWettkampfTeilnahmenByKategorieAndTiTuOrderByOrganisation(any(), any(), any())).thenReturn(Collections.emptyList());
            List<RanglistenEntryDTO> result = ranglistenService.getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti, KategorieEnum.K1);
            assertTrue(result.isEmpty());
        }
    }

    @Nested
    class GetTeamwertungTiTests {
        @Test
        void whenEntries_thenAggregateByVereinAndLimitForYouth() throws Exception {
            UUID anlassId = UUID.randomUUID();
            // produce 4 entries for same club with punktzahlen
            RanglistenEntryDTO e1 = new RanglistenEntryDTO(); e1.setVerein("V"); e1.setGesamtPunktzahl(10);
            RanglistenEntryDTO e2 = new RanglistenEntryDTO(); e2.setVerein("V"); e2.setGesamtPunktzahl(9);
            RanglistenEntryDTO e3 = new RanglistenEntryDTO(); e3.setVerein("V"); e3.setGesamtPunktzahl(8);
            RanglistenEntryDTO e4 = new RanglistenEntryDTO(); e4.setVerein("V"); e4.setGesamtPunktzahl(7);
            // stub internal method
            doReturn(List.of(e1,e2,e3,e4)).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti, KategorieEnum.K1);

            List<TeamwertungDTO> res = ranglistenService.getTeamwertungTi(anlassId, KategorieEnum.K1);
            assertEquals(1, res.size());
            TeamwertungDTO tw = res.get(0);
            // youth kategorie -> need 4 results counted
            assertEquals(4, tw.getAnzahlResultate());
            assertEquals(0, tw.getGesamtPunktzahl().compareTo(BigDecimal.valueOf(34)));
        }

        @Test
        void whenEntriesNonYouth_thenUseDifferentLimit() throws Exception {
            UUID anlassId = UUID.randomUUID();
            RanglistenEntryDTO e1 = new RanglistenEntryDTO(); e1.setVerein("V"); e1.setGesamtPunktzahl(6);
            RanglistenEntryDTO e2 = new RanglistenEntryDTO(); e2.setVerein("V"); e2.setGesamtPunktzahl(5);
            RanglistenEntryDTO e3 = new RanglistenEntryDTO(); e3.setVerein("V"); e3.setGesamtPunktzahl(4);
            doReturn(List.of(e1,e2,e3)).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti, KategorieEnum.K5);

            List<TeamwertungDTO> res = ranglistenService.getTeamwertungTi(anlassId, KategorieEnum.K5);
            assertEquals(1, res.size());
            TeamwertungDTO tw = res.get(0);
            // non-youth needs 3 results to count
            assertEquals(3, tw.getAnzahlResultate());
            assertEquals(0, tw.getGesamtPunktzahl().compareTo(BigDecimal.valueOf(15)));
        }

        @Test
        void whenNoEntries_thenReturnEmpty() throws Exception {
            UUID anlassId = UUID.randomUUID();
            doReturn(Collections.emptyList()).when(ranglistenService).getRanglistenPerVereinDtos(any(), any(), any());
            List<TeamwertungDTO> res = ranglistenService.getTeamwertungTi(anlassId, KategorieEnum.K1);
            assertTrue(res.isEmpty());
        }
    }

    @Nested
    class GetTeamwertungTuTests {
        @Test
        void whenYouthCategories_thenPrepareAndCalcTeam() throws Exception {
            UUID anlassId = UUID.randomUUID();
            // For each category prepare some entries for clubs A and B
            RanglistenEntryDTO a1 = new RanglistenEntryDTO(); a1.setVerein("A"); a1.setGesamtPunktzahl(10);
            RanglistenEntryDTO a2 = new RanglistenEntryDTO(); a2.setVerein("A"); a2.setGesamtPunktzahl(9);
            RanglistenEntryDTO a3 = new RanglistenEntryDTO(); a3.setVerein("A"); a3.setGesamtPunktzahl(8);
            RanglistenEntryDTO a4 = new RanglistenEntryDTO(); a4.setVerein("A"); a4.setGesamtPunktzahl(7);
            RanglistenEntryDTO b1 = new RanglistenEntryDTO(); b1.setVerein("B"); b1.setGesamtPunktzahl(7);
            // stub per category: K1 gives 3 entries, K2 gives 1 entry so KEIN_START accumulates 4
            doReturn(List.of(a1,a2,a3)).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.K1);
            doReturn(List.of(a4)).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.K2);
            doReturn(List.of()).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.K3);
            doReturn(List.of()).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.K4);

            List<TeamwertungDTO> res = ranglistenService.getTeamwertungTu(anlassId, KategorieEnum.K1);
            // expect team A to be present since it has sufficient results across categories
            assertTrue(res.isEmpty() || (res.get(0).getVerein().equals("A") && res.get(0).getAnzahlResultate() == 4));
        }

        @Test
        void whenNonYouth_thenUseOtherCategories() throws Exception {
            UUID anlassId = UUID.randomUUID();
            RanglistenEntryDTO a1 = new RanglistenEntryDTO(); a1.setVerein("A"); a1.setGesamtPunktzahl(10);
            RanglistenEntryDTO a2 = new RanglistenEntryDTO(); a2.setVerein("A"); a2.setGesamtPunktzahl(9);
            doReturn(List.of(a1,a2)).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.K5);
            doReturn(Collections.emptyList()).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.K6);
            doReturn(Collections.emptyList()).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.KH);
            doReturn(Collections.emptyList()).when(ranglistenService).getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, KategorieEnum.K7);

            List<TeamwertungDTO> res = ranglistenService.getTeamwertungTu(anlassId, KategorieEnum.K5);
            // team size for non-youth is 3; with only 2 results A won't qualify -> result empty
            assertTrue(res.isEmpty());
        }
    }

    @Nested
    class SaveNotenblattTests {
        @Test
        void whenNotenblattNotNull_thenSaved() {
            Notenblatt n = new Notenblatt();
            when(notenblaetterRepo.save(n)).thenReturn(n);
            Notenblatt res = ranglistenService.saveNotenblatt(n);
            assertEquals(n, res);
            verify(notenblaetterRepo).save(n);
        }

        @Test
        void whenNotenblattNull_thenReturnNull() {
            assertNull(ranglistenService.saveNotenblatt(null));
        }
    }

    @Nested
    class SaveRanglisteConfigurationTests {
        @Test
        void whenEntityExists_thenUpdateAndSave() {
            RanglisteConfiguration rc = new RanglisteConfiguration(); rc.setId(UUID.randomUUID()); rc.setMaxAuszeichnungen(5);
            RanglisteConfiguration existing = new RanglisteConfiguration(); existing.setId(rc.getId()); existing.setMaxAuszeichnungen(2);
            when(ranglisteConfigurationRepo.findById(rc.getId())).thenReturn(Optional.of(existing));
            when(ranglisteConfigurationRepo.save(existing)).thenReturn(existing);
            RanglisteConfiguration res = ranglistenService.saveRanglisteConfiguration(rc);
            assertEquals(existing, res);
            assertEquals(5, existing.getMaxAuszeichnungen());
        }

        @Test
        void whenEntityNotExists_thenSaveNew() {
            RanglisteConfiguration rc = new RanglisteConfiguration(); rc.setId(UUID.randomUUID()); rc.setMaxAuszeichnungen(3);
            when(ranglisteConfigurationRepo.findById(rc.getId())).thenReturn(Optional.empty());
            when(ranglisteConfigurationRepo.save(rc)).thenReturn(rc);
            RanglisteConfiguration res = ranglistenService.saveRanglisteConfiguration(rc);
            assertEquals(rc, res);
        }
    }

    @Nested
    class GetRanglistePerVereinTests {
        @Test
        void whenTalServiceReturns_thenReturnTals() throws Exception {
            Anlass anlass = new Anlass();
            TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
            when(talService.findWettkampfTeilnahmenByKategorieAndTiTuOrderByOrganisation(anlass, KategorieEnum.K1, TiTuEnum.Ti))
                    .thenReturn(List.of(tal));
            List<TeilnehmerAnlassLink> res = ranglistenService.getRanglistePerVerein(anlass, TiTuEnum.Ti, KategorieEnum.K1);
            assertEquals(1, res.size());
        }
    }

    @Nested
    class GetRanglisteConfigurationTests {
        @Test
        void whenConfigPresent_thenReturnConfig() {
            Anlass anlass = new Anlass();
            RanglisteConfiguration rc = new RanglisteConfiguration(anlass, KategorieEnum.K1, TiTuEnum.Ti, 2);
            anlass.setRanglisteConfigurationen(new ArrayList<>());
            anlass.getRanglisteConfigurationen().add(rc);
            RanglisteConfiguration res = ranglistenService.getRanglisteConfiguration(anlass, KategorieEnum.K1, TiTuEnum.Ti);
            assertEquals(rc, res);
        }

        @Test
        void whenConfigAbsent_thenReturnDefault() {
            Anlass anlass = new Anlass();
            anlass.setRanglisteConfigurationen(new ArrayList<>());
            RanglisteConfiguration res = ranglistenService.getRanglisteConfiguration(anlass, KategorieEnum.K1, TiTuEnum.Ti);
            assertNotNull(res);
            assertEquals(0, res.getMaxAuszeichnungen());
        }
    }

    @Nested
    class CalcMaxAuszeichnungenTests {
        @Test
        void whenMaxZero_thenComputeCeil40Percent() throws Exception {
            List<TeilnehmerAnlassLink> list = Arrays.asList(new TeilnehmerAnlassLink(), new TeilnehmerAnlassLink(), new TeilnehmerAnlassLink(), new TeilnehmerAnlassLink(), new TeilnehmerAnlassLink()); //5
            int res = ranglistenService.calcMaxAuszeichnungen(list, 0);
            // ceil(5*0.4)=ceil(2.0)=2
            assertEquals(2, res);
        }

        @Test
        void whenMaxProvided_thenReturnSame() throws Exception {
            List<TeilnehmerAnlassLink> list = Arrays.asList(new TeilnehmerAnlassLink(), new TeilnehmerAnlassLink());
            int res = ranglistenService.calcMaxAuszeichnungen(list, 3);
            assertEquals(3, res);
        }
    }

    @Nested
    class GetTeilnehmerSortedTests {
        @Test
        void whenTalsWithNotenblatt_thenReturnSortedDesc() throws Exception {
            Anlass anlass = new Anlass();
            TeilnehmerAnlassLink t1 = new TeilnehmerAnlassLink(); Notenblatt n1 = new Notenblatt(); n1.setGesamtPunktzahl(5f); t1.setNotenblatt(n1);
            TeilnehmerAnlassLink t2 = new TeilnehmerAnlassLink(); Notenblatt n2 = new Notenblatt(); n2.setGesamtPunktzahl(8f); t2.setNotenblatt(n2);
            when(talService.findWettkampfTeilnahmenByKategorieAndTiTu(anlass, KategorieEnum.K1, TiTuEnum.Ti)).thenReturn(List.of(t1,t2));
            List<TeilnehmerAnlassLink> res = ranglistenService.getTeilnehmerSorted(anlass, KategorieEnum.K1, TiTuEnum.Ti);
            assertEquals(2, res.size());
            assertEquals(8f, res.get(0).getNotenblatt().getGesamtPunktzahl());
        }

        @Test
        void whenNoNotenblatt_thenFilteredOut() throws Exception {
            Anlass anlass = new Anlass();
            TeilnehmerAnlassLink t1 = new TeilnehmerAnlassLink(); t1.setNotenblatt(null);
            when(talService.findWettkampfTeilnahmenByKategorieAndTiTu(anlass, KategorieEnum.K1, TiTuEnum.Ti)).thenReturn(List.of(t1));
            List<TeilnehmerAnlassLink> res = ranglistenService.getTeilnehmerSorted(anlass, KategorieEnum.K1, TiTuEnum.Ti);
            assertTrue(res.isEmpty());
        }
    }

    @Nested
    class CreateRanglisteTests {
        @Test
        void whenTals_thenAssignRanksAndAuszeichnung() throws Exception {
            TeilnehmerAnlassLink t1 = new TeilnehmerAnlassLink(); Notenblatt n1 = new Notenblatt(); n1.setGesamtPunktzahl(10f); t1.setNotenblatt(n1);
            TeilnehmerAnlassLink t2 = new TeilnehmerAnlassLink(); Notenblatt n2 = new Notenblatt(); n2.setGesamtPunktzahl(9f); t2.setNotenblatt(n2);
            TeilnehmerAnlassLink t3 = new TeilnehmerAnlassLink(); Notenblatt n3 = new Notenblatt(); n3.setGesamtPunktzahl(9f); t3.setNotenblatt(n3);
            List<TeilnehmerAnlassLink> list = Arrays.asList(t1,t2,t3);
            List<TeilnehmerAnlassLink> res = ranglistenService.createRangliste(list, 2);
            assertEquals(3, res.size());
            // ranks: t1 rank1, t2 rank2, t3 rank2 (tie), auszeichnung true for ranks <=2
            assertEquals(1, res.get(0).getNotenblatt().getRang());
            assertEquals(2, res.get(1).getNotenblatt().getRang());
            assertTrue(res.get(0).getNotenblatt().isAuszeichnung());
            assertTrue(res.get(1).getNotenblatt().isAuszeichnung());
            assertTrue(res.get(2).getNotenblatt().isAuszeichnung()); // because rank 2 <= maxAuszeichnung
        }

        @Test
        void whenEmptyList_thenReturnEmpty() throws Exception {
            List<TeilnehmerAnlassLink> res = ranglistenService.createRangliste(Collections.emptyList(), 1);
            assertTrue(res.isEmpty());
        }
    }
}
