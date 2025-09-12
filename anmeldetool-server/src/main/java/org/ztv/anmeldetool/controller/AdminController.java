package org.ztv.anmeldetool.controller;

import jakarta.servlet.http.HttpServletRequest;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Collection;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
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
import org.springframework.web.bind.annotation.RestController;
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.LoginService;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.service.VerbandService;
import org.ztv.anmeldetool.service.WertungsrichterService;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.transfer.VerbandDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterDTO;

@RestController
@RequestMapping("/admin")
@Slf4j
@RequiredArgsConstructor
public class AdminController {

  private final LoginService loginSrv;
  private final PersonService personSrv;
  private final RoleService roleSrv;
  private final OrganisationService organisationSrv;
  private final VerbandService verbandsSrv;
  private final WertungsrichterService wertungsrichterSrv;
  private final AnlassService anlassSrv;
  private final TeilnehmerService teilnehmerSrv;

  @PostMapping("/login")
  public ResponseEntity<PersonDTO> login(HttpServletRequest request, @RequestBody LoginData loginData) {
    log.info("Login attempt");
    return loginSrv.login(request, loginData);
  }

  @GetMapping("/organisationen")
  public ResponseEntity<Collection<OrganisationDTO>> getOrganisationen() {
    return ResponseEntity.ok(organisationSrv.getAllOrganisations());
  }

  @PostMapping("/organisationen")
  public ResponseEntity<OrganisationDTO> createOrganisation(@RequestBody OrganisationDTO organisation) {
    return ResponseEntity.ok(organisationSrv.create(organisation));
  }

  @GetMapping("/organisationen/{orgId}/teilnehmer")
  public ResponseEntity<Collection<TeilnehmerDTO>> getTeilnehmer(@PathVariable UUID orgId,
      @RequestParam int page, @RequestParam int size) {
    Pageable pageable = PageRequest.of(page, size);
    return teilnehmerSrv.findTeilnehmerDtoByOrganisation(orgId, pageable);
  }

  @GetMapping("/organisationen/{orgId}/teilnehmer/count")
  public ResponseEntity<Integer> countTeilnehmer(@PathVariable UUID orgId) {
    return teilnehmerSrv.countTeilnehmerByOrganisation(orgId);
  }

  @PostMapping("/organisationen/{orgId}/teilnehmer")
  public ResponseEntity<TeilnehmerDTO> addNewTeilnehmer(@PathVariable UUID orgId,
      @RequestBody TeilnehmerDTO teilnehmerDTO) {
    return teilnehmerSrv.create(orgId, teilnehmerDTO);
  }

  @PatchMapping("/organisationen/{orgId}/teilnehmer")
  public ResponseEntity<TeilnehmerDTO> updateTeilnehmer(@PathVariable UUID orgId,
      @RequestBody TeilnehmerDTO teilnehmerDTO) {
    return ResponseEntity.ok(teilnehmerSrv.update(orgId, teilnehmerDTO));
  }

  @DeleteMapping("/organisationen/{orgId}/teilnehmer/{teilnehmerId}")
  public ResponseEntity<Void> deleteTeilnehmer(@PathVariable UUID orgId,
      @PathVariable UUID teilnehmerId) {
    teilnehmerSrv.delete(orgId, teilnehmerId);
    return ResponseEntity.noContent().build();
  }

  @GetMapping("/organisationen/{orgId}/starts")
  public ResponseEntity<Collection<OrganisationAnlassLinkDTO>> getStarts(@PathVariable UUID orgId) {
    return ResponseEntity.ok(organisationSrv.getStarts(orgId));
  }

  @GetMapping("/verbaende")
  public ResponseEntity<Collection<VerbandDTO>> getVerbaende() {
    return verbandsSrv.getVerbaende();
  }

  @PutMapping("/user/{userId}")
  public ResponseEntity<PersonDTO> putUser(@RequestHeader("vereinsid") UUID vereinsId,@PathVariable UUID userId,
      @RequestBody PersonDTO personDTO) {
    log.info("Patching user");
    return ResponseEntity.ok(personSrv.update(userId, personDTO, vereinsId));
  }

  @PostMapping("/user")
  public ResponseEntity<PersonDTO> createUser(@RequestHeader("vereinsid") UUID vereinsId,
      @RequestBody PersonDTO personDTO) throws URISyntaxException {
    log.info("Creating user");
    URI location =  new URI("/admin/user" + personDTO.getId().toString());
    return ResponseEntity.created(location).body(personDTO);
  }

  @PutMapping("/user/{userId}/organisationen/{organisationsId}/rollen")
  public ResponseEntity<PersonDTO> updateUserRoles(@PathVariable String userId,
      @PathVariable String organisationsId, @RequestBody Set<RolleDTO> rollenDTO) {
    return ResponseEntity.ok(personSrv.updateUserOrganisationRollen(userId, organisationsId, rollenDTO));
  }

  @GetMapping("/user")
  public ResponseEntity<Collection<PersonDTO>> getUsersInOrganisation(
      @RequestHeader("vereinsid") UUID vereinsId) {
    return ResponseEntity.ok(personSrv.findPersonsByOrganisation(vereinsId));
  }

  @GetMapping("/user/benutzernamen/{benutzername}")
  public ResponseEntity<PersonDTO> getPersonByBenutzername(
      @PathVariable("benutzername") String benutzername) {
    return ResponseEntity.ok(personSrv.findPersonDtoByBenutzername(benutzername));
  }

  @GetMapping("/role")
  public ResponseEntity<Collection<RolleDTO>> getRoles(
      @RequestHeader("vereinsid") String vereinsId,
      @RequestParam Optional<String> userId) {
    return ResponseEntity.ok(roleSrv.findRolesForUser(vereinsId, userId));
  }

  @GetMapping("/user/{id}/wertungsrichter")
  public ResponseEntity<WertungsrichterDTO> getWertungsrichterForUser(@PathVariable UUID id) {
    return ResponseEntity.ok(wertungsrichterSrv.getWertungsrichterDtoByPersonId(id));
  }

  @PutMapping("/user/{id}/wertungsrichter")
  public ResponseEntity<WertungsrichterDTO> updateWertungsrichter(@PathVariable UUID id,
      @RequestBody WertungsrichterDTO wertungsrichterDTO) {
    return ResponseEntity.ok(wertungsrichterSrv.updateWertungsrichter(id, wertungsrichterDTO));
  }

  @DeleteMapping("/user/{id}/wertungsrichter")
  public ResponseEntity<Void> deleteWertungsrichter(@PathVariable UUID id) {
    wertungsrichterSrv.deleteWertungsrichterByPersonId(id);
    return ResponseEntity.noContent().build();
  }
}
