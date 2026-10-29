package org.ztv.anmeldetool.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.models.LoginResult;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.security.JwtUtil;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.util.PersonMapper;

@Service("loginService")
@RequiredArgsConstructor
public class LoginService {

  private final AuthenticationManager authenticationManager;
  private final PersonService personSrv;
  private final PersonMapper personMapper;
  private final JwtUtil jwtUtil;

  public LoginResult login(LoginData loginData) {
    String combinedUsername = LoginData.getCombinedUsername(loginData.getUsername(), loginData.getOrganisationId());
    Authentication authentication = authenticationManager.authenticate(
        new UsernamePasswordAuthenticationToken(combinedUsername, loginData.getPassword()));

    UserDetails userDetails = (UserDetails) authentication.getPrincipal();
    Person person = personSrv.findPersonByBenutzername(loginData.getUsername());
    PersonDTO personDto = personMapper.toDto(person, loginData.getOrganisationId());
    return new LoginResult(personDto, jwtUtil.generateToken(userDetails));
  }

}
