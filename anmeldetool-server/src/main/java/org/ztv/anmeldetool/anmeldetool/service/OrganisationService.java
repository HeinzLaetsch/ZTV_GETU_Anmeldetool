package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.Verband;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;
import org.ztv.anmeldetool.anmeldetool.util.OrganisationHelper;

import lombok.extern.slf4j.Slf4j;
/**
 * 
 * @author heinz
 */
@Service("organisationService")
@Slf4j
public class OrganisationService {

	@Autowired
	OrganisationsRepository orgRepo;
	
	@Autowired
	VerbandService verbandSrv;

	public ResponseEntity<Collection<OrganisationenDTO>> getAllOrganisations() {
		Collection<OrganisationenDTO> orgsDto = new ArrayList<OrganisationenDTO>();
		Iterable<Organisation> orgs = orgRepo.findByAktivOrderByName(true);
		for (Organisation org : orgs) {
			log.debug("Organisation: " + orgs);
			orgsDto.add(OrganisationHelper.createOrganisationDTO(org));
		}
		return ResponseEntity.ok(orgsDto);
	}
	public Organisation findOrganisationByName(String organisationName) {
		return orgRepo.findByName(organisationName);
	}	
	public Organisation findOrganisationById(UUID organisationId) {
		Optional<Organisation> optOrg = orgRepo.findById(organisationId);
		return optOrg.get();
	}
	public ResponseEntity<OrganisationenDTO> create(OrganisationenDTO organisationDTO) {
		Verband verband = verbandSrv.getVerband(organisationDTO.getVerbandId());
		Organisation organisation = OrganisationHelper.createOrganisation(organisationDTO, verband);
		organisation = orgRepo.save(organisation);
		return ResponseEntity.ok(OrganisationHelper.createOrganisationDTO(organisation));
	}	
}
