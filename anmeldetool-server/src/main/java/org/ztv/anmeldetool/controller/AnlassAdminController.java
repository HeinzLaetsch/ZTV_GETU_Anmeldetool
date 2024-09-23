package org.ztv.anmeldetool.controller;

import java.net.URI;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.ztv.anmeldetool.exception.EntityNotFoundException;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.output.AnmeldeKontrolleOutput;
import org.ztv.anmeldetool.output.WertungsrichterOutput;
import org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.LoginService;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.service.ServiceException;
import org.ztv.anmeldetool.service.StvContestService;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.service.VerbandService;
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
import org.ztv.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.util.AnmeldeKontrolleExport;
import org.ztv.anmeldetool.util.BenutzerExport;
import org.ztv.anmeldetool.util.OrganisationAnlassLinkMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;
import org.ztv.anmeldetool.util.PersonAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.PersonAnlassLinkMapper;
import org.ztv.anmeldetool.util.PersonMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;
import org.ztv.anmeldetool.util.TeilnehmerExportImport;
import org.ztv.anmeldetool.util.WertungsrichterEinsatzMapper;
import org.ztv.anmeldetool.util.WertungsrichterExport;
import org.ztv.anmeldetool.util.WertungsrichterMapper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/admin/anlaesse")
@Slf4j
@CrossOrigin(origins = "*", allowedHeaders = "*", allowCredentials = "true")
public class AnlassAdminController {
	@Autowired
	LoginService loginSrv;

	@Autowired
	AuthenticationManager authenticationManager;

	@Autowired
	PersonService personSrv;

	@Autowired
	RoleService roleSrv;

	@Autowired
	OrganisationService organisationSrv;

	@Autowired
	VerbandService verbandsSrv;

	@Autowired
	WertungsrichterService wertungsrichterSrv;

	@Autowired
	AnlassService anlassSrv;

	@Autowired
	TeilnehmerService teilnehmerSrv;

	@Autowired
	TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;

	@Autowired
	StvContestService stvContestService;

	@Autowired
	WertungsrichterEinsatzService wertungsrichterEinsatzSrv;

	@Autowired
	WertungsrichterMapper wrMapper;

	@Autowired
	PersonAnlassLinkMapper palMapper;

	@Autowired
	OrganisationAnlassLinkMapper oalMapper;

	@Autowired
	PersonMapper personMapper;

	@Autowired
	AnlassMapper anlassMapper;

	@Autowired
	OrganisationMapper organisationMapper;

	@Autowired
	TeilnehmerAnlassLinkMapper teilnehmerAnlassMapper;

	@Autowired
	WertungsrichterEinsatzMapper wertungsrichterEinsatzMapper;

	@Autowired
	TeilnehmerAnlassLinkExportImportMapper talExImMapper;

	@Autowired
	PersonAnlassLinkExportImportMapper palExImMapper;

	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	PersonAnlassLinkRepository personAnlassLinkRepository;

	// curl -d @login.json -H "Content-Type: application/json"
	// http://localhost:8080/admin/login

	private <T> ResponseEntity<T> getNotFound() {
		URI requestURI = ServletUriComponentsBuilder.fromCurrentRequest().build().toUri();
		return ResponseEntity.notFound().location(requestURI).build();
	}

	@GetMapping()
	// @ResponseBody
	public ResponseEntity<Collection<AnlassDTO>> getAnlaesse(@RequestParam Optional<Boolean> onlyAktiv) {
		AtomicBoolean onlyAktivBoolean = new AtomicBoolean();
		onlyAktiv.ifPresentOrElse((value) -> onlyAktivBoolean.set(value), () -> onlyAktivBoolean.getAndSet(true));
		List<Anlass> anlaesse = anlassSrv.getAnlaesse(onlyAktivBoolean.get());
		List<AnlassDTO> anlaesseDTO = anlaesse.stream().map(anlass -> {
			return anlassMapper.toDto(anlass);
		}).collect(Collectors.toList());
		if (anlaesseDTO.size() == 0) {
			return getNotFound();
		} else {
			return ResponseEntity.ok(anlaesseDTO);
		}
	}

	@GetMapping("/{anlassId}/organisationen/{orgId}/summary")
	// @ResponseBody
	public ResponseEntity<AnlassSummaryDTO> getAnlassOrganisationSummary(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		OrganisationAnlassLink oalResult = anlassSrv.getVereinStart(anlassId, orgId);

		if (oalResult == null) {
			AnlassSummaryDTO asDto = AnlassSummaryDTO.builder().anlassId(anlassId).organisationsId(orgId).startet(false)
					.verlaengerungsDate(null).startendeBr1(0).startendeBr2(0).gemeldeteBr1(0).gemeldeteBr2(0)
					.br1Ok(true).br2Ok(true).build();
			return ResponseEntity.ok(asDto);
		}
		int startBr1 = 0;
		int startK1 = 0;
		int startK2 = 0;
		int startK3 = 0;
		int startK4 = 0;
		int startK5 = 0;
		int startK5A = 0;
		int startK5B = 0;
		int startK6 = 0;
		int startK7 = 0;
		int startKD = 0;
		int startKH = 0;

		int startBr2 = 0;
		int gemeldeteBr1 = 0;
		int gemeldeteBr2 = 0;
		boolean br1Ok = false;
		boolean br2Ok = false;
		if (oalResult.isAktiv()) {
			List<TeilnehmerAnlassLink> links = anlassSrv.getTeilnahmen(anlassId, orgId, false);
			startBr1 = (int) links.stream().filter(link -> {
				return link.getKategorie().isJugend();
			}).count();
			startK1 = getStartendeForKategorie(links, KategorieEnum.K1);
			startK2 = getStartendeForKategorie(links, KategorieEnum.K2);
			startK3 = getStartendeForKategorie(links, KategorieEnum.K3);
			startK4 = getStartendeForKategorie(links, KategorieEnum.K4);
			startK5 = getStartendeForKategorie(links, KategorieEnum.K5);
			startK5A = getStartendeForKategorie(links, KategorieEnum.K5A);
			startK5B = getStartendeForKategorie(links, KategorieEnum.K5B);
			startK6 = getStartendeForKategorie(links, KategorieEnum.K6);
			startK7 = getStartendeForKategorie(links, KategorieEnum.K7);
			startKD = getStartendeForKategorie(links, KategorieEnum.KD);
			startKH = getStartendeForKategorie(links, KategorieEnum.KH);

			startBr2 = (int) links.stream().filter(link -> {
				return !link.getKategorie().isJugend();
			}).count();
			List<PersonAnlassLink> pals = anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId,
					WertungsrichterBrevetEnum.Brevet_1);
			gemeldeteBr1 = pals.size();
			pals = anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_1);
			gemeldeteBr2 = pals.size();
			// TODO check anzahl
			// TODO store anzahl within config
			br1Ok = (Math.ceil(startBr1 / 15.0f)) <= gemeldeteBr1;
			br2Ok = (Math.ceil(startBr2 / 15.0f)) <= gemeldeteBr2;
		}
		AnlassSummaryDTO asDto = AnlassSummaryDTO.builder().anlassId(anlassId).organisationsId(orgId)
				.startet(oalResult.isAktiv()).verlaengerungsDate(null).startendeBr1(startBr1).startendeK1(startK1)
				.startendeK2(startK2).startendeK3(startK3).startendeK4(startK4).startendeK5(startK5)
				.startendeK5A(startK5A).startendeK5B(startK5B).startendeK6(startK6).startendeK7(startK7)
				.startendeKD(startKD).startendeKH(startKH).startendeBr2(startBr2).gemeldeteBr1(gemeldeteBr1)
				.gemeldeteBr2(gemeldeteBr2).br1Ok(br1Ok).br2Ok(br2Ok).build();
		return ResponseEntity.ok(asDto);
	}

	private int getStartendeForKategorie(List<TeilnehmerAnlassLink> links, KategorieEnum kategorie) {
		return (int) links.stream().filter(link -> {
			return link.getKategorie().equals(kategorie) && (link.getMeldeStatus().equals(MeldeStatusEnum.STARTET)
					|| link.getMeldeStatus().equals(MeldeStatusEnum.NEUMELDUNG));
		}).count();

	}

	@GetMapping("/{anlassId}/organisationen/{orgId}")
	// @ResponseBody
	public ResponseEntity<OrganisationAnlassLinkDTO> getVereinStart(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		OrganisationAnlassLink oalResult = anlassSrv.getVereinStart(anlassId, orgId);
		if (oalResult == null) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(this.oalMapper.toDto(oalResult));
	}

	@GetMapping(value = "/{anlassId}/wertungsrichter/", produces = "text/csv;charset=UTF-8")
	// @ResponseBody
	public void getWertungsrichter(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId) {
		try {

			List<PersonAnlassLink> pals = anlassSrv.getEingeteilteWertungsrichter(anlassId);

			List<PersonAnlassLinkCsvDTO> palsCsv = pals.stream().map(pal -> {
				return palExImMapper.fromEntity(pal);
			}).collect(Collectors.toList());

			String reportName = "Wertungsrichter_" + pals.get(0).getAnlass().getAnlassBezeichnung();

			response.addHeader("Content-Disposition", "attachment; filename=" + reportName + ".csv");
			response.addHeader("Content-Type", "text/csv");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			// response.setCharacterEncoding("UTF-8");
			WertungsrichterExport.csvWriteToWriter(palsCsv, response);

			// response.addHeader("Content-Length", "");
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Wertungsrichter Export: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/benutzer/", produces = "text/csv;charset=UTF-8")
	// @ResponseBody
	public void getAnmelderUndVerantwortliche(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId) {
		try {
			Anlass anlass = anlassSrv.findAnlassById(anlassId);
			List<Organisation> orgs = anlassSrv.getVereinsStarts(anlassId);

			List<BenutzerDTO> benutzerList = new ArrayList<BenutzerDTO>();
			for (Organisation org : orgs) {
				if (org.isAktiv()) {
					for (OrganisationPersonLink opl : org.getPersonenLinks()) {
						BenutzerDTO benutzer = null;
						for (RollenLink rl : opl.getRollenLink()) {
							if (rl.isAktiv() && (RollenEnum.ANMELDER.equals(rl.getRolle().getName())
									|| RollenEnum.VEREINSVERANTWORTLICHER.equals(rl.getRolle().getName()))) {
								if (benutzer == null) {
									benutzer = new BenutzerDTO();
									benutzer.setBenutzername(opl.getPerson().getBenutzername());
									benutzer.setName(opl.getPerson().getName());
									benutzer.setVorname(opl.getPerson().getVorname());
									benutzer.setHandy(opl.getPerson().getHandy());
									benutzer.setEmail(opl.getPerson().getEmail());
									benutzer.setVerein(org.getName());
								}
								if (RollenEnum.ANMELDER.equals(rl.getRolle().getName())) {
									benutzer.setAnmelder(true);
								} else {
									benutzer.setVerantwortlicher(true);
								}
							}
						}
						if (benutzer != null) {
							benutzerList.add(benutzer);
						}
					}
				}
			}

			String reportName = "Verantwortliche_Anmelder_" + anlass.getAnlassBezeichnung() + "_" + anlass.getOrt();

			response.addHeader("Content-Disposition", "attachment; filename=" + reportName + ".csv");
			response.addHeader("Content-Type", "text/csv");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			// response.setCharacterEncoding("UTF-8");
			BenutzerExport.csvWriteToWriter(benutzerList, response);

			// response.addHeader("Content-Length", "");
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Benutzer Export: ",
					ex);
		}
	}

	@GetMapping(value = "/{anlassId}", produces = "text/csv;charset=UTF-8")
	public void getAnmeldeDatenExport(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId) {
		try {
			AnmeldeKontrolleDTO anmeldekontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, null);

			response.addHeader("Content-Disposition",
					"attachment; filename=Anmeldekontrolle_" + anmeldekontrolle.getAnlass().getOrt() + ".csv");
			response.addHeader("Content-Type", "text/csv");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			AnmeldeKontrolleExport.csvWriteToWriter(anmeldekontrolle, response);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Anmeldekontrolle: ",
					ex);
		}
	}

	@PutMapping(value = "/{anlassId}")
	public ResponseEntity<AnlassDTO> updateAnlass(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @RequestBody AnlassDTO anlassDTO) {
		try {
			Anlass anlass = this.anlassSrv.findAnlassById(anlassDTO.getId());
			if (anlass == null) {
				return this.getNotFound();
			}
			anlass.setToolSperren(anlassDTO.isToolSperren());
			anlass = this.anlassSrv.updateAnlass(anlass);
			anlassDTO = anlassMapper.toDto(anlass);
			return ResponseEntity.ok().body(anlassDTO);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to update Anlass ", ex);
		}
	}

	@PutMapping(value = "/{anlassId}/teilnehmer")
	public ResponseEntity updateAnlassStart(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @RequestBody TeilnehmerStartDTO ts) {

		try {
			teilnehmerAnlassLinkSrv.updateAnlassTeilnahme(ts);
			return ResponseEntity.ok().build();
		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to update Anlassstart: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to update Anlassstart: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/statistic")
	public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId,
			@RequestParam(name = "search") Optional<String> search) {

		try {
			TeilnahmeStatisticDTO teilnehmerStatistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId, null,
					null, null, null, search);
			return ResponseEntity.ok(teilnehmerStatistic);
		} catch (ServiceException ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/statistic/{kategorie}")
	public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable(required = false) KategorieEnum kategorie,
			@RequestParam(name = "search") Optional<String> search) {

		try {
			TeilnahmeStatisticDTO teilnehmerStatistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
					kategorie, null, null, null, search);
			return ResponseEntity.ok(teilnehmerStatistic);
		} catch (ServiceException ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/statistic/{kategorie}/{abteilung}")
	public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable(required = false) KategorieEnum kategorie,
			@PathVariable(required = false) AbteilungEnum abteilung,
			@RequestParam(name = "search") Optional<String> search) {

		try {
			TeilnahmeStatisticDTO teilnehmerStatistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
					kategorie, abteilung, null, null, search);
			return ResponseEntity.ok(teilnehmerStatistic);
		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/statistic/{kategorie}/{abteilung}/{anlage}")
	public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable(required = false) KategorieEnum kategorie,
			@PathVariable(required = false) AbteilungEnum abteilung, @PathVariable(required = false) AnlageEnum anlage,
			@RequestParam(name = "search") Optional<String> search) {

		try {
			TeilnahmeStatisticDTO teilnehmerStatistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
					kategorie, abteilung, anlage, null, search);
			return ResponseEntity.ok(teilnehmerStatistic);
		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/statistic/{kategorie}/{abteilung}/{anlage}/{geraet}")
	public ResponseEntity<TeilnahmeStatisticDTO> getAnlassStatistic(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable(required = false) KategorieEnum kategorie,
			@PathVariable(required = false) AbteilungEnum abteilung, @PathVariable(required = false) AnlageEnum anlage,
			@PathVariable(required = false) GeraetEnum geraet, @RequestParam(name = "search") Optional<String> search) {

		try {
			TeilnahmeStatisticDTO teilnehmerStatistic = teilnehmerAnlassLinkSrv.getStatisticForAnlass(anlassId,
					kategorie, abteilung, anlage, geraet, search);
			return ResponseEntity.ok(teilnehmerStatistic);
		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to get Anlass Statistic: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/{kategorie}/{abteilung}/{anlage}/{geraet}")
	public ResponseEntity<List<TeilnehmerStartDTO>> getByStartgeraet(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable(required = false) KategorieEnum kategorie,
			@PathVariable(required = false) AbteilungEnum abteilung, @PathVariable(required = false) AnlageEnum anlage,
			@PathVariable(required = false) GeraetEnum geraet, @RequestParam(name = "search") Optional<String> search) {

		try {
			List<TeilnehmerStartDTO> teilnehmer = teilnehmerAnlassLinkSrv.getTeilnehmerForStartgeraet(anlassId,
					kategorie, abteilung, anlage, geraet, search);
			return ResponseEntity.ok(teilnehmer);
		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to get Teilnehmer by Startgeraet: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to get Teilnehmer by Startgeraet: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/mutationen", produces = "text/csv;charset=UTF-8")
	// @ResponseBody
	public void getMutationen(HttpServletRequest request, HttpServletResponse response, @PathVariable UUID anlassId) {
		List<TeilnehmerAnlassLink> tals = null;
		try {
			tals = teilnehmerAnlassLinkSrv.getMutationenForAnlass(anlassId);
			if (tals == null || tals.size() == 0) {
				return;
			}
			List<TeilnehmerAnlassLinkCsvDTO> talsCsv = tals.stream().map(tal -> {
				return talExImMapper.fromEntity(tal);
			}).collect(Collectors.toList());

			String reportName = "Mutationen_" + tals.get(0).getAnlass().getAnlassBezeichnung();

			response.addHeader("Content-Disposition", "attachment; filename=" + reportName + ".csv");
			response.addHeader("Content-Type", "text/csv");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			// response.setCharacterEncoding("UTF-8");
			TeilnehmerExportImport.csvWriteToWriter(talsCsv, response);

		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Teilnehmer Export: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Teilnehmer Export: ", ex);
		}
	}

	private String getAnmeldeDaten(UUID anlassId, UUID orgId) {

		AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, orgId);
		StringBuilder sb = new StringBuilder();

		return sb.toString();
	}

	@GetMapping(value = "/{anlassId}/teilnehmer/", produces = "text/csv;charset=UTF-8")
	// @ResponseBody
	public void getTeilnehmer(HttpServletRequest request, HttpServletResponse response, @PathVariable UUID anlassId) {
		List<TeilnehmerAnlassLink> tals = null;
		try {
			tals = teilnehmerAnlassLinkSrv.getAllTeilnehmerForAnlassAndUpdateStartnummern(anlassId);
			if (tals == null || tals.size() == 0) {
				return;
			}
			List<TeilnehmerAnlassLinkCsvDTO> talsCsv = tals.stream().map(tal -> {
				return talExImMapper.fromEntity(tal);
			}).collect(Collectors.toList());

			String reportName = "Teilnehmer_" + tals.get(0).getAnlass().getAnlassBezeichnung();

			response.addHeader("Content-Disposition", "attachment; filename=" + reportName + ".csv");
			response.addHeader("Content-Type", "text/csv");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			// response.setCharacterEncoding("UTF-8");
			TeilnehmerExportImport.csvWriteToWriter(talsCsv, response);

			// response.addHeader("Content-Length", "");
		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Teilnehmer Export: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Teilnehmer Export: ", ex);
		}
	}

	@PostMapping(value = "/{anlassId}/teilnehmer/")
	public ResponseEntity updateTeilnehmer(@PathVariable UUID anlassId,
			@RequestParam("teilnehmer") MultipartFile teilnehmer) {
		try {
			// this.log.debug("Resource: {} , length: {}", resource.getFilename(),
			// resource.contentLength());
			this.log.info("Import: {} , length: {}", teilnehmer.getOriginalFilename(), teilnehmer.getSize());

			List<TeilnehmerAnlassLinkCsvDTO> tals = TeilnehmerExportImport
					.csvWriteToWriter(teilnehmer.getInputStream());
			teilnehmerAnlassLinkSrv.updateAnlassTeilnahmen(anlassId, tals);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ResponseEntity.ok().build();
	}

	@PostMapping(value = "/{anlassId}/teilnehmer/contest")
	public ResponseEntity updateTeilnehmerFromContest(@PathVariable UUID anlassId,
			@RequestParam("teilnehmer") MultipartFile teilnehmer) {
		try {
			// this.log.debug("Resource: {} , length: {}", resource.getFilename(),
			// resource.contentLength());
			this.log.info("Import: {} , length: {}", teilnehmer.getOriginalFilename(), teilnehmer.getSize());

			List<TeilnehmerCsvContestDTO> contestTeilnehmer = TeilnehmerExportImport
					.csvContestWriteToWriter(teilnehmer.getInputStream());
			stvContestService.updateAnlassTeilnahmen(anlassId, contestTeilnehmer);
			this.log.info("Import: {} , length: {}", teilnehmer.getOriginalFilename(), contestTeilnehmer.size());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ResponseEntity.ok().build();
	}

	@GetMapping("/{anlassId}/organisationen/")
	// @ResponseBody
	public ResponseEntity<Collection<OrganisationDTO>> getVereinsStarts(HttpServletRequest request,
			@PathVariable UUID anlassId) {
		List<Organisation> orgs = anlassSrv.getVereinsStarts(anlassId);
		List<OrganisationDTO> orgsDTO = orgs.stream().map(org -> {
			return organisationMapper.ToDto(org);
		}).collect(Collectors.toList());

		if (orgsDTO.size() == 0) {
			return getNotFound();
		} else {
			return ResponseEntity.ok(orgsDTO);
		}
	}

	@PatchMapping("/{anlassId}/organisationen/{orgId}")
	public @ResponseBody ResponseEntity<OrganisationAnlassLinkDTO> patchAnlassVereine(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @RequestBody OrganisationAnlassLinkDTO oal) {
		OrganisationAnlassLink oalResult = anlassSrv.updateTeilnehmendeVereine(anlassId, orgId, oal);
		if (oalResult == null) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(this.oalMapper.toDto(oalResult));
	}

	@GetMapping("/{anlassId}/organisationen/{orgId}/teilnehmer/")
	public ResponseEntity<Collection<TeilnehmerAnlassLinkDTO>> getTeilnehmer(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		List<TeilnehmerAnlassLink> links = anlassSrv.getTeilnahmen(anlassId, orgId, false);
		List<TeilnehmerAnlassLinkDTO> linksDto = links.stream().map(link -> {
			return teilnehmerAnlassMapper.toDto(link);
		}).collect(Collectors.toList());
		if (linksDto.size() == 0) {
			return getNotFound();
		}
		return ResponseEntity.ok(linksDto);
	}

	@PutMapping("/{anlassId}/organisationen/{orgId}/teilnehmer/{teilnehmerId}")
	public @ResponseBody ResponseEntity<TeilnehmerAnlassLinkDTO> putAnlassTeilnehmer(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID teilnehmerId,
			@RequestBody TeilnehmerAnlassLinkDTO talDto) {

		TeilnehmerAnlassLink tal = teilnehmerSrv.updateAnlassTeilnahmen(anlassId, teilnehmerId, talDto);
		talDto = teilnehmerAnlassMapper.toDto(tal);
		return ResponseEntity.ok(talDto);
	}

	@GetMapping(value = "/{anlassId}/organisationen/{orgId}/anmeldekontrolle/", produces = "application/pdf")
	public void getAnmeldeKontrollePDF(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		try {
			AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, orgId);

			response.addHeader("Content-Disposition",
					"attachment; filename=Anmeldekontrolle-" + anmeldeKontrolle.getAnlass().getAnlassBezeichnung() + "-"
							+ anmeldeKontrolle.getOrganisator().getName() + ".pdf");
			response.addHeader("Content-Type", "application/pdf");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			// Teilnehmer
			AnmeldeKontrolleOutput.createAnmeldeKontrolle(response.getOutputStream(), anmeldeKontrolle);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Anmeldekontrolle: ",
					ex);
		}
	}

	@GetMapping(value = "/{anlassId}/organisationen/{orgId}/wertungsrichterkontrolle/", produces = "application/pdf")
	public void getWertungsrichterKontrollePDF(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		try {
			AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlassId, orgId);
			List<PersonAnlassLink> palBr1 = anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId,
					WertungsrichterBrevetEnum.Brevet_1);
			List<PersonAnlassLink> palBr2 = anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId,
					WertungsrichterBrevetEnum.Brevet_2);

			response.addHeader("Content-Disposition",
					"attachment; filename=Wertungsrichter-Einsätze-"
							+ anmeldeKontrolle.getAnlass().getAnlassBezeichnung() + "-"
							+ anmeldeKontrolle.getOrganisator().getName() + ".pdf");
			response.addHeader("Content-Type", "application/pdf");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			WertungsrichterOutput.createWertungsrichter(response.getOutputStream(), anmeldeKontrolle, palBr1, palBr2);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Anmeldekontrolle: ",
					ex);
		}
	}

	@GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/verfuegbar")
	public ResponseEntity<Collection<PersonDTO>> getVerfuegbareWertungsrichter(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable int brevet) {
		WertungsrichterBrevetEnum brevetEnum;
		if (WertungsrichterBrevetEnum.Brevet_1.brevet == brevet) {
			brevetEnum = WertungsrichterBrevetEnum.Brevet_1;
		} else {
			brevetEnum = WertungsrichterBrevetEnum.Brevet_2;
		}
		List<Person> wrs = anlassSrv.getVerfuegbareWertungsrichter(anlassId, orgId, brevetEnum);
		Collection<PersonDTO> wrDTOs = wrs.stream().map(person -> personMapper.PersonToPersonDTO(person))
				.collect(Collectors.toList());
		if (wrDTOs.size() == 0) {
			return getNotFound();
		} else {
			return ResponseEntity.ok(wrDTOs);
		}
	}

	@GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/eingeteilt")
	public ResponseEntity<Collection<PersonAnlassLinkDTO>> getEingeteilteWertungsrichter(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable int brevet) {
		WertungsrichterBrevetEnum brevetEnum;
		if (WertungsrichterBrevetEnum.Brevet_1.brevet == brevet) {
			brevetEnum = WertungsrichterBrevetEnum.Brevet_1;
		} else {
			brevetEnum = WertungsrichterBrevetEnum.Brevet_2;
		}
		List<PersonAnlassLink> pals = anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId, brevetEnum);
		Collection<PersonAnlassLinkDTO> palDTOs = pals.stream().map(pal -> palMapper.toDto(pal))
				.collect(Collectors.toList());
		if (palDTOs.size() == 0) {
			return getNotFound();
		} else {
			return ResponseEntity.ok(palDTOs);
		}
	}

	@GetMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
	public ResponseEntity<PersonAnlassLinkDTO> getEinsatze(HttpServletRequest request, @PathVariable UUID anlassId,
			@PathVariable UUID orgId, @PathVariable UUID personId) {

		PersonAnlassLink pal;
		try {
			pal = anlassSrv.getAnlassLink(anlassId, orgId, personId);
		} catch (Exception e) {
			return ResponseEntity.badRequest().build();
		}
		if (pal == null) {
			return getNotFound();
		}
		if (pal.getEinsaetze() == null || pal.getEinsaetze().isEmpty()) {
			if (pal.getAnlass().getWertungsrichterSlots() != null) {
				List<WertungsrichterSlot> slots = pal.getAnlass().getWertungsrichterSlots().stream().filter(slot -> {
					if (pal.getAnlass().getHoechsteKategorie().isJugend()) {
						return true;
					}
					return pal.getPerson().getWertungsrichter().getBrevet() == slot.getBrevet();
				}).collect(Collectors.toList());

				List<WertungsrichterEinsatz> wrEs = slots.stream().map(slot -> {
					WertungsrichterEinsatz wrE = WertungsrichterEinsatz.builder().personAnlassLink(pal)
							.eingesetzt(false).wertungsrichterSlot(slot).build();
					wrE.setId(UUID.randomUUID());
					wrE.setAktiv(true);
					wrE = this.wertungsrichterEinsatzSrv.update(wrE);
					return wrE;
				}).collect(Collectors.toList());
				pal.setEinsaetze(wrEs);
			}
		}
		PersonAnlassLinkDTO palDTO = this.palMapper.toDto(pal);
		return ResponseEntity.ok(palDTO);
	}

	@PostMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
	public ResponseEntity<PersonAnlassLinkDTO> postEingeteilteWertungsrichter(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID personId,
			@RequestBody PersonAnlassLinkDTO personAnlassLinkDTO) {
		try {
			PersonAnlassLink pal = anlassSrv.getAnlassLink(anlassId, orgId, personId);
			if (pal != null) {
				pal.setKommentar(personAnlassLinkDTO.getKommentar());
				pal = personAnlassLinkRepository.save(pal);
				PersonAnlassLinkDTO palDTO = this.palMapper.toDto(pal);
				return ResponseEntity.ok(palDTO);
			} else {
				return anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId,
						personAnlassLinkDTO.getKommentar(), true);
			}
		} catch (Exception e) {
			return ResponseEntity.badRequest().build();
		}
	}

	@DeleteMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
	public ResponseEntity<PersonAnlassLinkDTO> deleteEingeteilteWertungsrichter(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID personId) {
		try {
			return anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "", false);
		} catch (Exception e) {
			return ResponseEntity.badRequest().build();
		}
	}

	@PostMapping("/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
	public ResponseEntity<WertungsrichterEinsatzDTO> postWertungsrichterEinsatz(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID personId,
			@RequestBody WertungsrichterEinsatzDTO wertungsrichterEinsatzDTO) {
		WertungsrichterEinsatz wrEinsatz = this.wertungsrichterEinsatzMapper.ToEntity(wertungsrichterEinsatzDTO);
		wrEinsatz = this.wertungsrichterEinsatzSrv.update(wrEinsatz);
		WertungsrichterEinsatzDTO dto = this.wertungsrichterEinsatzMapper.ToDto(wrEinsatz);
		return ResponseEntity.ok(dto);
	}

	@ExceptionHandler(EntityNotFoundException.class)
	public ResponseEntity<?> handlerEntityNotFound(EntityNotFoundException ex) {
		this.log.warn(ex.getMessage());

		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
	}

	@ExceptionHandler(Exception.class)
	public ResponseEntity<?> handlerException(Exception ex) {
		log.warn("Call failed", ex);

		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
	}
}
