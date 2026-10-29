package org.ztv.anmeldetool.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
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
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.repositories.PersonenRepository;
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

    @Override
    public UserDetails loadUserByUsername(String combinedUsername) throws UsernameNotFoundException {
        String[] usernameParts = LoginData.splitCombinedUsername(combinedUsername);
        Optional<Person> personOpt = personenRepository.findByBenutzernameIgnoreCase(usernameParts[0]);
        if (personOpt.isEmpty()) {
            log.warn("User not found: {}", usernameParts[0]);
            throw new UsernameNotFoundException("User not found: " + usernameParts[0]);
        }

        Person person = personOpt.get();
        if (!person.isAktiv()) {
            log.warn("User is not active: {}", usernameParts[0]);
            throw new UsernameNotFoundException("User is not active: " + usernameParts[0]);
        }

        Organisation organisation;
        try {
            organisation = usernameParts.length > 1
                    ? organisationSrv.findById(UUID.fromString(usernameParts[1]))
                    : organisationSrv.findOrganisationByName("ZTV");
        } catch (IllegalArgumentException | NotFoundException exception) {
            throw new UsernameNotFoundException("Invalid organisation for user: " + usernameParts[0], exception);
        }
        if (!person.isPersonMemberOfOrganisation(organisation)) {
            throw new UsernameNotFoundException("User is not a member of the requested organisation");
        }
        Collection<Rolle> roles = OrganisationLinkHelper.getRollenForOrganisation(person.getOrganisationenLinks(),
                organisation);

        return new org.springframework.security.core.userdetails.User(
            combinedUsername,
            person.getPassword(),
            person.isAktiv(),
            true,
            true,
            true,
            getAuthorities(roles)
        );
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
