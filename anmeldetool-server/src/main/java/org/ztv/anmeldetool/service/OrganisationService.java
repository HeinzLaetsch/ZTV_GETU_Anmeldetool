package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.util.OrganisationHelper;

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

	public ResponseEntity<Collection<OrganisationDTO>> getAllOrganisations() {
		Collection<OrganisationDTO> orgsDto = new ArrayList<OrganisationDTO>();
		Iterable<Organisation> orgs = orgRepo.findByAktivOrderByName(true);
		for (Organisation org : orgs) {
			log.debug("Organisation: " + orgs);
			orgsDto.add(OrganisationHelper.createOrganisationDTO(org));
		}
		return ResponseEntity.ok(orgsDto);
	}

	public List<Organisation> getAllZuercherOrganisationen() {
		List<Verband> zh_verbaende = new ArrayList<Verband>();
		zh_verbaende.add(verbandSrv.findByVerbandsKuerzel("GLZ"));
		zh_verbaende.add(verbandSrv.findByVerbandsKuerzel("WTU"));
		zh_verbaende.add(verbandSrv.findByVerbandsKuerzel("AZO"));
		zh_verbaende.add(verbandSrv.findByVerbandsKuerzel("ZTV"));

		List<Organisation> orgs = orgRepo.findZuercherOrganisationen(zh_verbaende);
		return orgs;
	}

	public Organisation findOrganisationByName(String organisationName) {
		return orgRepo.findByName(organisationName);
	}

	public Organisation findOrganisationById(UUID organisationId) {
		Optional<Organisation> optOrg = orgRepo.findById(organisationId);
		return optOrg.get();
	}

	public ResponseEntity<OrganisationDTO> create(OrganisationDTO organisationDTO) {
		Verband verband = verbandSrv.getVerband(organisationDTO.getVerbandId());
		Organisation organisation = OrganisationHelper.createOrganisation(organisationDTO, verband);
		organisation = orgRepo.save(organisation);
		return ResponseEntity.ok(OrganisationHelper.createOrganisationDTO(organisation));
	}
}
