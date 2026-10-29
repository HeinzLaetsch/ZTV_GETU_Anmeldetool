package org.ztv.anmeldetool.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.models.LoginResult;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.security.JwtUtil;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.util.PersonMapper;

@ExtendWith(MockitoExtension.class)
class LoginServiceTest {

    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private PersonService personService;

    @Mock
    private PersonMapper personMapper;

    @Mock
    private JwtUtil jwtUtil;

    @InjectMocks
    private LoginService loginService;

    @Test
    void authenticatesWithCombinedUsernameAndReturnsUserAndToken() {
        UUID organisationId = UUID.randomUUID();
        String combinedUsername = "turner@example.ch#" + organisationId;
        LoginData loginData = new LoginData();
        loginData.setUsername("turner@example.ch");
        loginData.setOrganisationId(organisationId);
        loginData.setPassword("test-password");
        Person person = new Person();
        PersonDTO expectedDto = org.mockito.Mockito.mock(PersonDTO.class);
        UserDetails userDetails = User.withUsername(combinedUsername)
                .password("{bcrypt}encoded-password")
                .authorities("ANMELDER")
                .build();
        Authentication authenticated = UsernamePasswordAuthenticationToken.authenticated(
                userDetails, null, userDetails.getAuthorities());
        when(authenticationManager.authenticate(any(Authentication.class))).thenReturn(authenticated);
        when(personService.findPersonByBenutzername(loginData.getUsername())).thenReturn(person);
        when(personMapper.toDto(person, organisationId)).thenReturn(expectedDto);
        when(jwtUtil.generateToken(userDetails)).thenReturn("signed-token");

        LoginResult result = loginService.login(loginData);

        ArgumentCaptor<Authentication> authenticationCaptor = ArgumentCaptor.forClass(Authentication.class);
        verify(authenticationManager).authenticate(authenticationCaptor.capture());
        UsernamePasswordAuthenticationToken authentication =
                (UsernamePasswordAuthenticationToken) authenticationCaptor.getValue();
        assertEquals(combinedUsername, authentication.getPrincipal());
        assertEquals("test-password", authentication.getCredentials());
        assertSame(expectedDto, result.user());
        assertEquals("signed-token", result.token());
        verify(jwtUtil).generateToken(userDetails);
    }

    @Test
    void authenticationUsesOrganizationScopedRolesFromAuthenticatedPrincipal() {
        UUID organisationId = UUID.randomUUID();
        LoginData loginData = new LoginData();
        loginData.setUsername("turner@example.ch");
        loginData.setOrganisationId(organisationId);
        loginData.setPassword("test-password");
        Person person = new Person();
        UserDetails userDetails = User.withUsername(LoginData.getCombinedUsername(loginData.getUsername(), organisationId))
                .password("encoded")
                .authorities("ANMELDER")
                .build();
        when(authenticationManager.authenticate(any(Authentication.class)))
                .thenReturn(UsernamePasswordAuthenticationToken.authenticated(
                        userDetails, null, userDetails.getAuthorities()));
        when(personService.findPersonByBenutzername(loginData.getUsername())).thenReturn(person);
        when(personMapper.toDto(person, organisationId)).thenReturn(org.mockito.Mockito.mock(PersonDTO.class));

        loginService.login(loginData);

        verify(jwtUtil).generateToken(userDetails);
        assertEquals(List.of("ANMELDER"), userDetails.getAuthorities().stream()
                .map(authority -> authority.getAuthority())
                .toList());
    }
}
