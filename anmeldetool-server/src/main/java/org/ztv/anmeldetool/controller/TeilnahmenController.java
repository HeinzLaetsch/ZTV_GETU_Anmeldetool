package org.ztv.anmeldetool.controller;

import java.net.URI;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.ztv.anmeldetool.exception.EntityNotFoundException;
import org.ztv.anmeldetool.service.TeilnahmenService;
import org.ztv.anmeldetool.transfer.OrganisationTeilnahmenStatistikDTO;
import org.ztv.anmeldetool.transfer.TeilnahmenDTO;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/admin/teilnahmen")
@Slf4j
@CrossOrigin(origins = "*", allowedHeaders = "*", allowCredentials = "true")
public class TeilnahmenController {

	@Autowired
	TeilnahmenService teilnahmenSrv;

	// TODO move to other service
	@GetMapping("/{jahr}/organisationen/{orgId}")
	public ResponseEntity<Collection<OrganisationTeilnahmenStatistikDTO>> getOrganisationTeilnahmenStatistik(
			HttpServletRequest request, @PathVariable int jahr, @PathVariable UUID orgId) {

		Collection<OrganisationTeilnahmenStatistikDTO> aot = teilnahmenSrv.getAnlassorganisationStati(jahr, orgId);

		if (aot == null) {
			return getNotFound();
		}
		return ResponseEntity.ok(aot);
	}

	// TODO move to other service
	@PutMapping("/{jahr}/organisationen/{orgId}/teilnahmen/{teilnehmerId}")
	public ResponseEntity<TeilnahmenDTO> updateTeilnahmen(HttpServletRequest request, @PathVariable int jahr,
			@PathVariable UUID orgId, @PathVariable UUID teilnehmerId, @RequestBody TeilnahmenDTO teilnahmenDto)
			throws EntityNotFoundException {
		teilnahmenDto = teilnahmenSrv.updateTeilnahmen(jahr, orgId, teilnahmenDto);
		return ResponseEntity.ok(teilnahmenDto);
	}

	// TODO move to other service
	@GetMapping("/{jahr}/organisationen/{orgId}/teilnahmen/")
	public ResponseEntity<List<TeilnahmenDTO>> getTeilnahmen(HttpServletRequest request, @PathVariable int jahr,
			@PathVariable UUID orgId) {

		List<TeilnahmenDTO> aot = teilnahmenSrv.getTeilnahmen(jahr, orgId, true);

		if (aot == null) {
			return getNotFound();
		}
		return ResponseEntity.ok(aot);
	}

	private <T> ResponseEntity<T> getNotFound() {
		URI requestURI = ServletUriComponentsBuilder.fromCurrentRequest().build().toUri();
		return ResponseEntity.notFound().location(requestURI).build();
	}

	@ExceptionHandler(EntityNotFoundException.class)
	public ResponseEntity<?> handlerEntityNotFound(EntityNotFoundException ex) {
		this.log.warn(ex.getMessage());

		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
	}

	@ExceptionHandler(Exception.class)
	public ResponseEntity<?> handlerException(Exception ex) {
		log.warn("Call failed", ex);

		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
	}

}
