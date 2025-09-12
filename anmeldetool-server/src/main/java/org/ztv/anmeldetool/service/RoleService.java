package org.ztv.anmeldetool.service;

import java.util.Collection;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.repositories.OrganisationPersonLinkRepository;
import org.ztv.anmeldetool.repositories.RollenRepository;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.util.RolleMapper;

import lombok.AllArgsConstructor;

@Service("roleService")
@AllArgsConstructor
public class RoleService {
	private final RollenRepository rollenRep;
	private final OrganisationService orgService;
	private final OrganisationPersonLinkRepository oplRepo;
	private final RolleMapper rolleMapper;

	public Rolle findByName(String name) {
		return rollenRep.findByName(name).orElseThrow(() -> new NotFoundException(Rolle.class, name));
	}

	public List<RolleDTO> findAll() {
		List<Rolle> rollen = rollenRep.findAll();
		return rolleMapper.toDtoList(rollen);
	}

	public Collection<RolleDTO> findAllForUser(String vereinsId, Person person) {
		Organisation org = orgService.findOrganisationById(UUID.fromString(vereinsId));

		return oplRepo.findByOrganisationAndPerson(org, person)
				.stream() // Stream the Optional<OrganisationPersonLink>
				.flatMap(opl -> opl.getRollenLink().stream()) // Flatten the Set<RollenLink> into a single stream
				.map(rolleMapper::toDto) // Map each RollenLink to a RolleDTO
				.collect(Collectors.toList());
	}
}
