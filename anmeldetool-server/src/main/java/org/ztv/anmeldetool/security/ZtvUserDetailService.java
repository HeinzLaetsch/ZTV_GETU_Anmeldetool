package org.ztv.anmeldetool.security;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.repositories.RollenRepository;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.util.OrganisationLinkHelper;

import lombok.extern.slf4j.Slf4j;

@Service("userDetailsService")
@Transactional
@Slf4j
public class ZtvUserDetailService implements UserDetailsService {

	@Autowired
	private OrganisationService organisationSrv;

	@Autowired
	private PersonenRepository personenRepository;

	@Autowired
	private RollenRepository roleRepository;

	@Override
	public UserDetails loadUserByUsername(String benutzername) throws UsernameNotFoundException {
		String[] parts = LoginData.splitCombinedUsername(benutzername);
		log.debug("CombinedUsername is: " + benutzername + " , parts: " + parts.length);

		Person person = personenRepository.findByBenutzernameIgnoreCase(parts[0]);
		if (person == null) {
			return new org.springframework.security.core.userdetails.User(" ", " ", true, true, true, true,
					getAuthorities(Arrays.asList(roleRepository.findByName(RollenEnum.BENUTZER.name()))));
		}
		Organisation organisation = null;
		if (parts.length > 1) {
			organisation = organisationSrv.findOrganisationById(UUID.fromString(parts[1]));
		} else {
			organisation = organisationSrv.findOrganisationByName("ZTV");
		}

		Collection<Rolle> roles = OrganisationLinkHelper.getRollenForOrganisation(person.getOrganisationenLinks(),
				organisation);

		return new org.springframework.security.core.userdetails.User(person.getBenutzername(), person.getPassword(),
				person.isAktiv(), true, true, true, getAuthorities(roles));
	}

	private Collection<? extends GrantedAuthority> getAuthorities(Collection<Rolle> roles) {

		return getGrantedAuthorities(getPrivileges(roles));
	}

	private List<String> getPrivileges(Collection<Rolle> roles) {

		List<String> privileges = new ArrayList<>();
		if (roles != null) {
			for (Rolle role : roles) {
				privileges.add(role.getName());
			}
		}
		return privileges;
	}

	private List<GrantedAuthority> getGrantedAuthorities(List<String> privileges) {
		List<GrantedAuthority> authorities = new ArrayList<>();
		for (String privilege : privileges) {
			authorities.add(new SimpleGrantedAuthority(privilege));
		}
		return authorities;
	}
}
