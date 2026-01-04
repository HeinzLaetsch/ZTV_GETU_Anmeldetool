package org.ztv.anmeldetool.service;

import jakarta.transaction.Transactional;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
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
@RequiredArgsConstructor
public class RoleService {
	private final RollenRepository rollenRep;
	private final RolleMapper rolleMapper;

	public Rolle findByName(String name) {
		return rollenRep.findByName(name).orElseThrow(() -> new NotFoundException(Rolle.class, name));
	}

	@Transactional()
	public List<RolleDTO> findAll() {
		List<Rolle> rollen = rollenRep.findAll();
		return rolleMapper.toDtoList(rollen);
	}
}
