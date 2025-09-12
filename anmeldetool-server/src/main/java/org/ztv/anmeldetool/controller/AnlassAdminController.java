package org.ztv.anmeldetool.controller;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.output.AnmeldeKontrolleOutput;
import org.ztv.anmeldetool.output.BenutzerExport;
import org.ztv.anmeldetool.output.TeilnehmerExportImport;
import org.ztv.anmeldetool.output.WertungsrichterExport;
import org.ztv.anmeldetool.output.WertungsrichterOutput;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.AnlassSummaryService;
import org.ztv.anmeldetool.service.StvContestService;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.service.WertungsrichterEinsatzService;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.AnlassSummaryDTO;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.BenutzerDTO;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.TeilnahmeStatisticDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerCsvContestDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerStartDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterEinsatzDTO;

@RestController
@RequestMapping("/admin/anlaesse")
@Slf4j
@RequiredArgsConstructor
public class AnlassAdminController {

  private final AnlassService anlassSrv;
  private final AnlassSummaryService anlassSummaryService;
  private final TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;
  private final StvContestService stvContestService;
  private final WertungsrichterEinsatzService wertungsrichterEinsatzSrv;
  private final AnmeldeKontrolleOutput anmeldeKontrolleOutput;
  private final WertungsrichterOutput wertungsrichterOutput;
  private final BenutzerExport benutzerExport;
  private final WertungsrichterExport wertungsrichterExport;
  private final TeilnehmerExportImport teilnehmerExportImport;

  @GetMapping
  public ResponseEntity<Collection<AnlassDTO>> getAnlaesse(
      @RequestParam(defaultValue = "true") boolean onlyAktiv) {
    return ResponseEntity.ok(anlassSrv.getAnlaesseDTOs(onlyAktiv));
  }

  @GetMapping("/organisationen/{orgId}/summaries")
  public ResponseEntity<Collection<AnlassSummaryDTO>> getAnlassOrganisationSummaries(
      @PathVariable UUID orgId) {
    return ResponseEntity.ok(anlassSummaryService.getAnlassSummaries(orgId, true));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/summary")
  public ResponseEntity<AnlassSummaryDTO> getAnlassOrganisationSummary(@PathVariable UUID anlassId,
      @PathVariable UUID orgId) {
    return ResponseEntity.ok(anlassSummaryService.getAnlassSummary(anlassId, orgId));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}")
  public ResponseEntity<OrganisationAnlassLinkDTO> getVereinStart(@PathVariable UUID anlassId,
      @PathVariable UUID orgId) {
    return anlassSrv.getVereinStartDTO(anlassId, orgId).map(ResponseEntity::ok)
        .orElse(ResponseEntity.notFound().build());
  }

  @GetMapping(value = "/{anlassId}/wertungsrichter/", produces = "text/csv;charset=UTF-8")
  public void getWertungsrichter(HttpServletResponse response, @PathVariable UUID anlassId)
      throws IOException {
    List<PersonAnlassLinkCsvDTO> palsCsv = anlassSrv.getEingeteilteWertungsrichterAsCsv(anlassId);
    if (palsCsv.isEmpty()) {
      return;
    }
    String reportName = "Wertungsrichter_" + anlassSrv.getAnlassBezeichnung(anlassId);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    wertungsrichterExport.csvWriteToWriter(palsCsv, response.getWriter());
  }

  @GetMapping(value = "/{anlassId}/benutzer/", produces = "text/csv;charset=UTF-8")
  public void getAnmelderUndVerantwortliche(HttpServletResponse response, @PathVariable UUID anlassId)
      throws IOException {
    List<BenutzerDTO> benutzerList = anlassSrv.getAnmelderAndVerantwortliche(anlassId);
    String reportName = "Verantwortliche_Anmelder_" + anlassSrv.getAnlassBezeichnung(anlassId);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    benutzerExport.csvWriteToWriter(benutzerList, response.getWriter());
  }

  @GetMapping(value = "/{anlassId}", produces = "text/csv;charset=UTF-8")
  public void getAnmeldeDatenExport(HttpServletResponse response, @PathVariable UUID anlassId)
      throws IOException {
    AnmeldeKontrolleDTO anmeldekontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, null);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Anmeldekontrolle_" + anmeldekontrolle.getAnlass().getOrt() + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    anmeldeKontrolleOutput.csvWriteToWriter(anmeldekontrolle, response.getWriter());
  }

  @PutMapping("/{anlassId}")
  public ResponseEntity<AnlassDTO> updateAnlass(@PathVariable UUID anlassId,
      @RequestBody AnlassDTO anlassDTO) {
    return ResponseEntity.ok(anlassSrv.updateAnlass(anlassId, anlassDTO));
  }

  @PutMapping("/{anlassId}/teilnehmer")
  public ResponseEntity<Void> updateAnlassStart(@RequestBody TeilnehmerStartDTO ts) {
    teilnehmerAnlassLinkSrv.updateAnlassTeilnahme(ts);
    return ResponseEntity.ok().build();
  }

  @GetMapping("/{anlassId}/teilnehmer/statistic")
  public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(@PathVariable UUID anlassId,
      @RequestParam Optional<String> search) {
    TeilnahmeStatisticDTO statistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId, null,
        null, null, null, search);
    return ResponseEntity.ok(statistic);
  }

  @GetMapping("/{anlassId}/teilnehmer/statistic/{kategorie}")
  public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(@PathVariable UUID anlassId,
      @PathVariable(required = false) KategorieEnum kategorie,
      @RequestParam Optional<String> search) {
    TeilnahmeStatisticDTO statistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
        kategorie, null, null, null, search);
    return ResponseEntity.ok(statistic);
  }

  @GetMapping("/{anlassId}/teilnehmer/statistic/{kategorie}/{abteilung}")
  public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(@PathVariable UUID anlassId,
      @PathVariable(required = false) KategorieEnum kategorie,
      @PathVariable(required = false) AbteilungEnum abteilung,
      @RequestParam Optional<String> search) {
    TeilnahmeStatisticDTO statistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
        kategorie, abteilung, null, null, search);
    return ResponseEntity.ok(statistic);
  }

  @GetMapping("/{anlassId}/teilnehmer/statistic/{kategorie}/{abteilung}/{anlage}")
  public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(@PathVariable UUID anlassId,
      @PathVariable(required = false) KategorieEnum kategorie,
      @PathVariable(required = false) AbteilungEnum abteilung,
      @PathVariable(required = false) AnlageEnum anlage, @RequestParam Optional<String> search) {
    TeilnahmeStatisticDTO statistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
        kategorie, abteilung, anlage, null, search);
    return ResponseEntity.ok(statistic);
  }

  @GetMapping("/{anlassId}/teilnehmer/statistic/{kategorie}/{abteilung}/{anlage}/{geraet}")
  public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(@PathVariable UUID anlassId,
      @PathVariable(required = false) KategorieEnum kategorie,
      @PathVariable(required = false) AbteilungEnum abteilung,
      @PathVariable(required = false) AnlageEnum anlage,
      @PathVariable(required = false) GeraetEnum geraet, @RequestParam Optional<String> search) {
    TeilnahmeStatisticDTO statistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
        kategorie, abteilung, anlage, geraet, search);
    return ResponseEntity.ok(statistic);
  }

  @GetMapping("/{anlassId}/teilnehmer/{kategorie}/{abteilung}/{anlage}/{geraet}")
  public ResponseEntity<List<TeilnehmerStartDTO>> getByStartgeraet(@PathVariable UUID anlassId,
      @PathVariable(required = false) KategorieEnum kategorie,
      @PathVariable(required = false) AbteilungEnum abteilung,
      @PathVariable(required = false) AnlageEnum anlage,
      @PathVariable(required = false) GeraetEnum geraet, @RequestParam Optional<String> search) {
    List<TeilnehmerStartDTO> teilnehmer = teilnehmerAnlassLinkSrv.getTeilnehmerForStartgeraet(
        anlassId, kategorie, abteilung, anlage, geraet, search);
    return ResponseEntity.ok(teilnehmer);
  }

  @GetMapping(value = "/{anlassId}/teilnehmer/mutationen", produces = "text/csv;charset=UTF-8")
  public void getMutationen(HttpServletResponse response, @PathVariable UUID anlassId)
      throws IOException {
    List<TeilnehmerAnlassLinkCsvDTO> talsCsv = teilnehmerAnlassLinkSrv.getMutationenForAnlassAsCsv(
        anlassId);
    if (talsCsv.isEmpty()) {
      return;
    }
    String reportName = "Mutationen_" + anlassSrv.getAnlassBezeichnung(anlassId);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    teilnehmerExportImport.csvWriteToWriter(talsCsv, response.getWriter());
  }

  @GetMapping(value = "/{anlassId}/teilnehmer/", produces = "text/csv;charset=UTF-8")
  public void getTeilnehmer(HttpServletResponse response, @PathVariable UUID anlassId)
      throws IOException {
    List<TeilnehmerAnlassLinkCsvDTO> talsCsv = teilnehmerAnlassLinkSrv.getAllTeilnehmerForAnlassAsCsv(
        anlassId);
    if (talsCsv.isEmpty()) {
      return;
    }
    String reportName = "Teilnehmer_" + anlassSrv.getAnlassBezeichnung(anlassId);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    teilnehmerExportImport.csvWriteToWriter(talsCsv, response.getWriter());
  }

  @PostMapping("/{anlassId}/teilnehmer/")
  public ResponseEntity<Void> updateTeilnehmer(@PathVariable UUID anlassId,
      @RequestParam("teilnehmer") MultipartFile teilnehmer) throws IOException {
    log.info("Importing teilnehmer: {}, size: {}", teilnehmer.getOriginalFilename(),
        teilnehmer.getSize());
    List<TeilnehmerAnlassLinkCsvDTO> tals = teilnehmerExportImport.csvToDto(
        teilnehmer.getInputStream());
    teilnehmerAnlassLinkSrv.updateAnlassTeilnahmen(anlassId, tals);
    return ResponseEntity.ok().build();
  }

  @PostMapping("/{anlassId}/teilnehmer/contest")
  public ResponseEntity<Void> updateTeilnehmerFromContest(@PathVariable UUID anlassId,
      @RequestParam("teilnehmer") MultipartFile teilnehmer) throws IOException {
    log.info("Importing from contest: {}, size: {}", teilnehmer.getOriginalFilename(),
        teilnehmer.getSize());
    List<TeilnehmerCsvContestDTO> contestTeilnehmer = teilnehmerExportImport.csvContestToDto(
        teilnehmer.getInputStream());
    stvContestService.updateAnlassTeilnahmen(anlassId, contestTeilnehmer);
    log.info("Imported {} contest teilnehmer", contestTeilnehmer.size());
    return ResponseEntity.ok().build();
  }

  @GetMapping("/{anlassId}/organisationen/")
  public ResponseEntity<Collection<OrganisationDTO>> getVereinsStarts(@PathVariable UUID anlassId) {
    return ResponseEntity.ok(anlassSrv.getVereinsStartsDTOs(anlassId));
  }

  @PatchMapping("/{anlassId}/organisationen/{orgId}")
  public ResponseEntity<OrganisationAnlassLinkDTO> patchAnlassVereine(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @RequestBody OrganisationAnlassLinkDTO oal) {
    return anlassSrv.updateTeilnehmendeVereine(anlassId, orgId, oal).map(ResponseEntity::ok)
        .orElse(ResponseEntity.notFound().build());
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/teilnehmer/")
  public ResponseEntity<Collection<TeilnehmerAnlassLinkDTO>> getTeilnehmer(@PathVariable UUID anlassId,
      @PathVariable UUID orgId) {
    return ResponseEntity.ok(anlassSrv.getTeilnahmenDTOs(anlassId, orgId, false));
  }

  @PutMapping("/{anlassId}/organisationen/{orgId}/teilnehmer/{teilnehmerId}")
  public ResponseEntity<TeilnehmerAnlassLinkDTO> putAnlassTeilnehmer(@PathVariable UUID anlassId,
      @PathVariable UUID teilnehmerId, @RequestBody TeilnehmerAnlassLinkDTO talDto) {
    return ResponseEntity.ok(
        teilnehmerAnlassLinkSrv.updateAnlassTeilnahme(anlassId, teilnehmerId, talDto));
  }

  @GetMapping(value = "/{anlassId}/organisationen/{orgId}/anmeldekontrolle/", produces = "application/pdf")
  public void getAnmeldeKontrollePDF(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable UUID orgId) throws IOException {
    AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, orgId);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Anmeldekontrolle-" + anmeldeKontrolle.getAnlass()
            .getAnlassBezeichnung() + "-" + anmeldeKontrolle.getOrganisator().getName() + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    anmeldeKontrolleOutput.createAnmeldeKontrolle(response.getOutputStream(), anmeldeKontrolle);
  }

  @GetMapping(value = "/{anlassId}/organisationen/{orgId}/wertungsrichterkontrolle/", produces = "application/pdf")
  public void getWertungsrichterKontrollePDF(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable UUID orgId) throws IOException {
    AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, orgId);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Wertungsrichter-Einsaetze-" + anmeldeKontrolle.getAnlass()
            .getAnlassBezeichnung() + "-" + anmeldeKontrolle.getOrganisator().getName() + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    wertungsrichterOutput.createWertungsrichter(response.getOutputStream(), anmeldeKontrolle);
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/verfuegbar")
  public ResponseEntity<Collection<PersonDTO>> getVerfuegbareWertungsrichter(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable int brevet) {
    WertungsrichterBrevetEnum brevetEnum = WertungsrichterBrevetEnum.fromInt(brevet);
    return ResponseEntity.ok(anlassSrv.getVerfuegbareWertungsrichterDTOs(anlassId, orgId, brevetEnum));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/eingeteilt")
  public ResponseEntity<Collection<PersonAnlassLinkDTO>> getEingeteilteWertungsrichter(
      @PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable int brevet) {
    WertungsrichterBrevetEnum brevetEnum = WertungsrichterBrevetEnum.fromInt(brevet);
    return ResponseEntity.ok(anlassSrv.getEingeteilteWertungsrichterDTOs(anlassId, orgId, brevetEnum));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
  public ResponseEntity<PersonAnlassLinkDTO> getEinsaetze(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable UUID personId) {
    return ResponseEntity.ok(anlassSrv.getOrGenerateEinsaetzeDTO(anlassId, orgId, personId));
  }

  @PostMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
  public ResponseEntity<PersonAnlassLinkDTO> postEingeteilteWertungsrichter(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable UUID personId,
      @RequestBody PersonAnlassLinkDTO personAnlassLinkDTO) {
    return anlassSrv.createOrUpdateEingeteilteWertungsrichter(anlassId, orgId, personId, personAnlassLinkDTO)
        .map(ResponseEntity::ok).orElse(ResponseEntity.badRequest().build());
  }

  @DeleteMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
  public ResponseEntity<Void> deleteEingeteilteWertungsrichter(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable UUID personId) {
    anlassSrv.deleteEingeteilteWertungsrichter(anlassId, orgId, personId);
    return ResponseEntity.noContent().build();
  }

  @PostMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
  public ResponseEntity<WertungsrichterEinsatzDTO> postWertungsrichterEinsatz(
      @RequestBody WertungsrichterEinsatzDTO wertungsrichterEinsatzDTO) {
    return ResponseEntity.ok(wertungsrichterEinsatzSrv.updateEinsatz(wertungsrichterEinsatzDTO));
  }
}
