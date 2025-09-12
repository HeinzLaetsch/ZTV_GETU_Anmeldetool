package org.ztv.anmeldetool.service;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.util.OrganisationMapper;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 *
 * @author heinz
 */
@Service("organisationService")
@Slf4j
@AllArgsConstructor
public class OrganisationService {

	private static final List<String> ZUERCHER_VERBAND_KUERZEL = List.of("GLZ", "WTU", "AZO", "ZTV");

	private final OrganisationsRepository orgRepo;
	private final VerbandService verbandSrv;
	private final OrganisationMapper organisationMapper;

	public Collection<OrganisationDTO> getAllOrganisations() {
		Collection<Organisation> orgs = orgRepo.findByAktivOrderByName(true);
		return organisationMapper.toDtoList(orgs);
	}

	public List<Organisation> getAllZuercherOrganisationen() {
		List<Verband> zhVerbaende = ZUERCHER_VERBAND_KUERZEL.stream()
				.map(verbandSrv::findByVerbandsKuerzel)
				.toList();
		return orgRepo.findZuercherOrganisationen(zhVerbaende);
	}

	public Organisation findOrganisationByName(String organisationName) {
		return orgRepo.findByName(organisationName).orElseThrow(() -> new NotFoundException(Organisation.class, organisationName));
	}

	public Organisation findOrganisationById(UUID organisationId) {
		return orgRepo.findById(organisationId)
				.orElseThrow(() -> new NotFoundException(Organisation.class, organisationId));
	}

	public OrganisationDTO create(OrganisationDTO organisationDTO) {
		Verband verband = verbandSrv.getVerband(organisationDTO.getVerbandId());
		Organisation organisation = organisationMapper.toEntity(organisationDTO, verband);
		Organisation savedOrganisation = orgRepo.save(organisation);
		return organisationMapper.toDto(savedOrganisation);
	}
}
