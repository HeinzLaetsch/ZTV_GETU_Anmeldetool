package org.ztv.anmeldetool.controller;

import java.net.URI;
import java.util.Collection;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

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
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.LoginService;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.service.VerbandService;
import org.ztv.anmeldetool.service.WertungsrichterEinsatzService;
import org.ztv.anmeldetool.service.WertungsrichterService;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.transfer.VerbandDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterDTO;
import org.ztv.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.util.OrganisationAnlassLinkHelper;
import org.ztv.anmeldetool.util.OrganisationAnlassLinkMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;
import org.ztv.anmeldetool.util.PersonAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.PersonAnlassLinkMapper;
import org.ztv.anmeldetool.util.PersonHelper;
import org.ztv.anmeldetool.util.PersonMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;
import org.ztv.anmeldetool.util.WertungsrichterEinsatzMapper;
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

	@GetMapping("/organisationen/{orgId}/starts")
	public ResponseEntity<Collection<OrganisationAnlassLinkDTO>> getStarts(HttpServletRequest request) {
		return ResponseEntity
				.ok(OrganisationAnlassLinkHelper.toDTO(this.oalMapper, anlassSrv.getOrganisationAnlassLinks()));
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
