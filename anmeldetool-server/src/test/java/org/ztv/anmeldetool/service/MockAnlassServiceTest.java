package org.ztv.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.repositories.*;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.VereinsStartDTO;
import org.ztv.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;

@ExtendWith(MockitoExtension.class)
@Disabled
class MockAnlassServiceTest {

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

    @InjectMocks
    private AnlassService anlassService;

    // ... all previously generated nested test classes ...

    @Nested
    @DisplayName("Tests for getTeilnahmen by year")
    class GetTeilnahmenByJahrTests {
        private AnlassService spiedAnlassService;

        @BeforeEach
        void setUp() {
            spiedAnlassService = spy(anlassService);
        }

        @Test
        @DisplayName("should aggregate results from multiple anlaesse")
        void getTeilnahmen_WhenAnlaesseExist_ShouldAggregateResults() {
            int jahr = 2024;
            UUID orgId = UUID.randomUUID();
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);
            Anlass anlass1 = new Anlass();
            anlass1.setId(UUID.randomUUID());
            Anlass anlass2 = new Anlass();
            anlass2.setId(UUID.randomUUID());

            Teilnehmer teilnehmer = Teilnehmer.builder().name("Test").vorname("Person").build();
            TeilnehmerAnlassLink link1 = new TeilnehmerAnlassLink();
            link1.setTeilnehmer(teilnehmer);
            TeilnehmerAnlassLink link2 = new TeilnehmerAnlassLink();
            link2.setTeilnehmer(teilnehmer);

            when(anlassRepo.findByStartDateBetweenAndAktivOrderByStartDate(any(), any(), anyBoolean())).thenReturn(List.of(anlass1, anlass2));
            doReturn(List.of(link1)).when(spiedAnlassService).getTeilnahmen(anlass1, org, false);
            doReturn(List.of(link2)).when(spiedAnlassService).getTeilnahmen(anlass2, org, false);

            Map<Teilnehmer, List<TeilnehmerAnlassLink>> result = spiedAnlassService.getTeilnahmen(jahr, org);

            assertThat(result).hasSize(1);
            assertThat(result.get(teilnehmer)).hasSize(2).contains(link1, link2);
        }

        @Test
        @DisplayName("should return an empty map when no anlaesse are found")
        void getTeilnahmen_WhenNoAnlaesseExist_ShouldReturnEmptyMap() {
            int jahr = 2024;
            Anlass anlass1 = new Anlass();
            anlass1.setId(UUID.randomUUID());

            UUID orgId = UUID.randomUUID();
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);
            when(anlassRepo.findByStartDateBetweenAndAktivOrderByStartDate(any(), any(), anyBoolean())).thenReturn(Collections.emptyList());

            Map<Teilnehmer, List<TeilnehmerAnlassLink>> result = anlassService.getTeilnahmen(jahr, org);

            assertThat(result).isEmpty();
            verify(spiedAnlassService, never()).getTeilnahmen(anlass1, org, anyBoolean());
        }
    }
}
