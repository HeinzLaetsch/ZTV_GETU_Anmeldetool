package org.ztv.anmeldetool.anmeldetool.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.util.PersonHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("loginService")
public class LoginService {
	
	@Autowired
	AuthenticationManager authenticationManager;
	
	@Autowired
	PersonService personSrv;
	
	@Autowired
	OrganisationService organisationSrv;

	public ResponseEntity<PersonDTO> login(HttpServletRequest request, LoginData loginData) {
		log.debug("Submitted Password:" + loginData.getPassword());
		
		Person person = personSrv.findPersonByBenutzername(loginData.getUsername());
		if (person == null) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		Organisation organisation = organisationSrv.findOrganisationById(loginData.getOrganisationId());
		if (organisation == null) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}		
		if (!PersonHelper.isPersonMemberOfOrganisation(person, organisation)) {
		    return ResponseEntity.status(HttpStatus.FORBIDDEN).build();			
		}
		UsernamePasswordAuthenticationToken authReq = new UsernamePasswordAuthenticationToken(LoginData.getCombinedUsername(loginData.getUsername(), loginData.getOrganisationId()), loginData.getPassword());
		authReq.setDetails(loginData);
		
	    Authentication auth = authenticationManager.authenticate(authReq);
	    
	    SecurityContext sc = SecurityContextHolder.getContext();
	    sc.setAuthentication(auth);
	    HttpSession session = request.getSession(true);
	    session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, sc);
	    log.debug("Is Authenticated: " + auth.isAuthenticated());
	    return ResponseEntity.ok(PersonHelper.createPersonDTO(person, organisation));

	}
}
