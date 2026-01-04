package org.ztv.anmeldetool.controller;

import java.util.Collection;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.TeilnahmenService;
import org.ztv.anmeldetool.transfer.OrganisationTeilnahmenStatistikDTO;
import org.ztv.anmeldetool.transfer.TeilnahmenDTO;

@RestController
@RequestMapping("/admin/teilnahmen")
@Slf4j
@RequiredArgsConstructor
public class TeilnahmenController {

  private final TeilnahmenService teilnahmenSrv;
  private final OrganisationService organisationSrv;


  // TODO move to other service
  @GetMapping("/{jahr}/organisationen/{orgId}")
  public ResponseEntity<Collection<OrganisationTeilnahmenStatistikDTO>> getOrganisationTeilnahmenStatistik(
      @PathVariable int jahr, @PathVariable UUID orgId) {
    // The service should throw EntityNotFoundException if the organisation doesn't exist.
    // Returning an empty list is the correct RESTful response if the organisation exists but has no statistics.
    Organisation organisation = organisationSrv.findById(orgId);
    Collection<OrganisationTeilnahmenStatistikDTO> statistik = teilnahmenSrv.getAnlassorganisationStati(
        jahr, organisation);
    return ResponseEntity.ok(statistik);
  }

  // TODO move to other service
  @PutMapping("/{jahr}/organisationen/{orgId}/teilnahmen/{teilnehmerId}")
  public ResponseEntity<TeilnahmenDTO> updateTeilnahmen(@PathVariable int jahr,
      @PathVariable UUID orgId, @PathVariable UUID teilnehmerId,
      @RequestBody TeilnahmenDTO teilnahmenDto) {
    // The service will throw an EntityNotFoundException if a resource is not found,
    // which will be handled by the global RestExceptionHandler.
    Organisation organisation = organisationSrv.findById(orgId);
    TeilnahmenDTO updatedDto = teilnahmenSrv.updateTeilnahmen(jahr, organisation, teilnahmenDto);
    return ResponseEntity.ok(updatedDto);
  }

  // TODO move to other service
  @GetMapping("/{jahr}/organisationen/{orgId}/teilnahmen/")
  public ResponseEntity<List<TeilnahmenDTO>> getTeilnahmen(@PathVariable int jahr,
      @PathVariable UUID orgId) {
    // The service should throw EntityNotFoundException if the organisation doesn't exist.
    // Returning an empty list is the correct RESTful response if the organisation exists but has no teilnahmen.
    Organisation organisation = organisationSrv.findById(orgId);
    List<TeilnahmenDTO> teilnahmen = teilnahmenSrv.getTeilnahmen(jahr, organisation, true);
    return ResponseEntity.ok(teilnahmen);
  }
}
