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
import org.ztv.anmeldetool.exception.NotFoundException;
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
import org.ztv.anmeldetool.output.AnmeldeKontrolleExport;
import org.ztv.anmeldetool.output.AnmeldeKontrolleOutput;
import org.ztv.anmeldetool.output.BenutzerExport;
import org.ztv.anmeldetool.output.TeilnehmerExportImport;
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

// ...existing code...

@ExtendWith(MockitoExtension.class)
@Disabled
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

      ResponseEntity<List<AnlassDTO>> resp = controller.getAnlaesse(true);
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

        ResponseEntity<List<AnlassDTO>> resp = controller.getAnlaesse(true);
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
           UUID.randomUUID());
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
             UUID.randomUUID());
        assertEquals(404, resp.getStatusCodeValue());
      }
    }
  }
}
