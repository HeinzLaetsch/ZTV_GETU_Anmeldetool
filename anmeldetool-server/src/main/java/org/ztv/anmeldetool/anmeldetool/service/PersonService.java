package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

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
import org.ztv.anmeldetool.anmeldetool.repositories.PersonenRepository;
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

	public Collection<PersonDTO> findPersonsByOrganisation(UUID orgId) {
		Collection<Person> persons = persRepo.findByOrganisationId(orgId);
		List<PersonDTO> personDTOs = new ArrayList<PersonDTO>();
		for (Person person : persons) {
			personDTOs.add(PersonHelper.createPersonDTO(person, orgId));
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
		Person person = persRepo.findByBenutzername(username.toLowerCase());
		return person;
	}

	public Person create(Person person, boolean createPW) {
		if (createPW && person.getPassword() != null && person.getPassword().length() > 0) {
			person.setPassword(getEncodedPassword(person.getPassword()));
		}
		return persRepo.save(person);
	}

	public ResponseEntity<PersonDTO> update(PersonDTO personDTO) {
		Organisation organisation = organisationSrv.findOrganisationById(personDTO.getOrganisationid());
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
		}

		person = create(person, createPW);
		personDTO = PersonHelper.createPersonDTO(person, organisation);
		return ResponseEntity.ok(personDTO);
	}

	public ResponseEntity<PersonDTO> create(PersonDTO personDTO) {
		Organisation organisation = organisationSrv.findOrganisationById(personDTO.getOrganisationid());
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		OrganisationPersonLink orgPersLink = new OrganisationPersonLink();
		Set<RolleDTO> rollenDTO = personDTO.getRollen();
		populateLinkRollen(orgPersLink, rollenDTO);
		/*
		 * for(RolleDTO rolleDTO : rollenDTO) { Rolle rolle =
		 * roleSrv.findByName(rolleDTO.getName()); RollenLink rollenLink = new
		 * RollenLink(); rollenLink.setAktiv(true); rollenLink.setLink(orgPersLink);
		 * rollenLink.setRolle(rolle); orgPersLink.getRollenLink().add(rollenLink); }
		 */
		Person person = PersonHelper.createPerson(personDTO);

		orgPersLink.setAktiv(true);
		orgPersLink.setOrganisation(organisation);
		orgPersLink.setPerson(person);

		person.getOrganisationenLinks().add(orgPersLink);
		person = create(person, true);
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
		for (OrganisationPersonLink opl : person.getOrganisationenLinks()) {
			if (opl.getOrganisation().equals(organisation)) {
				for (RolleDTO rolleDTO : rollenDTO) {
					boolean found = false;
					for (RollenLink rl : opl.getRollenLink()) {
						if (rl.getId().toString().equals(rolleDTO.getId())) {
							found = true;
							rl.setChangeDate(Calendar.getInstance());
							rl.setAktiv(rolleDTO.isAktiv());

						}
					}
					if (!found) {
						RollenLink rl = new RollenLink();
						rl.setChangeDate(Calendar.getInstance());
						rl.setAktiv(rolleDTO.isAktiv());
						rl.setDeleted(false);
						rl.setId(UUID.randomUUID());
						rl.setLink(opl);
						Rolle rolle = roleSrv.findByName(rolleDTO.getName());
						rl.setRolle(rolle);
						opl.getRollenLink().add(rl);
					}
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
