package org.ztv.anmeldetool.anmeldetool.controller.admin;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.web.bind.annotation.CrossOrigin;
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
import org.ztv.anmeldetool.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.anmeldetool.models.ZTVResponseEntity;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.anmeldetool.service.LoginService;
import org.ztv.anmeldetool.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.anmeldetool.service.VerbandService;
import org.ztv.anmeldetool.anmeldetool.service.WertungsrichterService;
import org.ztv.anmeldetool.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.VerbandDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterDTO;
import org.ztv.anmeldetool.anmeldetool.util.PersonHelper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/admin")
@Slf4j
@CrossOrigin(origins = {"http://localhost:4200","http://127.0.0.1:4200"}, allowedHeaders = "*", allowCredentials = "true")
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
	PasswordEncoder passwordEncoder;	
		
	// curl -d @login.json -H "Content-Type: application/json" http://localhost:8080/admin/login
	@PostMapping("/login")
	public @ResponseBody ResponseEntity<PersonDTO> post(HttpServletRequest request, @RequestBody LoginData loginData) {
		return loginSrv.login(request, loginData);	    
	}
	@GetMapping("/anlaesse")
	// @ResponseBody
	public ResponseEntity<Collection<AnlassDTO>> getAnlaesse() {
		return anlassSrv.getAllAnlaesse();
	}
	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}")
	// @ResponseBody
	public ResponseEntity<Boolean> getVereinStarts(HttpServletRequest request, @PathVariable UUID anlassId, @PathVariable UUID orgId) {
		return anlassSrv.getVereinStarts(anlassId, orgId);
	}
	@GetMapping("/anlaesse/{anlassId}/organisationen/")
	// @ResponseBody
	public ResponseEntity<Collection<OrganisationenDTO>> getVereinsStarts(HttpServletRequest request, @PathVariable UUID anlassId) {
		return anlassSrv.getVereinsStarts(anlassId);
	}
	@PatchMapping("/anlaesse/{anlassId}/organisationen/{orgId}")
	public @ResponseBody ResponseEntity patchAnlassVereine(HttpServletRequest request, @PathVariable UUID anlassId, @PathVariable UUID orgId, @RequestBody OrganisationAnlassLinkDTO oal) {
		return anlassSrv.updateTeilnehmendeVereine(anlassId, orgId, oal);   
	}
	@GetMapping("/anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/")
	public ResponseEntity<Collection<TeilnehmerAnlassLinkDTO>> getTeilnehmer(HttpServletRequest request, @PathVariable UUID anlassId, @PathVariable UUID orgId) {
		return anlassSrv.getTeilnahmen(anlassId, orgId);
	}
	//             /anlaesse/a977a103-5512-4e97-9773-24d465d62ba1/teilnehmer/
	@PatchMapping("/anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/{teilnehmerId}")
	public @ResponseBody ResponseEntity patchAnlassTeilnehmer(HttpServletRequest request, @PathVariable UUID anlassId, @PathVariable UUID orgId, @PathVariable UUID teilnehmerId, @RequestBody TeilnehmerAnlassLinkDTO tal) {
		return teilnehmerSrv.updateAnlassTeilnahmen(anlassId, teilnehmerId, tal);   
	}
	
	// http://localhost:8080/admin/organisationen
	@GetMapping("/organisationen")
	// @ResponseBody
	public ResponseEntity<Collection<OrganisationenDTO>> getOrganisationen() {
		return organisationSrv.getAllOrganisations();
	}

	@PostMapping("/organisationen")
	public @ResponseBody ResponseEntity<OrganisationenDTO> post(HttpServletRequest request, @RequestBody OrganisationenDTO organisation) {
		return organisationSrv.create(organisation);   
	}
	@GetMapping("/organisationen/{orgId}/teilnehmer")
	public ResponseEntity<Collection<TeilnehmerDTO>> getTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId, @RequestParam(name="page") int page, @RequestParam(name="size") int size) {
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
	public ResponseEntity<TeilnehmerDTO> updateNewTeilnehmer(HttpServletRequest request, @PathVariable UUID orgId, @RequestBody TeilnehmerDTO teilnehmerDTO) {
		return teilnehmerSrv.update(orgId, teilnehmerDTO);
	}

	// http://localhost:8080/admin/organisationen
	@GetMapping("/verbaende")
	// @ResponseBody
	public ResponseEntity<Collection<VerbandDTO>> getVerbaende() {
		return verbandsSrv.getVerbaende();
	}

	// http://localhost:8080/admin/login?organisationsname=ZTV&benutzername=admin&passwort=test
	@GetMapping("/login")
	// @ResponseBody
	public ResponseEntity<PersonDTO> loginGet(HttpServletRequest request, @RequestParam String organisationsname, @RequestParam String benutzername, @RequestParam String passwort) {
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
	public @ResponseBody ResponseEntity<PersonDTO> postUser(HttpServletRequest request,@PathVariable String id, @RequestBody PersonDTO personDTO) {
		return personSrv.create(personDTO);   
	}

	@PatchMapping("/user/{userId}/organisationen/{organisationsId}/rollen")
	public @ResponseBody ResponseEntity<PersonDTO> postUserOrganisationRollen(HttpServletRequest request, @PathVariable String userId, @PathVariable String organisationsId, @RequestBody Set<RolleDTO> rollenDTO) {
		return personSrv.updateUserOrganisationRollen(userId, organisationsId, rollenDTO);   
	}

	@GetMapping("/user")
	public @ResponseBody ResponseEntity<Collection<PersonDTO>> get(HttpServletRequest request, 
			@RequestHeader("userid") String userId, @RequestHeader("vereinsid") String vereinsId) {
		log.debug("Headers= authToken: {}, userId: {}, vereinsId: {}", userId, vereinsId);
		Collection<PersonDTO> persons = personSrv.findPersonsByOrganisation(vereinsId);
	    return ResponseEntity.ok(persons);
	}

	@GetMapping("/role")
	public @ResponseBody ResponseEntity<Collection<RolleDTO>> getRole(HttpServletRequest request, 
			@RequestHeader("userid") String userId, @RequestHeader("vereinsid") String vereinsId, @RequestParam(name="userId") String searchUserId) {
		log.info("param {}", searchUserId);
		if (searchUserId != null && searchUserId.length() > 0) {
			return roleSrv.findAllForUser(vereinsId , searchUserId);
		} else {
			return roleSrv.findAll();
		}
	}

	@GetMapping("/user/{id}/wertungsrichter")
	public @ResponseBody ResponseEntity<WertungsrichterDTO> getWertungsrichterForUserId(HttpServletRequest request,@PathVariable String id) {
		return wertungsrichterSrv.getWertungsrichterForUserId(id);   
	}
	@PutMapping("/user/{id}/wertungsrichter")
	public @ResponseBody ResponseEntity<WertungsrichterDTO> updateWertungsrichter(HttpServletRequest request,@PathVariable String id, @RequestBody WertungsrichterDTO wertungsrichterDTO) {
		return wertungsrichterSrv.update(id, wertungsrichterDTO);   
	}

	/*
	 	LoginData loginData = new LoginData();
		// loginData.setOrganisationName("ZTV");
		loginData.setUsername("admin");
		//loginData.setPasswordEncrypted(getEncodedPassword("test"));
		loginData.setPassword("test");
		log.debug("Submitted Password:" + loginData.getPassword());
		Person person = doesUserExistsInOrganisation(loginData.getOrganisationId(), loginData.getUsername());
		if (person == null) {
		    return new ResponseEntity<String>("Wrong Credentials" , HttpStatus.FORBIDDEN);			
		}
		UsernamePasswordAuthenticationToken authReq = new UsernamePasswordAuthenticationToken(loginData.getUsername(), loginData.getPassword());
	    
	    Authentication auth = authenticationManager.authenticate(authReq);
	    
	    SecurityContext sc = SecurityContextHolder.getContext();
	    sc.setAuthentication(auth);
	    HttpSession session = request.getSession(true);
	    session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, sc);

	 */

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
