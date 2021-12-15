package org.ztv.anmeldetool.anmeldetool.controller.admin;

import java.net.URI;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.anmeldetool.service.LoginService;
import org.ztv.anmeldetool.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.anmeldetool.service.VerbandService;
import org.ztv.anmeldetool.anmeldetool.service.WertungsrichterEinsatzService;
import org.ztv.anmeldetool.anmeldetool.service.WertungsrichterService;
import org.ztv.anmeldetool.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.VerbandDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterEinsatzDTO;
import org.ztv.anmeldetool.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.anmeldetool.util.OrganisationMapper;
import org.ztv.anmeldetool.anmeldetool.util.PersonAnlassLinkMapper;
import org.ztv.anmeldetool.anmeldetool.util.PersonHelper;
import org.ztv.anmeldetool.anmeldetool.util.PersonMapper;
import org.ztv.anmeldetool.anmeldetool.util.WertungsrichterEinsatzMapper;
import org.ztv.anmeldetool.anmeldetool.util.WertungsrichterMapper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/admin")
@Slf4j
@CrossOrigin(origins = { "http://localhost:4200", "http://localhost:8081",
		"http://127.0.0.1:4200" }, allowedHeaders = "*", allowCredentials = "true")
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
	WertungsrichterEinsatzService wertungsrichterEinsatzSrv;

	@Autowired
	WertungsrichterMapper wrMapper;

	@Autowired
	PersonAnlassLinkMapper palMapper;

	@Autowired
	PersonMapper personMapper;

	@Autowired
	AnlassMapper anlassMapper;

	@Autowired
	OrganisationMapper organisationMapper;

	@Autowired
	WertungsrichterEinsatzMapper wertungsrichterEinsatzMapper;

	@Autowired
	PasswordEncoder passwordEncoder;

	// curl -d @login.json -H "Content-Type: application/json"
	// http://localhost:8080/admin/login
	@PostMapping("/login")
	public @ResponseBody ResponseEntity<PersonDTO> post(HttpServletRequest request, @RequestBody LoginData loginData) {
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
			return ResponseEntity.notFound().build();
		} else {
			return ResponseEntity.ok(anlaesseDTO);
		}
	}

	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}")
	// @ResponseBody
	public ResponseEntity<Boolean> getVereinStarts(HttpServletRequest request, @PathVariable UUID anlassId,
			@PathVariable UUID orgId) {
		return anlassSrv.getVereinStarts(anlassId, orgId);
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
			return ResponseEntity.notFound().build();
		} else {
			return ResponseEntity.ok(orgsDTO);
		}
	}

	@PatchMapping("/anlaesse/{anlassId}/organisationen/{orgId}")
	public @ResponseBody ResponseEntity patchAnlassVereine(HttpServletRequest request, @PathVariable UUID anlassId,
			@PathVariable UUID orgId, @RequestBody OrganisationAnlassLinkDTO oal) {
		return anlassSrv.updateTeilnehmendeVereine(anlassId, orgId, oal);
	}

	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/")
	public ResponseEntity<Collection<TeilnehmerAnlassLinkDTO>> getTeilnehmer(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId) {
		return anlassSrv.getTeilnahmen(anlassId, orgId);
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
			return ResponseEntity.notFound().build();
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
		Collection<PersonAnlassLinkDTO> palDTOs = pals.stream()
				.map(pal -> palMapper.PersonAnlassLinkToPersonAnlassLinkDTO(pal)).collect(Collectors.toList());
		if (palDTOs.size() == 0) {
			return ResponseEntity.notFound().build();
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
			return ResponseEntity.notFound().build();
		}
		if (pal.getEinsaetze() == null || pal.getEinsaetze().isEmpty()) {
			if (pal.getAnlass().getWertungsrichterSlots() != null) {
				List<WertungsrichterEinsatz> wrEs = pal.getAnlass().getWertungsrichterSlots().stream().map(slot -> {
					WertungsrichterEinsatz wrE = WertungsrichterEinsatz.builder().personAnlassLink(pal)
							.eingesetzt(false).wertungsrichterSlot(slot).build();
					wrE.setId(UUID.randomUUID());
					wrE.setAktiv(true);
					return wrE;
				}).collect(Collectors.toList());
				pal.setEinsaetze(wrEs);
			}
		}
		PersonAnlassLinkDTO palDTO = this.palMapper.PersonAnlassLinkToPersonAnlassLinkDTO(pal);
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
				PersonAnlassLinkDTO palDTO = this.palMapper.PersonAnlassLinkToPersonAnlassLinkDTO(pal);
				return ResponseEntity.ok(palDTO);
			} else {
				return anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId, true);
			}
		} catch (Exception e) {
			return ResponseEntity.badRequest().build();
		}
	}

	@DeleteMapping("/anlaesse/{anlassId}/organisationen/{orgId}/wertungsrichter/{personId}")
	public ResponseEntity<PersonAnlassLinkDTO> deleteEingeteilteWertungsrichter(HttpServletRequest request,
			@PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID personId) {
		try {
			return anlassSrv.updateEingeteilteWertungsrichter(anlassId, orgId, personId, false);
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
	public ResponseEntity<TeilnehmerDTO> addNewTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId) {
		return teilnehmerSrv.create(orgId);
	}

	@PatchMapping("/organisationen/{orgId}/teilnehmer")
	public ResponseEntity<TeilnehmerDTO> updateNewTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId,
			@RequestBody TeilnehmerDTO teilnehmerDTO) {
		return teilnehmerSrv.update(orgId, teilnehmerDTO);
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
	public @ResponseBody ResponseEntity<PersonDTO> patch(HttpServletRequest request, @RequestBody PersonDTO personDTO) {
		return personSrv.update(personDTO);
	}

	@PostMapping("/user")
	public @ResponseBody ResponseEntity<PersonDTO> post(HttpServletRequest request, @RequestBody PersonDTO personDTO) {
		return personSrv.create(personDTO);
	}

	@PostMapping("/user/{id}")
	public @ResponseBody ResponseEntity<PersonDTO> postUser(HttpServletRequest request, @PathVariable String id,
			@RequestBody PersonDTO personDTO) {
		return personSrv.create(personDTO);
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
		URI requestURI = ServletUriComponentsBuilder.fromCurrentRequest().build().toUri();
		return ResponseEntity.notFound().location(requestURI).build();

	}

	@PutMapping("/user/{id}/wertungsrichter")
	public @ResponseBody ResponseEntity<WertungsrichterDTO> updateWertungsrichter(HttpServletRequest request,
			@PathVariable String id, @RequestBody WertungsrichterDTO wertungsrichterDTO) {
		Wertungsrichter wertungsrichter = wrMapper.WertungsrichterDTOToWertungsrichter(wertungsrichterDTO);
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
