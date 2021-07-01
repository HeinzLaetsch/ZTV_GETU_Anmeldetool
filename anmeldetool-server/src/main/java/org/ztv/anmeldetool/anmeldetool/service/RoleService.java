package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationPersonLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.RollenRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;

@Service("roleService")
public class RoleService {
	@Autowired
	RollenRepository rollenRep;
	
	@Autowired
	OrganisationService orgService;
	
	@Autowired
	PersonService personenService;
	
	@Autowired
	OrganisationPersonLinkRepository oplRepo;
	
	public Rolle findByName(String name) {
		return rollenRep.findByName(name);
	}

	public ResponseEntity<Collection<RolleDTO>> findAll() {
		Iterable<Rolle> rollen = rollenRep.findAll(); 
		Collection<RolleDTO> rollenDTO = new ArrayList<RolleDTO>();
		for (Rolle rolle : rollen) {
			rollenDTO.add(RolleDTO.builder().id(rolle.getId().toString()).name(rolle.getName()).beschreibung(rolle.getBeschreibung()).build());
		}
		return ResponseEntity.ok(rollenDTO);
	}
	
	public ResponseEntity findAllForUser(String vereinsId, String userId) {
		Organisation org = orgService.findOrganisationById(UUID.fromString(vereinsId));
		if (org == null) {
			return ResponseEntity.notFound().build();
		}
		Person person = personenService.findPersonById(UUID.fromString(userId));
		Iterable<OrganisationPersonLink> opls = oplRepo.findByOrganisationAndPerson(org, person);
		Collection<RolleDTO> rollenDTO = new ArrayList<RolleDTO>();
		for (OrganisationPersonLink opl : opls) {
			for (RollenLink rl : opl.getRollenLink()) {
				rollenDTO.add(RolleDTO.builder().id(rl.getId().toString()).name(rl.getRolle().getName()).beschreibung(rl.getRolle().getBeschreibung()).aktiv(rl.isAktiv()).build());				
			}
		}
		return ResponseEntity.ok(rollenDTO);
	}
}
