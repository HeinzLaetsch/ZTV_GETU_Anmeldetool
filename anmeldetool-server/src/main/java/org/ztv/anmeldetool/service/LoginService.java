package org.ztv.anmeldetool.service;

import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.exception.AccessDeniedException;
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.transfer.PersonDTO;

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

	public PersonDTO login(HttpServletRequest request, LoginData loginData) {
		log.debug("Submitted Password:" + loginData.getPassword());

		Person person = personSrv.findPersonByBenutzername(loginData.getUsername());
		if (person == null) {
			throw new AccessDeniedException("Access denied: User : %s not found".formatted(loginData.getUsername()));
		}
		Organisation organisation = organisationSrv.findById(loginData.getOrganisationId());
		if (organisation == null) {
			throw new AccessDeniedException(("Access denied: Organisation ID : %s not found".formatted(loginData.getOrganisationId())));
		}
		if (!orgPersLinkSrv.isPersonMemberOfOrganisation(person, organisation)) {
			throw new AccessDeniedException(("Access denied: User %s is not member of %s".formatted(loginData.getUsername(), organisation.getName())));
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
		// Roles are organisation-scoped -> map only for the active organisation
		return personMapper.toDto(person, loginData.getOrganisationId());
		// return ResponseEntity.ok(PersonHelper.createPersonDTO(person, organisation));

	}
}
