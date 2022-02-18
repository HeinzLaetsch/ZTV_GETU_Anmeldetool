package org.ztv.anmeldetool.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;

@Service
public class UserAuthorizationControl {

	// private static final String ADMIN = "GREET_ADMIN";

	public UserAuthorizationControl() {
	}

	public boolean checkAccessBasedOnRole(Authentication auth) {
		if (auth.isAuthenticated() && !auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ANONYMOUS"))) {
			// return ((User)auth.getPrincipal()).getAuthorities().contains(new
			// SimpleGrantedAuthority(ADMIN));
			return false;
		}
		return true;
	}
}
