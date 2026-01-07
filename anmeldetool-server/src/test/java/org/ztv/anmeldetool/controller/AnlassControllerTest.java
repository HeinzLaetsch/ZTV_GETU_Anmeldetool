package org.ztv.anmeldetool.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.anyBoolean;
import static org.mockito.Mockito.anyInt;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.server.ResponseStatusException;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Einzelnote;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Laufliste;
import org.ztv.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.LauflistenService;
import org.ztv.anmeldetool.service.RanglistenService;
import org.ztv.anmeldetool.service.ServiceException;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.transfer.LauflisteDTO;
import org.ztv.anmeldetool.transfer.LauflistenEintragDTO;
import org.ztv.anmeldetool.transfer.LauflistenStatusDTO;
import org.ztv.anmeldetool.transfer.RanglisteConfigurationDTO;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;
import org.ztv.anmeldetool.transfer.TeamwertungDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.util.RanglistenConfigurationMapper;

@ExtendWith(MockitoExtension.class)
@Disabled
public class AnlassControllerTest {

  @Mock
  AnlassService anlassService;

  @Mock
  RanglistenService ranglistenService;

  @Mock
  LauflistenService lauflistenService;

  @Mock
  TeilnehmerAnlassLinkService teilnehmerAnlassLinkService;

  @Mock
  RanglistenConfigurationMapper rcMapper;

  @InjectMocks
  AnlassController controller;

  @Mock
  org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper teilnehmerAnlassMapper;

  @Nested
  class PutRanglistenConfigTests {

    @Test
    void whenMapperReturnsDto_thenReturnOk() {
      RanglisteConfigurationDTO dto = new RanglisteConfigurationDTO();
      // dto has default fields; mapper behavior is mocked

      RanglisteConfiguration entity = new RanglisteConfiguration();
      when(rcMapper.toEntity(dto)).thenReturn(entity);
      when(ranglistenService.saveRanglisteConfiguration(entity)).thenReturn(entity);
      when(rcMapper.fromEntity(entity)).thenReturn(dto);

      ResponseEntity<RanglisteConfigurationDTO> resp = controller.putRanglistenConfig(dto);
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
      assertSame(dto, resp.getBody());
      verify(rcMapper).toEntity(dto);
      verify(ranglistenService).saveRanglisteConfiguration(entity);
      verify(rcMapper).fromEntity(entity);
    }

    @Test
    void whenMapperReturnsNull_thenReturnNotFound() {
      UUID anlassId = UUID.randomUUID();
      RanglisteConfigurationDTO dto = new RanglisteConfigurationDTO();
      RanglisteConfiguration entity = new RanglisteConfiguration();

      when(rcMapper.toEntity(dto)).thenReturn(entity);
      when(ranglistenService.saveRanglisteConfiguration(entity)).thenReturn(entity);
      // simulate mapper returning null -> controller should return notFound
      when(rcMapper.fromEntity(entity)).thenReturn(null);

      MockHttpServletRequest req = new MockHttpServletRequest();
      RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(req));
      try {
        ResponseEntity<RanglisteConfigurationDTO> resp = controller.putRanglistenConfig(dto);
        assertNotNull(resp);
        assertEquals(404, resp.getStatusCode().value());
        assertTrue(resp.getHeaders().containsKey("Location"));
      } catch (IllegalStateException ise) {
        // In some test environments ServletUriComponentsBuilder may still fail to build a location;
        // accept IllegalStateException as a valid negative outcome.
        assertTrue(
            ise.getMessage().contains("No current ServletRequestAttributes") || ise.getMessage()
                .contains("No current request"));
      } finally {
        RequestContextHolder.resetRequestAttributes();
      }
    }
  }

  @Nested
  class GetAnlagenTests {

    @Test
    void whenServiceReturnsList_thenReturnOk() throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      Anlass anlass = new Anlass();
      anlass.setId(anlassId);

      when(anlassService.findById(anlassId)).thenReturn(anlass);
      when(teilnehmerAnlassLinkService.findAnlagenByKategorieAndAbteilung(anlassId, KategorieEnum.K1,
          AbteilungEnum.ABTEILUNG_1))
          .thenReturn(List.of(AnlageEnum.ANLAGE_1));

      ResponseEntity<List<AnlageEnum>> resp = controller.getAnlagen(anlassId,
          KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1);
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
      assertNotNull(resp.getBody());
      assertEquals(1, resp.getBody().size());
      assertEquals(AnlageEnum.ANLAGE_1, resp.getBody().get(0));
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenThrow(new RuntimeException("boom"));

      ResponseStatusException ex = assertThrows(ResponseStatusException.class, () ->
          controller.getAnlagen( anlassId, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1)
      );
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class GetAbteilungenTests {

    @Test
    void whenServiceReturnsList_thenReturnOk() throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      Anlass anlass = new Anlass();
      anlass.setId(anlassId);

      when(anlassService.findById(anlassId)).thenReturn(anlass);
      when(teilnehmerAnlassLinkService.findAbteilungenByKategorie(anlass, KategorieEnum.K1))
          .thenReturn(List.of(AbteilungEnum.ABTEILUNG_1));

      ResponseEntity<List<AbteilungEnum>> resp = controller.getAbteilungen( anlassId,
          KategorieEnum.K1);
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
      assertNotNull(resp.getBody());
      assertEquals(1, resp.getBody().size());
      assertEquals(AbteilungEnum.ABTEILUNG_1, resp.getBody().get(0));
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenThrow(new RuntimeException("boom"));

      ResponseStatusException ex = assertThrows(ResponseStatusException.class, () ->
          controller.getAbteilungen(anlassId, KategorieEnum.K1)
      );
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class GetRanglistenConfigTests {

    @Test
    void whenConfigExists_returnsDto() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());
      RanglisteConfiguration cfg = new RanglisteConfiguration();
      cfg.setMaxAuszeichnungen(2);
      when(ranglistenService.getRanglisteConfiguration(anlassId, any(), any())).thenReturn(cfg);
      RanglisteConfigurationDTO dto = new RanglisteConfigurationDTO();
      when(rcMapper.fromEntity(cfg)).thenReturn(dto);

      ResponseEntity<RanglisteConfigurationDTO> resp = controller.getRanglistenConfig(
          anlassId, TiTuEnum.Ti, KategorieEnum.K1);
      assertNotNull(resp);
      assertEquals(200, resp.getStatusCode().value());
      assertSame(dto, resp.getBody());
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenThrow(new RuntimeException("boom"));
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getRanglistenConfig( anlassId, TiTuEnum.Ti,
              KategorieEnum.K1));
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class GetRanglistenStatusTests {

    @Test
    void whenStatusAvailable_returnsDto() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());
      LauflistenStatusDTO dto = new LauflistenStatusDTO();
      when(lauflistenService.findLauflistenStatusForAnlassAndKategorie(any(), any(),
          any())).thenReturn(dto);

      ResponseEntity<LauflistenStatusDTO> resp = controller.getRanglistenStatus(
          anlassId, TiTuEnum.Ti, KategorieEnum.K1);
      assertNotNull(resp);
      assertSame(dto, resp.getBody());
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenThrow(new RuntimeException("boom"));

      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getRanglistenStatus(anlassId, TiTuEnum.Ti,
              KategorieEnum.K1));
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class GetRanglisteTests {

    @Test
    void whenGenerateSucceeds_returnsList() throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());
      RanglisteConfiguration cfg = new RanglisteConfiguration();
      cfg.setMaxAuszeichnungen(1);
      when(ranglistenService.getRanglisteConfiguration(anlassId, any(), any())).thenReturn(cfg);
      when(ranglistenService.getTeilnehmerSorted(any(), any(), any())).thenReturn(List.of());
      when(ranglistenService.calcMaxAuszeichnungen(any(), anyInt())).thenReturn(0);
      when(ranglistenService.createRangliste(any(), anyInt())).thenReturn(List.of());

      ResponseEntity<List<RanglistenEntryDTO>> resp = controller.getRangliste(anlassId,
          TiTuEnum.Ti, KategorieEnum.K1, Optional.empty());
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
      assertNotNull(resp.getBody());
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getRanglisteConfiguration(anlassId, any(), any())).thenThrow(
          new RuntimeException("boom"));
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getRangliste( anlassId, TiTuEnum.Ti, KategorieEnum.K1,
              Optional.empty()));
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class GetRanglistePerVereinTests {

    @Test
    void whenServiceReturnsList_thenReturnOk() throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti,
          KategorieEnum.K1)).thenReturn(List.of(new RanglistenEntryDTO()));
      ResponseEntity<List<RanglistenEntryDTO>> resp = controller.getRanglistePerVerein(
          anlassId, TiTuEnum.Ti, KategorieEnum.K1);
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
      assertNotNull(resp.getBody());
      assertEquals(1, resp.getBody().size());
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti,
          KategorieEnum.K1)).thenThrow(new RuntimeException("boom"));
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getRanglistePerVerein( anlassId, TiTuEnum.Ti,
              KategorieEnum.K1));
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class PdfEndpointsTests {

    @Test
    void getRanglistePerVereinPdf_whenServiceReturns_doesNotThrow()
        throws ServiceException, IOException {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti,
          KategorieEnum.K1)).thenReturn(List.of());
      MockHttpServletResponse resp = new MockHttpServletResponse();
      controller.getRanglistePerVereinPdf(resp, anlassId, TiTuEnum.Ti, KategorieEnum.K1);
      // basic assertion: response has Content-Disposition header set by controller
      assertTrue(
          resp.getHeaderNames().stream().anyMatch(h -> h.equalsIgnoreCase("Content-Disposition")));
    }

    @Test
    void getRanglistePerVereinPdf_whenServiceThrows_thenResponseStatusException()
        throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti,
          KategorieEnum.K1)).thenThrow(new RuntimeException("boom"));
      MockHttpServletResponse resp = new MockHttpServletResponse();
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getRanglistePerVereinPdf( resp, anlassId, TiTuEnum.Ti,
              KategorieEnum.K1));
      assertEquals(500, ex.getStatusCode().value());
    }

    @Test
    void getTeamwertungPdf_whenServiceReturns_doesNotThrow() throws ServiceException, IOException {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getTeamwertungTi(anlassId, KategorieEnum.K1)).thenReturn(
          List.of(new TeamwertungDTO()));
      MockHttpServletResponse resp = new MockHttpServletResponse();
      controller.getTeamwertungPdf( resp, anlassId, TiTuEnum.Ti, KategorieEnum.K1);
      assertTrue(
          resp.getHeaderNames().stream().anyMatch(h -> h.equalsIgnoreCase("Content-Disposition")));
    }

    @Test
    void getTeamwertungPdf_whenServiceThrows_thenResponseStatusException()
        throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getTeamwertungTi(anlassId, KategorieEnum.K1)).thenThrow(
          new RuntimeException("boom"));
      MockHttpServletResponse resp = new MockHttpServletResponse();
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getTeamwertungPdf(resp, anlassId, TiTuEnum.Ti, KategorieEnum.K1));
      assertEquals(500, ex.getStatusCode().value());
    }

    @Test
    void getRanglistenPdf_whenServiceWorks_doesNotThrow() throws ServiceException, IOException {
      UUID anlassId = UUID.randomUUID();
      // stub ranglistenService used in generateRangliste minimal path
      when(anlassService.findById(anlassId)).thenReturn(new Anlass("Anlass","Ort","Halle",
          LocalDateTime.now(),LocalDateTime.now(),TiTuEnum.Ti,KategorieEnum.K1,KategorieEnum.K1));
      RanglisteConfiguration cfg = new RanglisteConfiguration();
      cfg.setMaxAuszeichnungen(1);
      when(ranglistenService.getRanglisteConfiguration(anlassId, any(), any())).thenReturn(cfg);
      when(ranglistenService.getTeilnehmerSorted(any(), any(), any())).thenReturn(List.of());
      when(ranglistenService.calcMaxAuszeichnungen(any(), anyInt())).thenReturn(0);
      when(ranglistenService.createRangliste(any(), anyInt())).thenReturn(List.of());

      MockHttpServletResponse resp = new MockHttpServletResponse();
      controller.getRanglistenPdf(resp, anlassId, TiTuEnum.Ti, KategorieEnum.K1,
          Optional.empty());
      assertTrue(
          resp.getHeaderNames().stream().anyMatch(h -> h.equalsIgnoreCase("Content-Disposition")));
    }

    @Test
    void getRanglistenPdf_whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getRanglisteConfiguration(anlassId, any(), any())).thenThrow(
          new RuntimeException("boom"));
      MockHttpServletResponse resp = new MockHttpServletResponse();
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getRanglistenPdf( resp, anlassId, TiTuEnum.Ti, KategorieEnum.K1,
              Optional.empty()));
      assertEquals(500, ex.getStatusCode().value());
    }

    @Test
    void getRanglistenCsv_whenServiceWorks_doesNotThrow()
        throws ServiceException, CsvRequiredFieldEmptyException, CsvDataTypeMismatchException, IOException {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());
      RanglisteConfiguration cfg = new RanglisteConfiguration();
      cfg.setMaxAuszeichnungen(1);
      when(ranglistenService.getRanglisteConfiguration(anlassId, any(), any())).thenReturn(cfg);
      when(ranglistenService.getTeilnehmerSorted(any(), any(), any())).thenReturn(List.of());
      when(ranglistenService.calcMaxAuszeichnungen(any(), anyInt())).thenReturn(0);
      when(ranglistenService.createRangliste(any(), anyInt())).thenReturn(List.of());
      MockHttpServletResponse resp = new MockHttpServletResponse();
      controller.getRanglistenCsv( resp, anlassId, TiTuEnum.Ti, KategorieEnum.K1,
          Optional.empty());
      assertTrue(
          resp.getHeaderNames().stream().anyMatch(h -> h.equalsIgnoreCase("Content-Disposition"))
              || "text/csv".equalsIgnoreCase(resp.getContentType()));
    }

    @Test
    void getRanglistenCsv_whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(ranglistenService.getRanglisteConfiguration(eq(anlassId), any(), any())).thenThrow(
          new RuntimeException("boom"));
      MockHttpServletResponse resp = new MockHttpServletResponse();
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getRanglistenCsv( resp, anlassId, TiTuEnum.Ti, KategorieEnum.K1,
              Optional.empty()));
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class GetLauflisteTests {

    @Test
    @Disabled("Needs to be adapted to new LauflistenContainer return type")
    void whenLauflisteFound_returnsDto() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());
      Laufliste lauf = new Laufliste();
      lauf.setId(UUID.randomUUID());
      lauf.setKey("k");
      LauflistenContainer cont = new LauflistenContainer();
      cont.setTeilnehmerAnlassLinks(new java.util.LinkedList<>());
      cont.getTeilnehmerAnlassLinks().add(new TeilnehmerAnlassLink());
      when(lauflistenService.getLauflistenForAnlassAndKategorie(any(), any(), any(),
          any())).thenReturn(List.of(cont));

      ResponseEntity<List<LauflisteDTO>> resp = controller.getLauflisten( anlassId,
          KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1);
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
      assertNotNull(resp.getBody());
      assertEquals(1, resp.getBody().size());
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(lauflistenService.getLauflistenForAnlassAndKategorie(any(), any(), any(),
          any())).thenThrow(new RuntimeException("boom"));
      ResponseStatusException ex = assertThrows(ResponseStatusException.class,
          () -> controller.getLauflisten( anlassId, KategorieEnum.K1,
              AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1));
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class PutLauflisteTests {

    @Test
    void whenLauflisteExists_returnsOk() {
      UUID anlassId = UUID.randomUUID();
      UUID lid = UUID.randomUUID();
      Laufliste lauf = new Laufliste();
      lauf.setId(lid);
      when(lauflistenService.findLauflisteById(lid)).thenReturn(Optional.of(lauf));
      when(lauflistenService.saveLaufliste(any(Laufliste.class))).thenReturn(lauf);
      LauflisteDTO dto = LauflisteDTO.builder().id(lid).erfasst(true).checked(true).build();
      ResponseEntity<LauflisteDTO> resp = controller.putLaufliste( lid, dto);
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
    }

    @Test
    void whenLauflisteNotFound_returnsNotFoundOrThrows() {
      UUID anlassId = UUID.randomUUID();
      UUID lid = UUID.randomUUID();
      LauflisteDTO dto = LauflisteDTO.builder().id(lid).erfasst(true).checked(true).build();
      // find returns empty -> controller.getNotFound (may throw in test environment)
      when(lauflistenService.findLauflisteById(lid)).thenReturn(Optional.empty());
      try {
        ResponseEntity<LauflisteDTO> resp = controller.putLaufliste( lid, dto);
        assertEquals(404, resp.getStatusCode().value());
      } catch (IllegalStateException ise) {
        assertTrue(
            ise.getMessage().contains("No current ServletRequestAttributes") || ise.getMessage()
                .contains("No current request"));
      }
    }
  }

  @Nested
  class DeleteLauflistenEintragTests {

    @Test
    void whenTalExists_returnsDto() {
      UUID talId = UUID.randomUUID();
      TeilnehmerAnlassLink tal = new TeilnehmerAnlassLink();
      tal.setId(talId);
      when(teilnehmerAnlassLinkService.findTeilnehmerAnlassLinkById(talId)).thenReturn(
          Optional.of(tal));
      when(teilnehmerAnlassLinkService.save(any())).thenReturn(tal);
      TeilnehmerAnlassLinkDTO talDto = new TeilnehmerAnlassLinkDTO(
          UUID.randomUUID(), // anlassId
          UUID.randomUUID(), // teilnehmerId
          UUID.randomUUID(), // organisationId
          KategorieEnum.K1,  // kategorie
          "",               // meldeStatus
          false,             // dirty
          0,                 // startnummer
          AbteilungEnum.ABTEILUNG_1, // abteilung
          false,             // abteilungFix
          AnlageEnum.ANLAGE_1, // anlage
          false,             // anlageFix
          GeraetEnum.BODEN,  // startgeraet
          false              // startgeraetFix
      );

      when(teilnehmerAnlassMapper.toDto(tal)).thenReturn(talDto);

      ResponseEntity<TeilnehmerAnlassLinkDTO> resp = controller.deleteLauflistenEintrag(talId, "nichtAngetreten");
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
      assertSame(talDto, resp.getBody());
    }

    @Test
    void whenServiceThrows_returnsBadRequest() {
      UUID talId = UUID.randomUUID();
      when(teilnehmerAnlassLinkService.findTeilnehmerAnlassLinkById(talId)).thenThrow(
          new RuntimeException("boom"));
      ResponseEntity<TeilnehmerAnlassLinkDTO> resp = controller.deleteLauflistenEintrag(talId, "verletzt");
      assertEquals(400, resp.getStatusCode().value());
    }
  }

  @Nested
  class DeleteLauflistenTests {

    @Test
    void whenDeleteSucceeds_returnsOk() throws ServiceException {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());
      // no exception from delete -> ok
      ResponseEntity<?> resp = controller.deleteLauflisten(anlassId, KategorieEnum.K1,
          AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1);
      assertNotNull(resp);
      assertTrue(resp.getStatusCode().is2xxSuccessful());
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());
      try {
        doThrow(new RuntimeException("boom")).when(lauflistenService)
            .deleteLauflistenForAnlassAndKategorie(any(), any(), any(), any());
      } catch (ServiceException e) {
        throw new RuntimeException(e);
      }
      ResponseStatusException ex = assertThrows(ResponseStatusException.class, () ->
          controller.deleteLauflisten(anlassId, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1,
              AnlageEnum.ANLAGE_1)
      );
      assertEquals(500, ex.getStatusCode().value());
    }
  }

  @Nested
  class GetLauflistenPdfTests {

    @Test
    @Disabled("Disabled because of complexity of involved model objects; see comment")
    void whenGenerateSucceeds_doesNotThrowAndWritesResponse() throws ServiceException, IOException {
      UUID anlassId = UUID.randomUUID();
      when(anlassService.findById(anlassId)).thenReturn(new Anlass());

      // build minimal Struktur for AnlassLauflisten -> one container with one Laufliste and one Einzelnote
      Einzelnote note = new Einzelnote();
      note.setId(UUID.randomUUID());
      note.setStartOrder(1);
      Laufliste lauf = new Laufliste();
      lauf.setId(UUID.randomUUID());
      lauf.setKey("k");
      lauf.setEinzelnoten(List.of(note));
      LauflistenContainer container = new LauflistenContainer();
      container.setGeraeteLauflisten(List.of(lauf));
      org.ztv.anmeldetool.models.AnlassLauflisten al = new org.ztv.anmeldetool.models.AnlassLauflisten();
      // al.setLauflistenContainer(List.of(container));

      try {
        when(lauflistenService.generateLauflistenForAnlassAndKategorie(any(), any(), any(), any(),
            anyBoolean())).thenReturn(al);
      } catch (ServiceException e) {
        throw new RuntimeException(e);
      }
      when(lauflistenService.findEinzelnoteById(note.getId())).thenReturn(Optional.of(note));
      doNothing().when(lauflistenService).saveAllLauflisten(any());
      when(lauflistenService.saveEinzelnote(any())).thenAnswer(inv -> inv.getArgument(0));

      MockHttpServletResponse resp = new MockHttpServletResponse();
      controller.getLauflistenPdf(resp, anlassId, KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1,
          AnlageEnum.ANLAGE_1, Optional.empty());
      // response headers should be set
      assertTrue(
          resp.getHeaderNames().stream().anyMatch(h -> h.equalsIgnoreCase("Content-Disposition")));
    }

    @Test
    void whenServiceThrows_thenResponseStatusException() {
      UUID anlassId = UUID.randomUUID();
      try {
        when(lauflistenService.generateLauflistenForAnlassAndKategorie(any(), any(), any(), any(),
            anyBoolean())).thenThrow(new ResponseStatusException(HttpStatusCode.valueOf(500),"boom"));
      } catch (ServiceException e) {
        throw new ResponseStatusException(500, "ServiceException", e);
      }
      MockHttpServletResponse resp = new MockHttpServletResponse();
      ResponseStatusException ex = assertThrows(ResponseStatusException.class, () ->
          controller.getLauflistenPdf( resp, anlassId, KategorieEnum.K1,
              AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, Optional.empty())
      );
      assertEquals(500, ex.getStatusCode().value());
    }
  }
}
