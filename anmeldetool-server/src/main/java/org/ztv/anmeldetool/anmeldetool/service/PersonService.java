package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationPersonLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.RollenLinkRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.anmeldetool.util.PersonHelper;

import lombok.extern.slf4j.Slf4j;

@Service("personService")
@Slf4j
public class PersonService {

	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	OrganisationService organisationSrv;

	@Autowired
	RoleService roleSrv;

	@Autowired
	PersonenRepository persRepo;

	@Autowired
	RollenLinkRepository rollenLinkRep;

	@Autowired
	OrganisationPersonLinkRepository orgPersLinkRep;

	public Collection<PersonDTO> findPersonsByOrganisation(UUID orgId) {
		Collection<Person> persons = persRepo.findByOrganisationId(orgId);
		List<PersonDTO> personDTOs = new ArrayList<PersonDTO>();
		for (Person person : persons) {
			personDTOs.add(PersonHelper.createPersonDTO(person));
		}
		return personDTOs;
	}

	public Person findPersonById(UUID id) {
		Optional<Person> personOptional = persRepo.findById(id);
		if (personOptional.isEmpty()) {
			return null;
		}
		return personOptional.get();
	}

	public Person findPersonByBenutzername(String username) {
		Person person = persRepo.findByBenutzernameIgnoreCase(username.toLowerCase());
		return person;
	}

	public Person create(Person person, boolean createPW) {
		if (createPW && person.getPassword() != null && person.getPassword().length() > 0) {
			person.setPassword(getEncodedPassword(person.getPassword()));
		}
		return persRepo.save(person);
	}

	public ResponseEntity<PersonDTO> update(PersonDTO personDTO, UUID organisationsId) {
		Organisation organisation = organisationSrv.findOrganisationById(organisationsId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		Optional<Person> personOptional = persRepo.findById(personDTO.getId());
		if (personOptional.isEmpty()) {
			return ResponseEntity.notFound().build();
		}
		Person person2 = PersonHelper.createPerson(personDTO);

		Person person = personOptional.get();
		person.setAktiv(person2.isAktiv());
		person.setBenutzername(person2.getBenutzername());
		person.setChangeDate(Calendar.getInstance());
		person.setEmail(person2.getEmail());
		person.setHandy(person2.getHandy());
		person.setName(person2.getName());
		person.setVorname(person2.getVorname());
		boolean createPW = true;
		if (personDTO.getPassword() == null || personDTO.getPassword().length() == 0) {
			createPW = false;
		} else {
			person.setPassword(personDTO.getPassword());
		}

		person = create(person, createPW);
		personDTO = PersonHelper.createPersonDTO(person, organisation);
		return ResponseEntity.ok(personDTO);
	}

	public ResponseEntity<PersonDTO> create(PersonDTO personDTO, UUID organisationsId) {
		if (persRepo.findById(personDTO.getId()).isPresent()) {
			// Existiert momentan nur Merge
			log.warn("User existiert: {} , {} , {} , {}", personDTO.getId(), personDTO.getEmail(), personDTO.getName(),
					personDTO.getVorname());
			return update(personDTO, organisationsId);
		}
		Organisation organisation = null;
		if (organisationsId == null && personDTO.getOrganisationids().size() > 0) {
			organisation = organisationSrv.findOrganisationById(personDTO.getOrganisationids().get(0));
		} else {
			organisation = organisationSrv.findOrganisationById(organisationsId);
		}
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		OrganisationPersonLink orgPersLink = new OrganisationPersonLink();

		Person person = PersonHelper.createPerson(personDTO);
		person = create(person, true);

		orgPersLink.setAktiv(true);
		orgPersLink.setOrganisation(organisation);
		orgPersLink.setPerson(person);
		orgPersLinkRep.save(orgPersLink);

		Set<RolleDTO> rollenDTO = personDTO.getRollen();
		populateLinkRollen(orgPersLink, rollenDTO);
		// Persist
		orgPersLink.getRollenLink().stream().forEach(rollenLink -> {
			rollenLinkRep.save(rollenLink);
		});

		person.getOrganisationenLinks().add(orgPersLink);
		personDTO = PersonHelper.createPersonDTO(person, organisation);
		return ResponseEntity.ok(personDTO);
	}

	public ResponseEntity<PersonDTO> updateUserOrganisationRollen(String userId, String organisationId,
			Set<RolleDTO> rollenDTO) {
		Organisation organisation = organisationSrv.findOrganisationById(UUID.fromString(organisationId));
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		Optional<Person> personOptional = persRepo.findById(UUID.fromString(userId));
		if (personOptional.isEmpty()) {
			return ResponseEntity.notFound().build();
		}
		Person person = personOptional.get();
		if (person.getOrganisationenLinks() == null) {
			return ResponseEntity.notFound().build();
		}
		List<OrganisationPersonLink> filteredOpl = person.getOrganisationenLinks().stream().filter(opl -> {
			return opl.getOrganisation().equals(organisation);
		}).collect(Collectors.toList());
		if (filteredOpl.size() != 1) {
			// error
		}
		Set<RollenLink> rollenSet = filteredOpl.get(0).getRollenLink();
		// check Delete
		Set<RollenLink> deletedRollen = new HashSet();
		for (RollenLink rl : rollenSet) {
			List<RolleDTO> filtered = rollenDTO.stream().filter(rolleDTO -> {
				return rl.getId().toString().equals(rolleDTO.getId());
			}).collect(Collectors.toList());
			if (filtered.size() == 0) {
				rollenLinkRep.delete(rl);
				deletedRollen.add(rl);
			}
		}
		// Clean up Set
		deletedRollen.stream().forEach(deleteLink -> {
			rollenSet.remove(deleteLink);
		});
		// Check Create
		for (RolleDTO rolleDTO : rollenDTO) {
			List<RollenLink> filtered = rollenSet.stream().filter(rolleLink -> {
				return rolleDTO.getId().equals(rolleLink.getId().toString());
			}).collect(Collectors.toList());
			if (filtered.size() == 0) {
				RollenLink rl = new RollenLink();
				rl.setChangeDate(Calendar.getInstance());
				rl.setAktiv(rolleDTO.isAktiv());
				rl.setDeleted(false);
				rl.setId(UUID.randomUUID());
				rl.setLink(filteredOpl.get(0));
				Rolle rolle = roleSrv.findByName(rolleDTO.getName());
				rl.setRolle(rolle);
				rollenLinkRep.save(rl);
				filteredOpl.get(0).getRollenLink().add(rl);
			} else {
				RollenLink rl = filtered.get(0);
				if (rl.isAktiv() != rolleDTO.isAktiv()) {
					rl.setAktiv(rolleDTO.isAktiv());
					rollenLinkRep.save(rl);
				}
			}
		}
		person = create(person, false);
		PersonDTO personDTO = PersonHelper.createPersonDTO(person, organisation);
		return ResponseEntity.ok(personDTO);
	}

	public void populateLinkRollen(OrganisationPersonLink orgPersLink, Set<RolleDTO> rollenDTO) {
		for (RolleDTO rolleDTO : rollenDTO) {
			Rolle rolle = roleSrv.findByName(rolleDTO.getName());
			RollenLink rollenLink = new RollenLink();
			if (rollenDTO.size() == 1 && RollenEnum.ANMELDER.equals(rolle.getName()))
				rollenLink.setAktiv(false);
			else
				rollenLink.setAktiv(true);
			rollenLink.setLink(orgPersLink);
			rollenLink.setRolle(rolle);
			orgPersLink.getRollenLink().add(rollenLink);
		}
	}

	public String getEncodedPassword(String password) {
		log.debug("passwordEncoder: " + passwordEncoder.toString() + " ,work: " + password);
		return passwordEncoder.encode(password);
	}
}
