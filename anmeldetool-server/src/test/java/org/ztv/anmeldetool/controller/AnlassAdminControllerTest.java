package org.ztv.anmeldetool.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.WriteListener;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.net.URI;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.web.util.UriComponents;
import org.ztv.anmeldetool.exception.EntityNotFoundException;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.output.AnmeldeKontrolleOutput;
import org.ztv.anmeldetool.output.WertungsrichterOutput;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.AnlassSummaryService;
import org.ztv.anmeldetool.service.ServiceException;
import org.ztv.anmeldetool.service.StvContestService;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.AnlassSummaryDTO;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerStartDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterEinsatzDTO;
import org.ztv.anmeldetool.util.AnmeldeKontrolleExport;
import org.ztv.anmeldetool.util.BenutzerExport;
import org.ztv.anmeldetool.util.TeilnehmerExportImport;
import org.ztv.anmeldetool.util.WertungsrichterExport;

// ...existing code...

@ExtendWith(MockitoExtension.class)
public class AnlassAdminControllerTest {

  @InjectMocks
  AnlassAdminController controller;

  @Mock
  AnlassService anlassSrv;

  @Mock
  AnlassSummaryService anlassSummaryService;

  @Mock
  TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;

  @Mock
  TeilnehmerService teilnehmerSrv;

  @Mock
  StvContestService stvContestService;

  // mappers and utils used by controller
  @Mock
  org.ztv.anmeldetool.util.AnlassMapper anlassMapper;

  @Mock
  org.ztv.anmeldetool.util.PersonAnlassLinkExportImportMapper palExImMapper;

  @Mock
  org.ztv.anmeldetool.util.PersonAnlassLinkMapper palMapper;

  @Mock
  org.ztv.anmeldetool.util.OrganisationMapper organisationMapper;

  @Mock
  org.ztv.anmeldetool.util.TeilnehmerAnlassLinkExportImportMapper talExImMapper;

  @Mock
  org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper teilnehmerAnlassMapper;

  @Mock
  org.ztv.anmeldetool.util.WertungsrichterEinsatzMapper wertungsrichterEinsatzMapper;

  @Mock
  org.ztv.anmeldetool.service.WertungsrichterEinsatzService wertungsrichterEinsatzSrv;

  @Mock
  org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository personAnlassLinkRepository;

  // minimal mocks for other services to satisfy injection
  @Mock
  org.ztv.anmeldetool.service.LoginService loginSrv;
  @Mock
  org.ztv.anmeldetool.service.PersonService personSrv;
  @Mock
  org.ztv.anmeldetool.service.RoleService roleSrv;
  @Mock
  org.ztv.anmeldetool.service.OrganisationService organisationSrv;
  @Mock
  org.ztv.anmeldetool.service.VerbandService verbandsSrv;
  @Mock
  org.ztv.anmeldetool.service.WertungsrichterService wertungsrichterSrv;
  @Mock
  org.ztv.anmeldetool.util.WertungsrichterMapper wrMapper;
  @Mock
  org.ztv.anmeldetool.util.PersonMapper personMapper;
  @Mock
  org.ztv.anmeldetool.util.AnlassMapper anlassMap2; // avoid name clash
  @Mock
  org.ztv.anmeldetool.util.OrganisationAnlassLinkMapper oalMapper;
  @Mock
  org.ztv.anmeldetool.util.WertungsrichterMapper wertungsrichterMapper;
  @Mock
  org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

  @BeforeEach
  public void setup() {
    // nothing special here, mocks are injected by Mockito
  }

  // Helper to mock ServletUriComponentsBuilder.fromCurrentRequest() used by getNotFound()
  private void mockServletUriComponentsBuilder() throws Exception {
    MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
        ServletUriComponentsBuilder.class);
    ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
    UriComponents uriComp = mock(UriComponents.class);
    when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
    when(builderMock.build()).thenReturn(uriComp);
    mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);
    // keep mocked static open for the duration of the call by not closing it here; tests will close when method returns
  }

  @Nested
  class GetAnlaesseTests {

    @Test
    void positive_returnsList() {
      Anlass anlass = new Anlass();
      UUID id = UUID.randomUUID();
      anlass.setId(id);
      when(anlassSrv.getAnlaesse(true)).thenReturn(List.of(anlass));
      AnlassDTO dto = mock(AnlassDTO.class);
      // dto.setId(id);
      when(anlassMapper.toDto(anlass)).thenReturn(dto);

      ResponseEntity<Collection<AnlassDTO>> resp = controller.getAnlaesse(Optional.empty());
      assertEquals(200, resp.getStatusCodeValue());
      assertNotNull(resp.getBody());
      assertEquals(1, resp.getBody().size());
    }

    @Test
    void negative_empty_returnsNotFound() throws Exception {
      when(anlassSrv.getAnlaesse(true)).thenReturn(Collections.emptyList());
      // mock static ServletUriComponentsBuilder to avoid request context issues
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

        ResponseEntity<Collection<AnlassDTO>> resp = controller.getAnlaesse(Optional.of(true));
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class GetAnlassOrganisationSummariesTests {

    @Test
    void positive_returnsSummaries() {
      AnlassSummaryDTO dto = mock(AnlassSummaryDTO.class);
      when(anlassSummaryService.getAnlassSummaries(any(), eq(true))).thenReturn(List.of(dto));
      ResponseEntity<Collection<AnlassSummaryDTO>> resp = controller.getAnlassOrganisationSummaries(
          mock(HttpServletRequest.class), UUID.randomUUID());
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_empty_returnsNotFound() throws Exception {
      when(anlassSummaryService.getAnlassSummaries(any(), eq(true))).thenReturn(
          Collections.emptyList());
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

        ResponseEntity<Collection<AnlassSummaryDTO>> resp = controller.getAnlassOrganisationSummaries(
            mock(HttpServletRequest.class), UUID.randomUUID());
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class GetVereinStartTests {

    @Test
    void positive_returnsDto() {
      OrganisationAnlassLink oal = mock(OrganisationAnlassLink.class);
      when(anlassSrv.getVereinStart(any(), any())).thenReturn(oal);
      OrganisationAnlassLinkDTO dto = mock(OrganisationAnlassLinkDTO.class);
      when(oalMapper.toDto(oal)).thenReturn(dto);
      ResponseEntity<?> resp = controller.getVereinStart(mock(HttpServletRequest.class),
          UUID.randomUUID(), UUID.randomUUID());
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_null_returnsNotFound() throws Exception {
      when(anlassSrv.getVereinStart(any(), any())).thenReturn(null);
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        // when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        // when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

        ResponseEntity<?> resp = controller.getVereinStart(mock(HttpServletRequest.class),
            UUID.randomUUID(), UUID.randomUUID());
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class WertungsrichterExportTests {

    @Test
    @Disabled("needs rewrite, see comment, test real logic")
    void positive_writesCsv() throws Exception {
      UUID anlassId = UUID.randomUUID();
      PersonAnlassLink pal = new PersonAnlassLink();
      Anlass anlass = new Anlass();
      anlass.setAnlassBezeichnung("TestEvent");
      pal.setAnlass(anlass);
      List<PersonAnlassLink> pals = List.of(pal);
      when(anlassSrv.getEingeteilteWertungsrichter(anlassId)).thenReturn(pals);
      when(palExImMapper.fromEntity(any())).thenReturn(
          mock(PersonAnlassLinkCsvDTO.class));

      HttpServletResponse response = mock(HttpServletResponse.class);
      /*
      when(response.getOutputStream()).thenReturn(new ServletOutputStream() {
        @Override
        public boolean isReady() {
          return false;
        }

        @Override
        public void setWriteListener(WriteListener listener) {

        }

        @Override
        public void write(int b) {
        }
      });
*/
      try (MockedStatic<WertungsrichterExport> ws = Mockito.mockStatic(
          WertungsrichterExport.class)) {
        controller.getWertungsrichter(mock(HttpServletRequest.class), response, anlassId);
        ws.verify(() -> WertungsrichterExport.csvWriteToWriter(anyList(), eq(response)));
      }
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID anlassId = UUID.randomUUID();
      when(anlassSrv.getEingeteilteWertungsrichter(anlassId)).thenThrow(
          new RuntimeException("boom"));
      HttpServletResponse response = mock(HttpServletResponse.class);
      assertThrows(ResponseStatusException.class,
          () -> controller.getWertungsrichter(mock(HttpServletRequest.class), response, anlassId));
    }
  }

  @Nested
  class AnmelderUndVerantwortlicheTests {

    @Test
    void positive_writesCsv() throws Exception {
      UUID anlassId = UUID.randomUUID();
      Anlass anlass = new Anlass();
      anlass.setAnlassBezeichnung("Event");
      anlass.setOrt("Ort");
      when(anlassSrv.findAnlassById(anlassId)).thenReturn(anlass);
      Organisation org = new Organisation();
      org.setName("Verein");
      // provide no persons -> result list empty but export will be called with empty list
      when(anlassSrv.getVereinsStarts(anlassId)).thenReturn(List.of(org));

      HttpServletResponse response = mock(HttpServletResponse.class);
      /*
      when(response.getOutputStream()).thenReturn(new ServletOutputStream() {
        @Override
        public boolean isReady() {
          return false;
        }

        @Override
        public void setWriteListener(WriteListener listener) {

        }

        @Override
        public void write(int b) {
        }
      });
*/
      try (MockedStatic<BenutzerExport> be = Mockito.mockStatic(BenutzerExport.class)) {
        controller.getAnmelderUndVerantwortliche(mock(HttpServletRequest.class), response,
            anlassId);
        be.verify(() -> BenutzerExport.csvWriteToWriter(anyList(), eq(response)));
      }
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID anlassId = UUID.randomUUID();
      when(anlassSrv.findAnlassById(anlassId)).thenThrow(new RuntimeException("boom"));
      HttpServletResponse response = mock(HttpServletResponse.class);
      assertThrows(ResponseStatusException.class,
          () -> controller.getAnmelderUndVerantwortliche(mock(HttpServletRequest.class), response,
              anlassId));
    }
  }

  @Nested
  class AnmeldeDatenExportTests {

    @Test
    @Disabled("needs rewrite, see comment, test real logic")
    void positive_writesCsv() throws Exception {
      UUID anlassId = UUID.randomUUID();
      AnmeldeKontrolleDTO ak = mock(AnmeldeKontrolleDTO.class);
      AnlassDTO aDto = mock(AnlassDTO.class);
      when(anlassSrv.getAnmeldeKontrolle(anlassId, null)).thenReturn(ak);

      HttpServletResponse response = mock(HttpServletResponse.class);
      /*
      when(response.getOutputStream()).thenReturn(new ServletOutputStream() {
        @Override
        public boolean isReady() {
          return false;
        }

        @Override
        public void setWriteListener(WriteListener listener) {

        }

        @Override
        public void write(int b) {
        }
      });
*/
      try (MockedStatic<AnmeldeKontrolleExport> as = Mockito.mockStatic(
          AnmeldeKontrolleExport.class)) {
        controller.getAnmeldeDatenExport(mock(HttpServletRequest.class), response, anlassId);
        as.verify(() -> AnmeldeKontrolleExport.csvWriteToWriter(eq(ak), eq(response)));
      }
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID anlassId = UUID.randomUUID();
      when(anlassSrv.getAnmeldeKontrolle(anlassId, null)).thenThrow(new RuntimeException("boom"));
      HttpServletResponse response = mock(HttpServletResponse.class);
      assertThrows(ResponseStatusException.class,
          () -> controller.getAnmeldeDatenExport(mock(HttpServletRequest.class), response,
              anlassId));
    }
  }

  @Nested
  class UpdateAnlassTests {

    @Test
    void positive_updatesAndReturnsDto() {
      UUID id = UUID.randomUUID();
      AnlassDTO dto = mock(AnlassDTO.class);
      Anlass anlass = new Anlass();
      anlass.setId(id);
      when(dto.getId()).thenReturn(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(anlass);
      when(anlassSrv.updateAnlass(any())).thenReturn(anlass);
      when(anlassMapper.toDto(any())).thenReturn(dto);

      ResponseEntity<AnlassDTO> resp = controller.updateAnlass(mock(HttpServletRequest.class),
          mock(HttpServletResponse.class), id, dto);
      assertEquals(200, resp.getStatusCodeValue());
      assertEquals(id, resp.getBody().getId());
    }

    @Test
    void negative_notFound_returnsNotFound() throws Exception {
      UUID id = UUID.randomUUID();
      AnlassDTO dto = mock(AnlassDTO.class);
      // Anlass anlass = mock(Anlass.class);
      when(dto.getId()).thenReturn(id);
      when(anlassSrv.findAnlassById(id)).thenReturn(null);
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

        ResponseEntity<AnlassDTO> resp = controller.updateAnlass(mock(HttpServletRequest.class),
            mock(HttpServletResponse.class), id, dto);
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class UpdateAnlassStartTests {

    @Test
    void positive_callsServiceAndReturnsOk() throws Exception {
      UUID id = UUID.randomUUID();
      TeilnehmerStartDTO ts = mock(TeilnehmerStartDTO.class);
      ResponseEntity resp = controller.updateAnlassStart(mock(HttpServletRequest.class),
          mock(HttpServletResponse.class), id, ts);
      assertEquals(200, resp.getStatusCodeValue());
      verify(teilnehmerAnlassLinkSrv, times(1)).updateAnlassTeilnahme(ts);
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID id = UUID.randomUUID();
      TeilnehmerStartDTO ts = mock(TeilnehmerStartDTO.class);
      doThrow(new ServiceException(TeilnehmerStartDTO.class, "fail")).when(teilnehmerAnlassLinkSrv)
          .updateAnlassTeilnahme(ts);
      assertThrows(ResponseStatusException.class,
          () -> controller.updateAnlassStart(mock(HttpServletRequest.class),
              mock(HttpServletResponse.class), id, ts));
    }
  }

  @Nested
  class TeilnahmeStatisticTests {

    @Test
    void positive_returnsStatistic() throws Exception {
      UUID id = UUID.randomUUID();
      org.ztv.anmeldetool.transfer.TeilnahmeStatisticDTO stat = new org.ztv.anmeldetool.transfer.TeilnahmeStatisticDTO();
      when(teilnehmerAnlassLinkSrv.getStatisticForAnlass(eq(id), any(), any(), any(), any(),
          any())).thenReturn(stat);
      ResponseEntity<org.ztv.anmeldetool.transfer.TeilnahmeStatisticDTO> resp = controller.getAnlassStatistic(
          mock(HttpServletRequest.class), mock(HttpServletResponse.class), id, Optional.empty());
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID id = UUID.randomUUID();
      when(teilnehmerAnlassLinkSrv.getStatisticForAnlass(eq(id), any(), any(), any(), any(),
          any())).thenThrow(new ServiceException(TeilnehmerStartDTO.class, "boom"));
      assertThrows(ResponseStatusException.class,
          () -> controller.getAnlassStatistic(mock(HttpServletRequest.class),
              mock(HttpServletResponse.class), id, Optional.empty()));
    }
  }

  @Nested
  class ByStartgeraetTests {

    @Test
    void positive_returnsList() throws Exception {
      UUID id = UUID.randomUUID();
      when(teilnehmerAnlassLinkSrv.getTeilnehmerForStartgeraet(eq(id), any(), any(), any(), any(),
          any())).thenReturn(List.of(mock(TeilnehmerStartDTO.class)));
      ResponseEntity<List<TeilnehmerStartDTO>> resp = controller.getByStartgeraet(
          mock(HttpServletRequest.class), mock(HttpServletResponse.class), id, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1,
          GeraetEnum.BODEN, Optional.empty());
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID id = UUID.randomUUID();
      when(teilnehmerAnlassLinkSrv.getTeilnehmerForStartgeraet(eq(id), any(), any(), any(), any(),
          any())).thenThrow(new ServiceException(TeilnehmerStartDTO.class, "boom"));
      assertThrows(ResponseStatusException.class,
          () -> controller.getByStartgeraet(mock(HttpServletRequest.class),
              mock(HttpServletResponse.class), id, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1,
              GeraetEnum.BODEN, Optional.empty()));
    }
  }

  @Nested
  class MutationenTests {

    @Test
    void positive_writesCsv() throws Exception {
      UUID id = UUID.randomUUID();
      org.ztv.anmeldetool.models.TeilnehmerAnlassLink tal = new org.ztv.anmeldetool.models.TeilnehmerAnlassLink();
      Anlass anlass = new Anlass();
      anlass.setAnlassBezeichnung("Event");
      tal.setAnlass(anlass);
      when(teilnehmerAnlassLinkSrv.getMutationenForAnlass(id)).thenReturn(List.of(tal));
      when(talExImMapper.fromEntity(any())).thenReturn(
          new org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO());
      HttpServletResponse response = mock(HttpServletResponse.class);
      /*
      when(response.getOutputStream()).thenReturn(new ServletOutputStream() {
        @Override
        public boolean isReady() {
          return false;
        }

        @Override
        public void setWriteListener(WriteListener listener) {

        }

        @Override
        public void write(int b) {
        }
      });*/
      try (MockedStatic<org.ztv.anmeldetool.util.TeilnehmerExportImport> ms = Mockito.mockStatic(
          org.ztv.anmeldetool.util.TeilnehmerExportImport.class)) {
        controller.getMutationen(mock(HttpServletRequest.class), response, id);
        ms.verify(() -> org.ztv.anmeldetool.util.TeilnehmerExportImport.csvWriteToWriter(anyList(),
            eq(response)));
      }
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID id = UUID.randomUUID();
      when(teilnehmerAnlassLinkSrv.getMutationenForAnlass(id)).thenThrow(
          new ServiceException(TeilnehmerStartDTO.class, "boom"));
      HttpServletResponse response = mock(HttpServletResponse.class);
      assertThrows(ResponseStatusException.class,
          () -> controller.getMutationen(mock(HttpServletRequest.class), response, id));
    }
  }

  @Nested
  class TeilnehmerCsvTests {

    @Test
    void positive_writesCsv() throws Exception {
      UUID id = UUID.randomUUID();
      org.ztv.anmeldetool.models.TeilnehmerAnlassLink tal = new org.ztv.anmeldetool.models.TeilnehmerAnlassLink();
      Anlass anlass = new Anlass();
      anlass.setAnlassBezeichnung("Event");
      tal.setAnlass(anlass);
      when(teilnehmerAnlassLinkSrv.getAllTeilnehmerForAnlassAndUpdateStartnummern(id)).thenReturn(
          List.of(tal));
      when(talExImMapper.fromEntity(any())).thenReturn(
          new org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO());
      HttpServletResponse response = mock(HttpServletResponse.class);
      /*
      when(response.getOutputStream()).thenReturn(new ServletOutputStream() {
        @Override
        public boolean isReady() {
          return false;
        }

        @Override
        public void setWriteListener(WriteListener listener) {

        }

        @Override
        public void write(int b) {
        }
      });*/
      try (MockedStatic<org.ztv.anmeldetool.util.TeilnehmerExportImport> ms = Mockito.mockStatic(
          org.ztv.anmeldetool.util.TeilnehmerExportImport.class)) {
        controller.getTeilnehmer(mock(HttpServletRequest.class), response, id);
        ms.verify(() -> org.ztv.anmeldetool.util.TeilnehmerExportImport.csvWriteToWriter(anyList(),
            eq(response)));
      }
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID id = UUID.randomUUID();
      when(teilnehmerAnlassLinkSrv.getAllTeilnehmerForAnlassAndUpdateStartnummern(id)).thenThrow(
          new ServiceException(TeilnehmerStartDTO.class, "boom"));
      HttpServletResponse response = mock(HttpServletResponse.class);
      assertThrows(ResponseStatusException.class,
          () -> controller.getTeilnehmer(mock(HttpServletRequest.class), response, id));
    }
  }

  @Nested
  class UpdateTeilnehmerCsvTests {

    @Test
    void positive_parsesAndCallsService() throws Exception {
      UUID id = UUID.randomUUID();
      jakarta.servlet.http.Part p = null; // not used
      org.springframework.web.multipart.MultipartFile mf = mock(
          org.springframework.web.multipart.MultipartFile.class);
      when(mf.getOriginalFilename()).thenReturn("t.csv");
      when(mf.getSize()).thenReturn(10L);
      when(mf.getInputStream()).thenReturn(new ByteArrayInputStream("a,b,c".getBytes()));
      try (MockedStatic<TeilnehmerExportImport> ms = Mockito.mockStatic(
          TeilnehmerExportImport.class)) {
        ms.when(() -> TeilnehmerExportImport.csvWriteToWriter(any())).thenReturn(new ArrayList<>());
        controller.updateTeilnehmer(id, mf);
        verify(teilnehmerAnlassLinkSrv, times(1)).updateAnlassTeilnahmen(eq(id), anyList());
      }
    }

    @Test
    void negative_parseThrows_returnsOkStill() throws Exception {
      UUID id = UUID.randomUUID();
      org.springframework.web.multipart.MultipartFile mf = mock(
          org.springframework.web.multipart.MultipartFile.class);
      when(mf.getOriginalFilename()).thenReturn("t.csv");
      when(mf.getSize()).thenReturn(10L);
      when(mf.getInputStream()).thenThrow(new RuntimeException("io"));
      ResponseEntity resp = controller.updateTeilnehmer(id, mf);
      assertEquals(200, resp.getStatusCodeValue());
    }
  }

  @Nested
  class UpdateTeilnehmerFromContestTests {

    @Test
    void positive_parsesContestAndCallsService() throws Exception {
      UUID id = UUID.randomUUID();
      org.springframework.web.multipart.MultipartFile mf = mock(
          org.springframework.web.multipart.MultipartFile.class);
      when(mf.getOriginalFilename()).thenReturn("t.csv");
      when(mf.getSize()).thenReturn(10L);
      when(mf.getInputStream()).thenReturn(new ByteArrayInputStream("a,b,c".getBytes()));
      try (MockedStatic<TeilnehmerExportImport> ms = Mockito.mockStatic(
          TeilnehmerExportImport.class)) {
        ms.when(() -> TeilnehmerExportImport.csvContestWriteToWriter(any()))
            .thenReturn(new ArrayList<>());
        controller.updateTeilnehmerFromContest(id, mf);
        verify(stvContestService, times(1)).updateAnlassTeilnahmen(eq(id), anyList());
      }
    }
  }

  @Nested
  class VereinsStartsTests {

    @Test
    void positive_returnsList() throws Exception {
      UUID id = UUID.randomUUID();
      Organisation org = new Organisation();
      when(anlassSrv.getVereinsStarts(id)).thenReturn(List.of(org));
      when(organisationMapper.ToDto(org)).thenReturn(mock(OrganisationDTO.class));
      ResponseEntity<Collection<org.ztv.anmeldetool.transfer.OrganisationDTO>> resp = controller.getVereinsStarts(
          mock(HttpServletRequest.class), id);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_empty_returnsNotFound() throws Exception {
      UUID id = UUID.randomUUID();
      when(anlassSrv.getVereinsStarts(id)).thenReturn(Collections.emptyList());
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);
        ResponseEntity<Collection<org.ztv.anmeldetool.transfer.OrganisationDTO>> resp = controller.getVereinsStarts(
            mock(HttpServletRequest.class), id);
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class PatchAnlassVereineTests {

    @Test
    void positive_returnsDto() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      OrganisationAnlassLinkDTO dto = mock(OrganisationAnlassLinkDTO.class);
      OrganisationAnlassLink oal = mock(OrganisationAnlassLink.class);
      when(anlassSrv.updateTeilnehmendeVereine(anlassId, orgId, dto)).thenReturn(oal);
      when(oalMapper.toDto(oal)).thenReturn(dto);
      ResponseEntity<org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO> resp = controller.patchAnlassVereine(
          mock(HttpServletRequest.class), anlassId, orgId, dto);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_null_returnsNotFound() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      OrganisationAnlassLinkDTO dto = mock(OrganisationAnlassLinkDTO.class);
      when(anlassSrv.updateTeilnehmendeVereine(anlassId, orgId, dto)).thenReturn(null);
      ResponseEntity<org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO> resp = controller.patchAnlassVereine(
          mock(HttpServletRequest.class), anlassId, orgId, dto);
      assertEquals(404, resp.getStatusCodeValue());
    }
  }

  @Nested
  class GetTeilnehmerByOrgTests {

    @Test
    void positive_returnsList() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      TeilnehmerAnlassLink tal = mock(TeilnehmerAnlassLink.class);
      when(anlassSrv.getTeilnahmen(anlassId, orgId, false)).thenReturn(List.of(tal));
      when(teilnehmerAnlassMapper.toDto(tal)).thenReturn(mock(TeilnehmerAnlassLinkDTO.class));
      ResponseEntity<Collection<org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO>> resp = controller.getTeilnehmer(
          mock(HttpServletRequest.class), anlassId, orgId);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_empty_returnsNotFound() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSrv.getTeilnahmen(anlassId, orgId, false)).thenReturn(Collections.emptyList());
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);
        ResponseEntity<Collection<org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO>> resp = controller.getTeilnehmer(
            mock(HttpServletRequest.class), anlassId, orgId);
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class PutAnlassTeilnehmerTests {

    @Test
    void positive_updatesAndReturnsDto() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID teilnehmerId = UUID.randomUUID();
      TeilnehmerAnlassLinkDTO dto = mock(TeilnehmerAnlassLinkDTO.class);
      TeilnehmerAnlassLink tal = mock(TeilnehmerAnlassLink.class);
      when(teilnehmerSrv.updateAnlassTeilnahmen(anlassId, teilnehmerId, dto)).thenReturn(tal);
      when(teilnehmerAnlassMapper.toDto(tal)).thenReturn(dto);
      ResponseEntity<org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO> resp = controller.putAnlassTeilnehmer(
          mock(HttpServletRequest.class), anlassId, orgId, teilnehmerId, dto);
      assertEquals(200, resp.getStatusCodeValue());
    }
  }

  @Nested
  class AnmeldeKontrollePDFTests {

    @Test
    @Disabled("needs rewrite, see comment, test real logic")
    void positive_writesPdf() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      AnmeldeKontrolleDTO ak = mock(AnmeldeKontrolleDTO.class);
      // ak.setAnlass(mock(AnlassDTO.class));
      // ak.setOrganisator(mock(OrganisationDTO.class));
      when(anlassSrv.getAnmeldeKontrolle(anlassId, orgId)).thenReturn(ak);
      HttpServletResponse response = mock(HttpServletResponse.class);
      /*
      when(response.getOutputStream()).thenReturn(new ServletOutputStream() {
        @Override
        public boolean isReady() {
          return false;
        }

        @Override
        public void setWriteListener(WriteListener listener) {

        }

        @Override
        public void write(int b) {
        }
      });*/
      try (MockedStatic<AnmeldeKontrolleOutput> ms = Mockito.mockStatic(
          AnmeldeKontrolleOutput.class)) {
        controller.getAnmeldeKontrollePDF(mock(HttpServletRequest.class), response, anlassId,
            orgId);
        ms.verify(
            () -> AnmeldeKontrolleOutput.createAnmeldeKontrolle(eq(response.getOutputStream()),
                eq(ak)));
      }
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSrv.getAnmeldeKontrolle(anlassId, orgId)).thenThrow(new RuntimeException("boom"));
      HttpServletResponse response = mock(HttpServletResponse.class);
      assertThrows(ResponseStatusException.class,
          () -> controller.getAnmeldeKontrollePDF(mock(HttpServletRequest.class), response,
              anlassId, orgId));
    }
  }

  @Nested
  class WertungsrichterKontrollePDFTests {

    @Test
    @Disabled("needs rewrite, see comment, test real logic")
    void positive_writesPdf() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      AnmeldeKontrolleDTO ak = mock(AnmeldeKontrolleDTO.class);
      // ak.setAnlass(mock(AnlassDTO.class));
      // ak.setOrganisator(mock(OrganisationDTO.class));
      when(anlassSrv.getAnmeldeKontrolle(anlassId, orgId)).thenReturn(ak);
      when(anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_1)).thenReturn(List.of());
      HttpServletResponse response = mock(HttpServletResponse.class);
      /*
      when(response.getOutputStream()).thenReturn(new ServletOutputStream() {
        @Override
        public boolean isReady() {
          return false;
        }

        @Override
        public void setWriteListener(WriteListener listener) {

        }

        @Override
        public void write(int b) {
        }
      });*/
      try (MockedStatic<WertungsrichterOutput> ms = Mockito.mockStatic(
          WertungsrichterOutput.class)) {
        controller.getWertungsrichterKontrollePDF(mock(HttpServletRequest.class), response,
            anlassId, orgId);
        ms.verify(() -> WertungsrichterOutput.createWertungsrichter(eq(response.getOutputStream()),
            eq(ak), anyList(), anyList()));
      }
    }

    @Test
    void negative_serviceThrows_throwsResponseStatusException() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSrv.getAnmeldeKontrolle(anlassId, orgId)).thenThrow(new RuntimeException("boom"));
      HttpServletResponse response = mock(HttpServletResponse.class);
      assertThrows(ResponseStatusException.class,
          () -> controller.getWertungsrichterKontrollePDF(mock(HttpServletRequest.class), response,
              anlassId, orgId));
    }
  }

  @Nested
  class VerfuegbareEingeteilteWrtTests {

    @Test
    void verfuegbare_positive_returns200() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSrv.getVerfuegbareWertungsrichter(eq(anlassId), eq(orgId), any())).thenReturn(
          List.of(new org.ztv.anmeldetool.models.Person()));
      when(personMapper.PersonToPersonDTO(any())).thenReturn(mock(PersonDTO.class));
      ResponseEntity<Collection<org.ztv.anmeldetool.transfer.PersonDTO>> resp = controller.getVerfuegbareWertungsrichter(
          mock(HttpServletRequest.class), anlassId, orgId, 1);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void verfuegbare_negative_empty_returnsNotFound() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSrv.getVerfuegbareWertungsrichter(eq(anlassId), eq(orgId), any())).thenReturn(
          Collections.emptyList());
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);
        ResponseEntity<Collection<org.ztv.anmeldetool.transfer.PersonDTO>> resp = controller.getVerfuegbareWertungsrichter(
            mock(HttpServletRequest.class), anlassId, orgId, 1);
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class EingeteilteWertungsrichterTests {

    @Test
    void positive_returnsList() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSrv.getEingeteilteWertungsrichter(eq(anlassId), eq(orgId), any())).thenReturn(
          List.of(new PersonAnlassLink()));
      when(palMapper.toDto(any())).thenReturn(mock(PersonAnlassLinkDTO.class));
      ResponseEntity<Collection<org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO>> resp = controller.getEingeteilteWertungsrichter(
          mock(HttpServletRequest.class), anlassId, orgId, 1);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_empty_returnsNotFound() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSrv.getEingeteilteWertungsrichter(eq(anlassId), eq(orgId), any())).thenReturn(
          Collections.emptyList());
      try (MockedStatic<ServletUriComponentsBuilder> mocked = Mockito.mockStatic(
          ServletUriComponentsBuilder.class)) {
        ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
        UriComponents uriComp = mock(UriComponents.class);
        when(uriComp.toUri()).thenReturn(new URI("http://localhost/test"));
        when(builderMock.build()).thenReturn(uriComp);
        mocked.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);
        ResponseEntity<Collection<org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO>> resp = controller.getEingeteilteWertungsrichter(
            mock(HttpServletRequest.class), anlassId, orgId, 1);
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }

  @Nested
  class EinsaetzeTests {

    @Test
    void positive_createsEinsaetzeAndReturnsDto() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();
      PersonAnlassLink pal = mock(PersonAnlassLink.class);
      Anlass anlass = mock(Anlass.class);
      // set up anlass with empty einsaetze but with slots
      when(pal.getAnlass()).thenReturn(anlass);
      when(anlass.getHoechsteKategorie()).thenReturn(KategorieEnum.K1);

      when(anlass.getWertungsrichterSlots()).thenReturn(List.of(mock(WertungsrichterSlot.class)));
      when(pal.getEinsaetze()).thenReturn(new ArrayList<>());
      when(anlassSrv.getAnlassLink(anlassId, orgId, personId)).thenReturn(pal);
      when(wertungsrichterEinsatzSrv.update(any())).thenAnswer(i -> i.getArgument(0));
      // pal has no einsaetze, and anlass may have slots; to keep test simple return pal as-is
      when(palMapper.toDto(any())).thenReturn(mock(PersonAnlassLinkDTO.class));
      ResponseEntity<PersonAnlassLinkDTO> resp = controller.getEinsatze(
          mock(HttpServletRequest.class), anlassId, orgId, personId);
      // either 200 or 400 depending on flow; ensure not null and status code is 200
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_serviceThrows_returnsBadRequest() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();
      when(anlassSrv.getAnlassLink(anlassId, orgId, personId)).thenThrow(
          new RuntimeException("boom"));
      ResponseEntity<org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO> resp = controller.getEinsatze(
          mock(HttpServletRequest.class), anlassId, orgId, personId);
      assertEquals(400, resp.getStatusCodeValue());
    }
  }

  @Nested
  class PostEingeteilteWertungsrichterTests {

    @Test
    void whenPalExists_updatesAndReturnsDto() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();
      PersonAnlassLink pal = new PersonAnlassLink();
      when(anlassSrv.getAnlassLink(anlassId, orgId, personId)).thenReturn(pal);
      when(personAnlassLinkRepository.save(pal)).thenReturn(pal);
      when(palMapper.toDto(pal)).thenReturn(mock(PersonAnlassLinkDTO.class));
      PersonAnlassLinkDTO in = mock(PersonAnlassLinkDTO.class);
      ResponseEntity<org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO> resp = controller.postEingeteilteWertungsrichter(
          mock(HttpServletRequest.class), anlassId, orgId, personId, in);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    @Disabled("needs rewrite, see comment, test real logic")
    void whenPalNull_callsService() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();
      PersonAnlassLinkDTO in = mock(PersonAnlassLinkDTO.class);
      when(anlassSrv.getAnlassLink(anlassId, orgId, personId)).thenReturn(null);
      when(anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "",
          true)).thenReturn(
          ResponseEntity.ok(in));
      ResponseEntity<org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO> resp = controller.postEingeteilteWertungsrichter(
          mock(HttpServletRequest.class), anlassId, orgId, personId, in);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_throwsBadRequest() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();
      when(anlassSrv.getAnlassLink(anlassId, orgId, personId)).thenThrow(
          new RuntimeException("boom"));
      assertEquals(400,
          controller.postEingeteilteWertungsrichter(mock(HttpServletRequest.class), anlassId, orgId,
                  personId, mock(PersonAnlassLinkDTO.class))
              .getStatusCodeValue());
    }
  }

  @Nested
  class DeleteEingeteilteWertungsrichterTests {

    @Test
    void positive_callsService() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();
      when(anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "",
          false)).thenReturn(
          ResponseEntity.ok(mock(PersonAnlassLinkDTO.class)));
      ResponseEntity<org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO> resp = controller.deleteEingeteilteWertungsrichter(
          mock(HttpServletRequest.class), anlassId, orgId, personId);
      assertEquals(200, resp.getStatusCodeValue());
    }

    @Test
    void negative_returnsBadRequest() throws Exception {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      UUID personId = UUID.randomUUID();
      when(anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "",
          false)).thenThrow(new RuntimeException("boom"));
      assertEquals(400,
          controller.deleteEingeteilteWertungsrichter(mock(HttpServletRequest.class), anlassId,
              orgId, personId).getStatusCodeValue());
    }
  }

  @Nested
  class PostWertungsrichterEinsatzTests {

    @Test
    void positive_mapsUpdatesAndReturnsDto() {
      WertungsrichterEinsatzDTO dto = mock(WertungsrichterEinsatzDTO.class);
      WertungsrichterEinsatz entity = new WertungsrichterEinsatz();
      when(wertungsrichterEinsatzMapper.ToEntity(dto)).thenReturn(entity);
      when(wertungsrichterEinsatzSrv.update(entity)).thenReturn(entity);
      when(wertungsrichterEinsatzMapper.ToDto(entity)).thenReturn(dto);
      ResponseEntity<WertungsrichterEinsatzDTO> resp = controller.postWertungsrichterEinsatz(
          mock(HttpServletRequest.class), UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(),
          dto);
      assertEquals(200, resp.getStatusCodeValue());
    }
  }

  @Nested
  class ExceptionHandlerTests {

    @Test
    void entityNotFound_returns404AndMessage() {
      EntityNotFoundException ex = new EntityNotFoundException(WertungsrichterEinsatz.class,
          UUID.randomUUID());
      ResponseEntity<?> resp = controller.handlerEntityNotFound(ex);
      assertEquals(404, resp.getStatusCodeValue());
      assertTrue(resp.getBody().toString().contains("not found"));
    }

    @Test
    void genericException_returns400() {
      Exception ex = new Exception("bad");
      ResponseEntity<?> resp = controller.handlerException(ex);
      assertEquals(400, resp.getStatusCodeValue());
      assertTrue(resp.getBody().toString().contains("bad"));
    }
  }

  @Nested
  class GetAnlassOrganisationSummaryTests {

    @Test
    void positive_returnsSummary() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      AnlassSummaryDTO dto = mock(AnlassSummaryDTO.class);
      when(anlassSummaryService.getAnlassSummary(anlassId, orgId)).thenReturn(dto);
      ResponseEntity<AnlassSummaryDTO> resp = controller.getAnlassOrganisationSummary(
          mock(HttpServletRequest.class), anlassId, orgId);
      assertEquals(200, resp.getStatusCodeValue());
      assertNotNull(resp.getBody());
    }

    @Test
    void negative_serviceThrows_propagatesException() {
      UUID anlassId = UUID.randomUUID();
      UUID orgId = UUID.randomUUID();
      when(anlassSummaryService.getAnlassSummary(anlassId, orgId)).thenThrow(
          new RuntimeException("boom"));
      assertThrows(RuntimeException.class,
          () -> controller.getAnlassOrganisationSummary(mock(HttpServletRequest.class), anlassId,
              orgId));
    }
  }

}
