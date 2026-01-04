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
import org.springframework.http.HttpStatus;
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
import org.springframework.web.server.ResponseStatusException;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.output.AnmeldeKontrolleExport;
import org.ztv.anmeldetool.output.AnmeldeKontrolleOutput;
import org.ztv.anmeldetool.output.BenutzerExport;
import org.ztv.anmeldetool.output.TeilnehmerExportImport;
import org.ztv.anmeldetool.output.WertungsrichterExport;
import org.ztv.anmeldetool.output.WertungsrichterOutput;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.AnlassSummaryService;
import org.ztv.anmeldetool.service.AnmeldekontrolService;
import org.ztv.anmeldetool.service.OrganisationAnlassLinkService;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.PersonAnlassLinkService;
import org.ztv.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.service.StvContestService;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.service.WertungsrichterEinsatzService;
import org.ztv.anmeldetool.service.WertungsrichterService;
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
  private final OrganisationService organisationSrv;
  private final AnlassSummaryService anlassSummarySrv;
  private final AnmeldekontrolService anmeldekontrolSrv;
  private final TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;
  private final TeilnehmerService teilnehmerSrv;
  private final StvContestService stvContestSrv;
  private final WertungsrichterService wertungsrichterSrv;
  private final WertungsrichterEinsatzService wertungsrichterEinsatzSrv;
  private final OrganisationAnlassLinkService organisationAnlassLinkSrv;
  private final PersonAnlassLinkService personAnlassLinkSrv;
  private final PersonService personSrv;
  //private final BenutzerExport benutzerExport;
  //private final WertungsrichterExport wertungsrichterExport;
  //private final TeilnehmerExportImport teilnehmerExportImport;

  @GetMapping
  public ResponseEntity<List<AnlassDTO>> getAnlaesse(
      @RequestParam(defaultValue = "true") boolean onlyAktiv) {
    return ResponseEntity.ok(anlassSrv.getAnlaesseDto(onlyAktiv));
  }

  @GetMapping("/organisationen/{orgId}/summaries")
  public ResponseEntity<Collection<AnlassSummaryDTO>> getAnlassOrganisationSummaries(
      @PathVariable UUID orgId) {
    Organisation organisation = organisationSrv.findById(orgId);
    return ResponseEntity.ok(anlassSummarySrv.getAnlassSummaries(organisation, true));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/summary")
  public ResponseEntity<AnlassSummaryDTO> getAnlassOrganisationSummary(@PathVariable UUID anlassId,
      @PathVariable UUID orgId) {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    return ResponseEntity.ok(anlassSummarySrv.getAnlassSummary(anlass, organisation));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}")
  public ResponseEntity<OrganisationAnlassLinkDTO> getVereinStart(@PathVariable UUID anlassId,
      @PathVariable UUID orgId) {

    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    return ResponseEntity.ok(organisationAnlassLinkSrv.getVereinStartDTO(anlass, organisation));
  }

  @GetMapping(value = "/{anlassId}/wertungsrichter/", produces = "text/csv;charset=UTF-8")
  public void getWertungsrichter(HttpServletResponse response, @PathVariable UUID anlassId) {
    Anlass anlass = anlassSrv.findById(anlassId);
    List<PersonAnlassLinkCsvDTO> palsCsv = personAnlassLinkSrv.getWertungsrichterForAnlassAsCsvDTO(
        anlass);
    if (palsCsv.isEmpty()) {
      return;
    }
    String reportName = "Wertungsrichter_" + anlassSrv.findById(anlassId).getAnlassBezeichnung();
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    WertungsrichterExport.csvWriteToWriter(palsCsv, response);
  }

  @GetMapping(value = "/{anlassId}/benutzer/", produces = "text/csv;charset=UTF-8")
  public void getAnmelderUndVerantwortliche(HttpServletResponse response,
      @PathVariable UUID anlassId) {
    Anlass anlass = anlassSrv.findById(anlassId);
    List<BenutzerDTO> benutzerList = anlassSrv.getAnmelderAndVerantwortliche(anlass);
    String reportName =
        "Verantwortliche_Anmelder_" + anlassSrv.findById(anlassId).getAnlassBezeichnung();
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    BenutzerExport.csvWriteToWriter(benutzerList, response);
  }

  @GetMapping(value = "/{anlassId}", produces = "text/csv;charset=UTF-8")
  public void getAnmeldeDatenExport(HttpServletResponse response, @PathVariable UUID anlassId)
      throws IOException {
    try {
      Anlass anlass = anlassSrv.findById(anlassId);
      AnmeldeKontrolleDTO anmeldekontrolle = anmeldekontrolSrv.getAnmeldeKontrolle(anlass, null);
      response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
          "attachment; filename=Anmeldekontrolle_" + anmeldekontrolle.getAnlass().getOrt()
              + ".csv");
      response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
      response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS,
          HttpHeaders.CONTENT_DISPOSITION);
      AnmeldeKontrolleExport.csvWriteToWriter(anmeldekontrolle, response);
    } catch (Exception ex) {
      ex.printStackTrace();
      throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
          "Unable to generate Anmeldekontrolle: ",
          ex);
    }
  }

  @PutMapping("/{anlassId}")
  public ResponseEntity<AnlassDTO> updateAnlass(@PathVariable UUID anlassId,
      @RequestBody AnlassDTO anlassDTO) {
    return ResponseEntity.ok(anlassSrv.updateAnlass(anlassDTO));
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
  public ResponseEntity<Void> getMutationen(HttpServletResponse response, @PathVariable UUID anlassId) {
    List<TeilnehmerAnlassLinkCsvDTO> talsCsv = teilnehmerAnlassLinkSrv.getMutationenDTOForAnlass(
        anlassId);
    if (talsCsv.isEmpty()) {
      return ResponseEntity.notFound().build();
    }
    String reportName = "Mutationen_" + anlassSrv.findById(anlassId).getAnlassBezeichnung();
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    TeilnehmerExportImport.csvWriteToWriter(talsCsv, response);
    return ResponseEntity.ok().build();
  }

  @GetMapping(value = "/{anlassId}/teilnehmer/", produces = "text/csv;charset=UTF-8")
  public ResponseEntity<Void> getTeilnehmer(HttpServletResponse response, @PathVariable UUID anlassId) {
    List<TeilnehmerAnlassLinkCsvDTO> talsCsv = teilnehmerAnlassLinkSrv.getAllTeilnehmerForAnlassAsCsv(
        anlassId);
    if (talsCsv.isEmpty()) {
      return ResponseEntity.notFound().build();
    }
    String reportName = "Teilnehmer_" + anlassSrv.findById(anlassId).getAnlassBezeichnung();
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=" + reportName + ".csv");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "text/csv");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    TeilnehmerExportImport.csvWriteToWriter(talsCsv, response);
    return ResponseEntity.ok().build();
  }

  @PostMapping("/{anlassId}/teilnehmer/")
  public ResponseEntity<Void> updateTeilnehmer(@PathVariable UUID anlassId,
      @RequestParam("teilnehmer") MultipartFile teilnehmer) throws IOException {
    log.info("Importing teilnehmer: {}, size: {}", teilnehmer.getOriginalFilename(),
        teilnehmer.getSize());
    List<TeilnehmerAnlassLinkCsvDTO> tals = TeilnehmerExportImport.csvToDto(
        teilnehmer.getInputStream());
    teilnehmerAnlassLinkSrv.updateAnlassTeilnahmen(anlassId, tals);
    return ResponseEntity.ok().build();
  }

  @PostMapping("/{anlassId}/teilnehmer/contest")
  public ResponseEntity<Void> updateTeilnehmerFromContest(@PathVariable UUID anlassId,
      @RequestParam("teilnehmer") MultipartFile teilnehmer) {
    log.info("Importing from contest: {}, size: {}", teilnehmer.getOriginalFilename(),
        teilnehmer.getSize());
    List<TeilnehmerCsvContestDTO> contestTeilnehmer = TeilnehmerExportImport.csvContestToDto(
        teilnehmer);
    stvContestSrv.updateAnlassTeilnahmen(anlassId, contestTeilnehmer);
    log.info("Imported {} contest teilnehmer", contestTeilnehmer.size());
    return ResponseEntity.ok().build();
  }

  @GetMapping("/{anlassId}/organisationen/")
  public ResponseEntity<Collection<OrganisationDTO>> getVereinsStarts(@PathVariable UUID anlassId) {
    Anlass anlass = anlassSrv.findById(anlassId);
    return ResponseEntity.ok(organisationAnlassLinkSrv.getVereinsStartsDTOs(anlass));
  }

  @PatchMapping("/{anlassId}/organisationen/{orgId}")
  public ResponseEntity<OrganisationAnlassLinkDTO> patchAnlassVereine(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @RequestBody OrganisationAnlassLinkDTO oal) {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);

    return ResponseEntity.ok(
        organisationAnlassLinkSrv.updateTeilnehmendeVereine(anlass, organisation, oal));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/teilnehmer/")
  public ResponseEntity<Collection<TeilnehmerAnlassLinkDTO>> getTeilnehmer(
      @PathVariable UUID anlassId,
      @PathVariable UUID orgId) {
    return ResponseEntity.ok(
        teilnehmerAnlassLinkSrv.getTeilnahmenDTOByAnlassOrg(anlassId, orgId, false));
  }

  @PutMapping("/{anlassId}/organisationen/{orgId}/teilnehmer/{teilnehmerId}")
  public ResponseEntity<TeilnehmerAnlassLinkDTO> putAnlassTeilnehmer(@PathVariable UUID anlassId,
      @PathVariable UUID teilnehmerId, @RequestBody TeilnehmerAnlassLinkDTO talDto) {
    return ResponseEntity.ok(
        teilnehmerSrv.updateAnlassTeilnahmen(anlassId, teilnehmerId, talDto));
  }

  @GetMapping(value = "/{anlassId}/organisationen/{orgId}/anmeldekontrolle/", produces = "application/pdf")
  public void getAnmeldeKontrollePDF(HttpServletResponse response, @PathVariable UUID anlassId,
      @PathVariable UUID orgId)  {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);

    AnmeldeKontrolleDTO anmeldeKontrolle = anmeldekontrolSrv.getAnmeldeKontrolle(anlass,
        organisation);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Anmeldekontrolle-" + anmeldeKontrolle.getAnlass()
            .getAnlassBezeichnung() + "-" + anmeldeKontrolle.getOrganisator().getName() + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    AnmeldeKontrolleOutput.csvWriteToWriter(anmeldeKontrolle, response);
  }

  @GetMapping(value = "/{anlassId}/organisationen/{orgId}/wertungsrichterkontrolle/", produces = "application/pdf")
  public void getWertungsrichterKontrollePDF(HttpServletResponse response,
      @PathVariable UUID anlassId,
      @PathVariable UUID orgId) throws IOException {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    AnmeldeKontrolleDTO anmeldeKontrolle = anmeldekontrolSrv.getAnmeldeKontrolle(anlass,
        organisation);
    List<PersonAnlassLink> palBr1 = personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass,
        organisation,
        WertungsrichterBrevetEnum.Brevet_1);
    List<PersonAnlassLink> palBr2 = personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass,
        organisation,
        WertungsrichterBrevetEnum.Brevet_2);
    response.addHeader(HttpHeaders.CONTENT_DISPOSITION,
        "attachment; filename=Wertungsrichter-Einsaetze-" + anmeldeKontrolle.getAnlass()
            .getAnlassBezeichnung() + "-" + anmeldeKontrolle.getOrganisator().getName() + ".pdf");
    response.addHeader(HttpHeaders.CONTENT_TYPE, "application/pdf");
    response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
    WertungsrichterOutput.createWertungsrichter(response, anmeldeKontrolle, palBr1, palBr2);
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/verfuegbar")
  public ResponseEntity<Collection<PersonDTO>> getVerfuegbareWertungsrichter(
      @PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable int brevet) {
    WertungsrichterBrevetEnum brevetEnum = WertungsrichterBrevetEnum.fromInt(brevet);
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    List<Person> personen = personSrv.findPersonsByOrganisation(organisation.getId());
    List<PersonAnlassLink> eingeteilteWrs = personAnlassLinkSrv.getEingeteilteWertungsrichter(
        anlass, organisation,
        brevetEnum);
    return ResponseEntity.ok(
        wertungsrichterSrv.getVerfuegbareWertungsrichterDTOs(personen, eingeteilteWrs, brevetEnum));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/eingeteilt")
  public ResponseEntity<Collection<PersonAnlassLinkDTO>> getEingeteilteWertungsrichter(
      @PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable int brevet) {
    WertungsrichterBrevetEnum brevetEnum = WertungsrichterBrevetEnum.fromInt(brevet);
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    return ResponseEntity.ok(
        personAnlassLinkSrv.getEingeteilteWertungsrichterDTOs(anlass, organisation, brevetEnum));
  }

  @GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
  public ResponseEntity<PersonAnlassLinkDTO> getEinsaetze(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable UUID personId) {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    Person person = personSrv.findPersonById(personId);
    return ResponseEntity.ok(
        personAnlassLinkSrv.getPersonAnlassLinkDTO(person, organisation, anlass));
  }

  @PostMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
  public ResponseEntity<PersonAnlassLinkDTO> postEingeteilteWertungsrichter(
      @PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable UUID personId,
      @RequestBody PersonAnlassLinkDTO personAnlassLinkDTO) {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    Person person = personSrv.findPersonById(personId);
    return ResponseEntity.ok(
        personAnlassLinkSrv.createOrUpdateEingeteilteWertungsrichter(anlass, organisation, person,
            personAnlassLinkDTO));
  }

  @DeleteMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
  public ResponseEntity<Void> deleteEingeteilteWertungsrichter(@PathVariable UUID anlassId,
      @PathVariable UUID orgId, @PathVariable UUID personId) {
    Anlass anlass = anlassSrv.findById(anlassId);
    Organisation organisation = organisationSrv.findById(orgId);
    Person person = personSrv.findPersonById(personId);
    personAnlassLinkSrv.deleteEingeteilteWertungsrichter(anlass, organisation, person);
    return ResponseEntity.noContent().build();
  }

  @PostMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
  public ResponseEntity<WertungsrichterEinsatzDTO> postWertungsrichterEinsatz(
      @RequestBody WertungsrichterEinsatzDTO wertungsrichterEinsatzDTO) {
    return ResponseEntity.ok(wertungsrichterEinsatzSrv.updateEinsatz(wertungsrichterEinsatzDTO));
  }
}
