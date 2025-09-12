package org.ztv.anmeldetool.controller;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.output.LauflistenOutput;
import org.ztv.anmeldetool.output.RanglistenOutput;
import org.ztv.anmeldetool.service.LauflistenService;
import org.ztv.anmeldetool.service.RanglistenService;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.transfer.LauflisteDTO;
import org.ztv.anmeldetool.transfer.LauflistenEintragDTO;
import org.ztv.anmeldetool.transfer.LauflistenStatusDTO;
import org.ztv.anmeldetool.transfer.RanglisteConfigurationDTO;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;
import org.ztv.anmeldetool.transfer.TeamwertungDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;

@RestController
@RequestMapping("/anlaesse")
@Slf4j
@RequiredArgsConstructor
public class AnlassController {

  private final LauflistenService lauflistenService;
  private final RanglistenService ranglistenService;
  private final TeilnehmerAnlassLinkService teilnehmerAnlassLinkService;
  private final RanglistenOutput ranglistenOutput;
  private final LauflistenOutput lauflistenOutput;

  @PutMapping("/{anlassId}/ranglisten/{tiTu}/{kategorie}/config")
  public ResponseEntity<RanglisteConfigurationDTO> putRanglistenConfig(
      @RequestBody RanglisteConfigurationDTO dto) {
    return ResponseEntity.ok(ranglistenService.saveRanglisteConfiguration(dto));
  }

  @GetMapping("/{anlassId}/ranglisten/{tiTu}/{kategorie}/config")
  public ResponseEntity<RanglisteConfigurationDTO> getRanglistenConfig(@PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie) {
    return ResponseEntity.ok(ranglistenService.getRanglisteConfigurationDto(anlassId, kategorie, tiTu));
  }

  @GetMapping("/{anlassId}/ranglisten/{tiTu}/{kategorie}/state")
  public ResponseEntity<LauflistenStatusDTO> getRanglistenStatus(@PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie) {
    return ResponseEntity.ok(
        lauflistenService.findLauflistenStatusForAnlassAndKategorie(anlassId, kategorie, tiTu));
  }

  @GetMapping("/{anlassId}/ranglisten/{tiTu}/{kategorie}")
  public ResponseEntity<List<RanglistenEntryDTO>> getRangliste(@PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie,
      @RequestParam Optional<Integer> maxAuszeichnungen) {
    List<RanglistenEntryDTO> rangliste = ranglistenService.generateRangliste(anlassId, tiTu, kategorie,
        maxAuszeichnungen);
    return ResponseEntity.ok(rangliste);
  }

  @GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}", produces = "application/pdf")
  public void getRanglistenPdf(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie,
      @RequestParam Optional<Integer> maxAuszeichnungen) throws IOException {

    List<RanglistenEntryDTO> ranglistenDTOs = ranglistenService.generateRangliste(anlassId, tiTu,
        kategorie, maxAuszeichnungen);

    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Rangliste-" + kategorie + "-" + tiTu + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

    ranglistenOutput.createRangliste(response.getOutputStream(), anlassId, ranglistenDTOs, tiTu,
        kategorie);
  }

  @GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}", produces = "text/csv;charset=UTF-8")
  public void getRanglistenCsv(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie,
      @RequestParam Optional<Integer> maxAuszeichnungen) throws IOException {

    List<RanglistenEntryDTO> ranglistenDTOs = ranglistenService.generateRangliste(anlassId, tiTu,
        kategorie, maxAuszeichnungen);

    String reportName = "Rangliste_" + kategorie.name() + "_" + tiTu.name();
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

    ranglistenOutput.csvWriteToWriter(response.getWriter(), ranglistenDTOs, tiTu, kategorie);
  }

  @GetMapping("/{anlassId}/ranglisten/{tiTu}/{kategorie}/vereine")
  public ResponseEntity<List<RanglistenEntryDTO>> getRanglistePerVerein(@PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie) {
    return ResponseEntity.ok(
        ranglistenService.getRanglistenPerVereinDtos(anlassId, tiTu, kategorie));
  }

  @GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}/vereine", produces = "application/pdf")
  public void getRanglistePerVereinPdf(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie) throws IOException {

    List<RanglistenEntryDTO> ranglistenDTOs = ranglistenService.getRanglistenPerVereinDtos(anlassId,
        tiTu, kategorie);

    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Ranglisten-Per-Verein-" + kategorie + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

    ranglistenOutput.createRanglistePerVerein(response.getOutputStream(), ranglistenDTOs, kategorie);
  }

  @GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}/teamwertung", produces = "application/pdf")
  public void getTeamwertungPdf(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie) throws IOException {

    List<TeamwertungDTO> twList = ranglistenService.getTeamwertung(anlassId, tiTu, kategorie);

    String reportName = ranglistenService.getTeamwertungReportName(kategorie, tiTu);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + reportName + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

    ranglistenOutput.createTeamwertung(response.getOutputStream(), twList, kategorie, tiTu);
  }

  @DeleteMapping("/{anlassId}/lauflisten/{kategorie}/{abteilung}/{anlage}")
  public ResponseEntity<Void> deleteLauflisten(@PathVariable UUID anlassId,
      @PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung,
      @PathVariable AnlageEnum anlage) {
    lauflistenService.deleteLauflistenForAnlassAndKategorie(anlassId, kategorie, abteilung, anlage);
    return ResponseEntity.noContent().build();
  }

  @GetMapping("/{anlassId}/lauflisten")
  public ResponseEntity<LauflisteDTO> getLaufliste(@PathVariable UUID anlassId,
      @RequestParam String search) {
    return ResponseEntity.ok(lauflistenService.findLauflisteDtoByAnlassAndSearch(anlassId, search));
  }

  @GetMapping("/{anlassId}/lauflisten/{kategorie}")
  public ResponseEntity<List<AbteilungEnum>> getAbteilungen(@PathVariable UUID anlassId,
      @PathVariable KategorieEnum kategorie) {
    return ResponseEntity.ok(
        teilnehmerAnlassLinkService.findAbteilungenByKategorie(anlassId, kategorie));
  }

  @GetMapping("/{anlassId}/lauflisten/{kategorie}/{abteilung}")
  public ResponseEntity<List<AnlageEnum>> getAnlagen(@PathVariable UUID anlassId,
      @PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung) {
    return ResponseEntity.ok(
        teilnehmerAnlassLinkService.findAnlagenByKategorieAndAbteilung(anlassId, kategorie,
            abteilung));
  }

  @GetMapping("/{anlassId}/lauflisten/{kategorie}/{abteilung}/{anlage}")
  public ResponseEntity<List<LauflisteDTO>> getLauflisten(@PathVariable UUID anlassId,
      @PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung,
      @PathVariable AnlageEnum anlage) {
    return ResponseEntity.ok(
        lauflistenService.getLauflistenDtosForAnlassAndKategorie(anlassId, kategorie, abteilung,
            anlage));
  }

  @GetMapping(value = "/{anlassId}/lauflisten/{kategorie}/{abteilung}/{anlage}", produces = "application/pdf")
  public void getLauflistenPdf(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung,
      @PathVariable AnlageEnum anlage, @RequestParam(defaultValue = "false") boolean onlyTi)
      throws IOException {

    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Lauflisten-" + kategorie + "-" + abteilung + "-" + anlage + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

    byte[] pdfBytes = lauflistenService.generateLauflistenPdfForAnlassAndKategorie(anlassId,
        kategorie, abteilung, anlage, onlyTi);
    response.getOutputStream().write(pdfBytes);
  }

  @PutMapping("/{anlassId}/lauflisten/{lauflistenId}")
  public ResponseEntity<LauflisteDTO> putLaufliste(@PathVariable UUID lauflistenId,
      @RequestBody LauflisteDTO lauflisteDto) {
    return ResponseEntity.ok(lauflistenService.updateLauflisteStatus(lauflistenId, lauflisteDto));
  }

  @PutMapping("/{anlassId}/lauflisten/{lauflistenId}/lauflisteneintraege/{lauflisteneintragId}")
  public ResponseEntity<LauflistenEintragDTO> putLauflistenEintrag(
      @PathVariable UUID lauflisteneintragId, @RequestBody LauflistenEintragDTO eintragDto) {
    return ResponseEntity.ok(lauflistenService.updateEinzelnote(lauflisteneintragId, eintragDto));
  }

  @DeleteMapping("/{anlassId}/lauflisten/{lauflistenId}/lauflisteneintraege/{lauflisteneintragId}")
  public ResponseEntity<TeilnehmerAnlassLinkDTO> deleteLauflistenEintrag(
      @PathVariable UUID lauflisteneintragId, @RequestParam String grund) {
    return ResponseEntity.ok(
        teilnehmerAnlassLinkService.markAsDeleted(lauflisteneintragId, grund));
  }
}
