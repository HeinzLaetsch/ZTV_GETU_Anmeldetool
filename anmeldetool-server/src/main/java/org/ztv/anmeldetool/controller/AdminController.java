package org.ztv.anmeldetool.controller;

import java.net.URI;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.LoginService;
import org.ztv.anmeldetool.service.MailService;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.service.ServiceException;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.service.VerbandService;
import org.ztv.anmeldetool.service.WertungsrichterEinsatzService;
import org.ztv.anmeldetool.service.WertungsrichterService;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.BenutzerDTO;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.transfer.VerbandDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterEinsatzDTO;
import org.ztv.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.util.AnmeldeKontrolleExport;
import org.ztv.anmeldetool.util.BenutzerExport;
import org.ztv.anmeldetool.util.OrganisationAnlassLinkMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;
import org.ztv.anmeldetool.util.PersonAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.PersonAnlassLinkMapper;
import org.ztv.anmeldetool.util.PersonHelper;
import org.ztv.anmeldetool.util.PersonMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;
import org.ztv.anmeldetool.util.TeilnehmerExportImport;
import org.ztv.anmeldetool.util.WertungsrichterEinsatzMapper;
import org.ztv.anmeldetool.util.WertungsrichterExport;
import org.ztv.anmeldetool.util.WertungsrichterMapper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/admin")
@Slf4j
@CrossOrigin(origins = "*", allowedHeaders = "*", allowCredentials = "true")
public class AdminController {
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

	@PostMapping("/login")
	public @ResponseBody ResponseEntity<PersonDTO> post(HttpServletRequest request, @RequestBody LoginData loginData) {
		log.info("Login");
		return loginSrv.login(request, loginData);
	}

	@GetMapping("/anlaesse")
	// @ResponseBody
	public ResponseEntity<Collection<AnlassDTO>> getAnlaesse() {
		List<Anlass> anlaesse = anlassSrv.getAllAnlaesse();
		List<AnlassDTO> anlaesseDTO = anlaesse.stream().map(anlass -> {
			return anlassMapper.ToDto(anlass);
		}).collect(Collectors.toList());
		if (anlaesseDTO.size() == 0) {
			return getNotFound();
		} else {
			return ResponseEntity.ok(anlaesseDTO);
		}
	}

	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}")
	// @ResponseBody
	public ResponseEntity<OrganisationAnlassLinkDTO> getVereinStart(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		OrganisationAnlassLink oalResult = anlassSrv.getVereinStart(anlassId, orgId);
		if (oalResult == null) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(this.oalMapper.toDto(oalResult));
	}

	@GetMapping(value = "/anlaesse/{anlassId}/wertungsrichter/", produces = "text/csv;charset=UTF-8")
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

	@GetMapping(value = "/anlaesse/{anlassId}/benutzer/", produces = "text/csv;charset=UTF-8")
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

	@GetMapping(value = "/anlaesse/{anlassId}", produces = "text/csv;charset=UTF-8")
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

	@Autowired
	private MailService mailService;

	@GetMapping(value = "/anlaesse/{anlassId}/teilnehmer/mutationen", produces = "text/csv;charset=UTF-8")
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

			Person person = this.personSrv.findPersonByBenutzername("heinz.laetsch@gmx.ch");

			this.mailService.sendEmail(person);

			// response.addHeader("Content-Length", "");
		} catch (ServiceException ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Teilnehmer Export: ", ex);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Teilnehmer Export: ", ex);
		}
	}

	@GetMapping(value = "/anlaesse/{anlassId}/teilnehmer/", produces = "text/csv;charset=UTF-8")
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

	// @RequestBody Resource resource) {
	// , consumes = "application/octet-stream"

	@PostMapping(value = "/anlaesse/{anlassId}/teilnehmer/")
	// @ResponseBody
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

	@GetMapping("/anlaesse/{anlassId}/organisationen/")
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

	@PatchMapping("/anlaesse/{anlassId}/organisationen/{orgId}")
	public @ResponseBody ResponseEntity<OrganisationAnlassLinkDTO> patchAnlassVereine(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @RequestBody OrganisationAnlassLinkDTO oal) {
		OrganisationAnlassLink oalResult = anlassSrv.updateTeilnehmendeVereine(anlassId, orgId, oal);
		if (oalResult == null) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(this.oalMapper.toDto(oalResult));
	}

	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/")
	public ResponseEntity<Collection<TeilnehmerAnlassLinkDTO>> getTeilnehmer(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		List<TeilnehmerAnlassLink> links = anlassSrv.getTeilnahmen(anlassId, orgId);
		List<TeilnehmerAnlassLinkDTO> linksDto = links.stream().map(link -> {
			return teilnehmerAnlassMapper.toDto(link);
		}).collect(Collectors.toList());
		if (linksDto.size() == 0) {
			return getNotFound();
		}
		return ResponseEntity.ok(linksDto);
	}

	@PatchMapping("/anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/{teilnehmerId}")
	public @ResponseBody ResponseEntity patchAnlassTeilnehmer(HttpServletRequest request, @PathVariable UUID anlassId,
			@PathVariable UUID orgId, @PathVariable UUID teilnehmerId, @RequestBody TeilnehmerAnlassLinkDTO tal) {
		return teilnehmerSrv.updateAnlassTeilnahmen(anlassId, teilnehmerId, tal);
	}

	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/verfuegbar")
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

	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}/wertungsrichter/{brevet}/eingeteilt")
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

	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
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

	@PostMapping("/anlaesse/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
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

	@DeleteMapping("/anlaesse/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
	public ResponseEntity<PersonAnlassLinkDTO> deleteEingeteilteWertungsrichter(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID personId) {
		try {
			return anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId, "", false);
		} catch (Exception e) {
			return ResponseEntity.badRequest().build();
		}
	}

	@PostMapping("/anlaesse/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}/einsaetze")
	public ResponseEntity<WertungsrichterEinsatzDTO> postWertungsrichterEinsatz(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID personId,
			@RequestBody WertungsrichterEinsatzDTO wertungsrichterEinsatzDTO) {
		WertungsrichterEinsatz wrEinsatz = this.wertungsrichterEinsatzMapper.ToEntity(wertungsrichterEinsatzDTO);
		wrEinsatz = this.wertungsrichterEinsatzSrv.update(wrEinsatz);
		WertungsrichterEinsatzDTO dto = this.wertungsrichterEinsatzMapper.ToDto(wrEinsatz);
		return ResponseEntity.ok(dto);
	}

	// http://localhost:8080/admin/organisationen
	@GetMapping("/organisationen")
	public ResponseEntity<Collection<OrganisationDTO>> getOrganisationen() {
		return organisationSrv.getAllOrganisations();
	}

	@PostMapping("/organisationen")
	public @ResponseBody ResponseEntity<OrganisationDTO> post(HttpServletRequest request,
			@RequestBody OrganisationDTO organisation) {
		return organisationSrv.create(organisation);
	}

	@GetMapping("/organisationen/{orgId}/teilnehmer")
	public ResponseEntity<Collection<TeilnehmerDTO>> getTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId,
			@RequestParam(name = "page") int page, @RequestParam(name = "size") int size) {
		Pageable pageable = PageRequest.of(page, size);
		return teilnehmerSrv.findTeilnehmerByOrganisation(orgId, pageable);
	}

	@GetMapping("/organisationen/{orgId}/teilnehmer/count")
	public ResponseEntity<Integer> count(HttpServletRequest request, @PathVariable UUID orgId) {
		return teilnehmerSrv.countTeilnehmerByOrganisation(orgId);
	}

	@PostMapping("/organisationen/{orgId}/teilnehmer")
	public ResponseEntity<TeilnehmerDTO> addNewTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId,
			@RequestBody TeilnehmerDTO teilnehmerDTO) {
		return teilnehmerSrv.create(orgId, teilnehmerDTO.getTiTu());
	}

	@PatchMapping("/organisationen/{orgId}/teilnehmer")
	public ResponseEntity<TeilnehmerDTO> updateNewTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId,
			@RequestBody TeilnehmerDTO teilnehmerDTO) {
		return teilnehmerSrv.update(orgId, teilnehmerDTO);
	}

	@DeleteMapping("/organisationen/{orgId}/teilnehmer/{teilnehmerId}")
	public ResponseEntity<Boolean> deleteTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId,
			@PathVariable UUID teilnehmerId) {
		return teilnehmerSrv.delete(orgId, teilnehmerId);
	}

	@GetMapping("/verbaende")
	// @ResponseBody
	public ResponseEntity<Collection<VerbandDTO>> getVerbaende() {
		return verbandsSrv.getVerbaende();
	}

	@GetMapping("/login")
	// @ResponseBody
	public ResponseEntity<PersonDTO> loginGet(HttpServletRequest request, @RequestParam String organisationsname,
			@RequestParam String benutzername, @RequestParam String passwort) {
		LoginData loginData = new LoginData();
		// loginData.setOrganisationName(organisationsname);
		loginData.setUsername(benutzername);
		loginData.setPassword(passwort);
		return loginSrv.login(request, loginData);
	}

	@PatchMapping("/user")
	public @ResponseBody ResponseEntity<PersonDTO> patch(HttpServletRequest request,
			@RequestHeader("userid") String userId, @RequestHeader("vereinsid") UUID vereinsId,
			@RequestBody PersonDTO personDTO) {
		log.info("patch User");
		return personSrv.update(personDTO, vereinsId);
	}

	@PostMapping("/user")
	public @ResponseBody ResponseEntity<PersonDTO> post(HttpServletRequest request, @RequestBody PersonDTO personDTO) {
		log.info("post User");
		return personSrv.create(personDTO, null);
	}

	@PostMapping("/user/{id}")
	public @ResponseBody ResponseEntity<PersonDTO> postUser(HttpServletRequest request,
			@RequestHeader("userid") String userId, @RequestHeader("vereinsid") UUID vereinsId, @PathVariable String id,
			@RequestBody PersonDTO personDTO) {
		log.info("postUser User");
		return personSrv.create(personDTO, vereinsId);
	}

	@PatchMapping("/user/{userId}/organisationen/{organisationsId}/rollen")
	public @ResponseBody ResponseEntity<PersonDTO> postUserOrganisationRollen(HttpServletRequest request,
			@PathVariable String userId, @PathVariable String organisationsId, @RequestBody Set<RolleDTO> rollenDTO) {
		return personSrv.updateUserOrganisationRollen(userId, organisationsId, rollenDTO);
	}

	@GetMapping("/user")
	public @ResponseBody ResponseEntity<Collection<PersonDTO>> get(HttpServletRequest request,
			@RequestHeader("userid") String userId, @RequestHeader("vereinsid") UUID vereinsId) {
		log.debug("Headers= authToken: {}, userId: {}, vereinsId: {}", userId, vereinsId);
		Collection<PersonDTO> persons = personSrv.findPersonsByOrganisation(vereinsId);
		return ResponseEntity.ok(persons);
	}

	@GetMapping("/user/benutzernamen/{benutzername}")
	public @ResponseBody ResponseEntity<PersonDTO> getPersonByBenutzername(HttpServletRequest request,
			@PathVariable("benutzername") String benutzername, @RequestHeader("userid") Optional<String> userId,
			@RequestHeader("vereinsid") Optional<UUID> vereinsId) {
		// log.debug("Headers= authToken: {}, userId: {}, vereinsId: {}", userId,
		// vereinsId);
		PersonDTO person = PersonHelper.createPersonDTO(personSrv.findPersonByBenutzername(benutzername));
		if (person == null) {
			return getNotFound();
		}
		return ResponseEntity.ok(person);
	}

	@GetMapping("/role")
	public @ResponseBody ResponseEntity<Collection<RolleDTO>> getRole(HttpServletRequest request,
			@RequestHeader("userid") String userId, @RequestHeader("vereinsid") String vereinsId,
			@RequestParam(name = "userId") String searchUserId) {
		log.info("param {}", searchUserId);
		if (searchUserId != null && searchUserId.length() > 0) {
			return roleSrv.findAllForUser(vereinsId, searchUserId);
		} else {
			return roleSrv.findAll();
		}
	}

	@GetMapping("/user/{id}/wertungsrichter")
	public @ResponseBody ResponseEntity<WertungsrichterDTO> getWertungsrichterForUserId(HttpServletRequest request,
			@PathVariable UUID id) {
		Optional<Wertungsrichter> optWr = wertungsrichterSrv.getWertungsrichterByPersonId(id);
		if (optWr.isPresent()) {
			return ResponseEntity.ok(wrMapper.WertungsrichterToWertungsrichterDTO(optWr.get()));
		}
		return getNotFound();

	}

	@PutMapping("/user/{id}/wertungsrichter")
	public @ResponseBody ResponseEntity<WertungsrichterDTO> updateWertungsrichter(HttpServletRequest request,
			@PathVariable UUID id, @RequestBody WertungsrichterDTO wertungsrichterDTO) {
		Wertungsrichter wertungsrichter = wrMapper.WertungsrichterDTOToWertungsrichter(wertungsrichterDTO);
		if (wertungsrichterDTO.getId() != null) {
			wertungsrichter.setId(wertungsrichterDTO.getId());
		}
		wertungsrichter = wertungsrichterSrv.update(wertungsrichter);
		URI requestURI = ServletUriComponentsBuilder.fromCurrentRequest().build().toUri();
		return ResponseEntity.created(requestURI).build();
	}

	@DeleteMapping("/user/{id}/wertungsrichter")
	public @ResponseBody ResponseEntity<WertungsrichterDTO> deletWertungsrichter(HttpServletRequest request,
			@PathVariable UUID id) {
		Optional<Wertungsrichter> wertungsrichterOpt = wertungsrichterSrv.getWertungsrichterByPersonId(id);
		if (wertungsrichterOpt.isPresent()) {
			wertungsrichterSrv.delete(wertungsrichterOpt.get());
		}
		URI requestURI = ServletUriComponentsBuilder.fromCurrentRequest().build().toUri();
		return ResponseEntity.created(requestURI).build();
	}

	private Person doesUserExistsInOrganisation(UUID organisationId, String username) {
		Person person = personSrv.findPersonByBenutzername(username);
		if (person == null) {
			return person;
		}
		Organisation organisation = organisationSrv.findOrganisationById(organisationId);
		if (organisation != null && PersonHelper.isPersonMemberOfOrganisation(person, organisation)) {
			return person;
		}
		return null;
	}

	private String getEncodedPassword(String password) {
		log.debug("passwordEncoder: " + passwordEncoder.toString() + " ,work: " + password);
		return passwordEncoder.encode(password);
	}
}
