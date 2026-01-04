package org.ztv.anmeldetool.service;

import lombok.AllArgsConstructor;
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
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.util.PersonHelper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.ztv.anmeldetool.util.PersonMapper;

@Slf4j
@Service("loginService")
@AllArgsConstructor
public class LoginService {

  private final AuthenticationManager authenticationManager;

  private final PersonService personSrv;

  private final PersonMapper personMapper;

  private final OrganisationService organisationSrv;

  private final OrganisationPersonLinkService orgPersLinkSrv;

	public ResponseEntity<PersonDTO> login(HttpServletRequest request, LoginData loginData) {
		log.debug("Submitted Password:" + loginData.getPassword());

		Person person = personSrv.findPersonByBenutzername(loginData.getUsername());
		if (person == null) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		Organisation organisation = organisationSrv.findById(loginData.getOrganisationId());
		if (organisation == null) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		if (!orgPersLinkSrv.isPersonMemberOfOrganisation(person, organisation)) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		UsernamePasswordAuthenticationToken authReq = new UsernamePasswordAuthenticationToken(
				LoginData.getCombinedUsername(loginData.getUsername(), loginData.getOrganisationId()),
				loginData.getPassword());
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
