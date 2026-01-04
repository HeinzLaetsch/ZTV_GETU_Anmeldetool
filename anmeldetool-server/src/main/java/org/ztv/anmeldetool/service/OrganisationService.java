package org.ztv.anmeldetool.service;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Anlass;
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
public class OrganisationService extends AbstractBaseService<Organisation> {

	private static final List<String> ZUERCHER_VERBAND_KUERZEL = List.of("GLZ", "WTU", "AZO", "ZTV");

	private final OrganisationsRepository orgRepo;
	private final VerbandService verbandSrv;
	private final OrganisationMapper organisationMapper;

  @Override
  @Transactional(readOnly = true)
  public Organisation findById(UUID id) {
     return orgRepo.findById(id).orElseThrow(() -> new NotFoundException(Organisation.class, id));
  }

  @Transactional(readOnly = true)
	public Collection<OrganisationDTO> getAllOrganisations() {
		Collection<Organisation> orgs = orgRepo.findByAktivOrderByName(true);
		return organisationMapper.toDtoList(orgs);
	}

  @Transactional(readOnly = true)
	public List<Organisation> getAllZuercherOrganisationen() {
		List<Verband> zhVerbaende = ZUERCHER_VERBAND_KUERZEL.stream()
				.map(verbandSrv::findByVerbandsKuerzel)
				.toList();
		return orgRepo.findZuercherOrganisationen(zhVerbaende);
	}

  @Transactional(readOnly = true)
	public Organisation findOrganisationByName(String organisationName) {
		return orgRepo.findByName(organisationName).orElseThrow(() -> new NotFoundException(Organisation.class, organisationName));
	}

  @Transactional
	public OrganisationDTO create(OrganisationDTO organisationDTO) {
		Verband verband = verbandSrv.getVerband(organisationDTO.getVerbandId());
		Organisation organisation = organisationMapper.toEntity(organisationDTO, verband);
		Organisation savedOrganisation = orgRepo.save(organisation);
		return organisationMapper.toDto(savedOrganisation);
	}
}
