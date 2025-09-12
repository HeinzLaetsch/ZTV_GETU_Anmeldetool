package org.ztv.anmeldetool.service;

import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import java.util.stream.Collectors;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.exception.ConflictException;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.repositories.OrganisationPersonLinkRepository;
import org.ztv.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.repositories.RollenLinkRepository;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.util.PersonHelper;
import org.ztv.anmeldetool.util.PersonMapper;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service("personService")
@Slf4j
@AllArgsConstructor
public class PersonService {

	private final PasswordEncoder passwordEncoder;
	private final OrganisationService organisationSrv;
	private final RoleService roleSrv;
	private final PersonenRepository persRepo;
	// TODO private final RollenLinkRepository rollenLinkRep;
	private final PersonMapper personMapper;

	/**
	 * Finds all persons associated with a given organisation.
	 *
	 * @param orgId The UUID of the organisation.
	 * @return A collection of PersonDTOs.
	 */
	public Collection<PersonDTO> findPersonsByOrganisation(UUID orgId) {
		return personMapper.toDtoList(persRepo.findByOrganisationId(orgId));
	}

	public Person findPersonById(UUID id) {
		return persRepo.findById(id).orElseThrow(() -> new NotFoundException(Organisation.class, id.toString()));
	}

	public Person findPersonByBenutzername(String username) {
		return persRepo.findByBenutzernameIgnoreCase(username).orElseThrow(() -> new NotFoundException(Organisation.class, username));
	}

  public PersonDTO findPersonDtoByBenutzername(String username) {
    return personMapper.toDto(this.findPersonByBenutzername(username));
  }

	private Person savePerson(Person person, boolean encodePassword) {
		if (encodePassword && person.getPassword() != null && !person.getPassword().isEmpty()) {
			person.setPassword(getEncodedPassword(person.getPassword()));
		}
		return persRepo.save(person);
	}

	public PersonDTO update(UUID personId, PersonDTO personDTO, UUID organisationsId) throws NotFoundException {
		Organisation organisation = organisationSrv.findOrganisationById(organisationsId);

		Person person = persRepo.findById(personId)
				.orElseThrow(() -> new NotFoundException(Person.class, personId));

		personMapper.updateEntityFromDto(personDTO, person);
		boolean encodePassword = personDTO.getPassword() != null && !personDTO.getPassword().isEmpty();
		if (encodePassword) {
			person.setPassword(personDTO.getPassword());
		}

		Person updatedPerson = savePerson(person, encodePassword);
		return PersonHelper.createPersonDTO(updatedPerson, organisation);
	}

  public Person create(Person person, OrganisationPersonLink orgPersLink) {
    Person savedPerson = savePerson(person, true);
    rollenLinkRep.saveAll(orgPersLink.getRollenLink());
    savedPerson.getOrganisationenLinks().add(orgPersLink);
    return savedPerson;
  }
	public PersonDTO create(PersonDTO personDTO, UUID organisationId) {
		if (findPersonByBenutzername(personDTO.getBenutzername()) != null) {
			String message = "User with username '%s' already exists.".formatted(personDTO.getBenutzername());
			log.warn(message);
			throw new ConflictException(message);
		};

		UUID orgId = Optional.ofNullable(organisationId).or(() ->
			Optional.ofNullable(personDTO.getOrganisationids()).stream().flatMap(Collection::stream).findFirst()
		).orElseThrow(() -> new NotFoundException(Organisation.class,
        organisationId != null ? organisationId : ""));

		Organisation organisation = organisationSrv.findOrganisationById(orgId);

		Person person = personMapper.toEntity(personDTO);

    OrganisationPersonLink orgPersLink = createOrgPersonLinks(person, organisation);
    populateLinkRollen(orgPersLink, personDTO.getRollen());

    person = create(person, orgPersLink);

 		return PersonHelper.createPersonDTO(person, organisation);
	}

	public PersonDTO updateUserOrganisationRollen(String userIdString, String organisationIdString, Set<RolleDTO> rollenDTOs) {
    UUID userId = UUID.fromString(userIdString);
    UUID organisationId = UUID.fromString(organisationIdString);
    Organisation organisation = organisationSrv.findOrganisationById(organisationId);

		Person person = persRepo.findById(userId)
        .orElseThrow(() -> new NotFoundException(Person.class, userId));

		OrganisationPersonLink orgPersLink = person.getOrganisationenLinks().stream()
				.filter(opl -> opl.getOrganisation().equals(organisation))
				.findFirst()
        .orElseThrow(() -> new NotFoundException(OrganisationPersonLink.class, person.getBenutzername()));

		Set<RollenLink> existingRollenLinks = orgPersLink.getRollenLink();
		Set<String> newRolleIds = rollenDTOs.stream().map(RolleDTO::getId).collect(Collectors.toSet());

		// Roles to delete
		List<RollenLink> toDelete = existingRollenLinks.stream()
				.filter(rl -> !newRolleIds.contains(rl.getId().toString()))
				.collect(Collectors.toList());

		rollenLinkRep.deleteAll(toDelete);
		existingRollenLinks.removeAll(toDelete);

		// Roles to add or update
		rollenDTOs.forEach(rolleDTO -> {
			Optional<RollenLink> existingLinkOpt = existingRollenLinks.stream()
					.filter(rl -> rl.getId().toString().equals(rolleDTO.getId()))
					.findFirst();

			if (existingLinkOpt.isPresent()) { // Update existing role link
				RollenLink rl = existingLinkOpt.get();
				if (rl.isAktiv() != rolleDTO.isAktiv()) {
					rl.setAktiv(rolleDTO.isAktiv());
					rollenLinkRep.save(rl);
				}
			} else { // Create new role link
				RollenLink rl = new RollenLink();
				rl.setChangeDate(Calendar.getInstance());
				rl.setAktiv(rolleDTO.isAktiv());
				rl.setDeleted(false);
				rl.setId(UUID.randomUUID());
				rl.setLink(orgPersLink);
				Rolle rolle = roleSrv.findByName(rolleDTO.getName());
				rl.setRolle(rolle);
				rollenLinkRep.save(rl);
				existingRollenLinks.add(rl);
			}
		});

		Person updatedPerson = savePerson(person, false);
		return PersonHelper.createPersonDTO(updatedPerson, organisation);
	}

	public void populateLinkRollen(OrganisationPersonLink orgPersLink, Set<RolleDTO> rollenDTO) {
		boolean isSingleAnmelder = rollenDTO.size() == 1 &&
				RollenEnum.ANMELDER.equals(rollenDTO.iterator().next().getName());

		rollenDTO.forEach(rolleDTO -> {
			Rolle rolle = roleSrv.findByName(rolleDTO.getName());
			RollenLink rollenLink = new RollenLink();
			rollenLink.setAktiv(!isSingleAnmelder);
			rollenLink.setLink(orgPersLink);
			rollenLink.setRolle(rolle);
			orgPersLink.getRollenLink().add(rollenLink);
		});
	}

	public String getEncodedPassword(String password) {
		log.debug("passwordEncoder: " + passwordEncoder.toString() + " ,work: " + password);
		return passwordEncoder.encode(password);
	}
}
