package org.ztv.anmeldetool.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.exception.ConflictException;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Organisation;
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
import org.ztv.anmeldetool.util.PersonMapper;

import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service("personService")
@Slf4j
@AllArgsConstructor
@Transactional(readOnly = true)
public class PersonService {

  private final PasswordEncoder passwordEncoder;
  private final OrganisationService organisationSrv;
  private final RoleService roleSrv;
  private final PersonenRepository persRepo;
  private final OrganisationPersonLinkRepository orgPersLinkRep;
  private final RollenLinkRepository rollenLinkRep;
  private final PersonMapper personMapper;

  /**
   * Finds all persons associated with a given organisation.
   *
   * @param orgId The UUID of the organisation.
   * @return A collection of PersonDTOs.
   */
  public List<PersonDTO> findPersonsDtoByOrganisationId(UUID orgId) {
    Organisation organisation = organisationSrv.findById(orgId);
    List<PersonDTO> persons = personMapper.toDtoList(findPersonsByOrganisation(organisation), orgId);
    return persons;
  }

  public List<Person> findPersonsByOrganisation(Organisation organisation) {
    List<Person>  persons = persRepo.findByOrganisation(organisation);
    return persons;
  }

  public Person findPersonById(UUID id) {
    Person person = persRepo.findById(id).orElseThrow(() -> new NotFoundException(Person.class, id.toString()));
    return person;
  }

  public Person findPersonByBenutzername(String username) {
    return persRepo.findByBenutzernameIgnoreCase(username).orElseThrow(() -> new NotFoundException(Person.class, username));
  }

  public PersonDTO findPersonDtoByBenutzername(String username) {
    // No active organisation is known here -> return DTO without organisation-scoped roles
    return personMapper.toDto(this.findPersonByBenutzername(username), null);
  }

  @Transactional
  public Person savePerson(Person person, boolean encodePassword) {
    if (encodePassword && person.getPassword() != null && !person.getPassword().isEmpty()) {
      person.setPassword(getEncodedPassword(person.getPassword()));
    }
    return persRepo.save(person);
  }

  @Transactional
  public PersonDTO update(UUID personId, PersonDTO personDTO, UUID organisationsId) throws NotFoundException {
    Organisation organisation = organisationSrv.findById(organisationsId);

    Person person = persRepo.findById(personId)
        .orElseThrow(() -> new NotFoundException(Person.class, personId));
    var links = person.getOrganisationenLinks();
    //TODO check if Benutzername is changed and unique Use same code as in create
    person.setOrganisationenLinks(null);
    personMapper.updateEntityFromDto(personDTO, person);

    person.setOrganisationenLinks(links);

    boolean encodePassword = handlePassword(personDTO, person);

    Person updatedPerson = savePerson(person, encodePassword);
    return personMapper.toDto(updatedPerson, organisationsId);
  }

  private boolean handlePassword(PersonDTO personDTO, Person person) {
    boolean encodePassword = personDTO.password() != null && !personDTO.password().isEmpty();
    if (encodePassword) {
      person.setPassword(personDTO.password());
    }
    return encodePassword;
  }

  @Transactional
  public Person create(Person person, OrganisationPersonLink orgPersLink) {
    // rollenLinkRep.saveAll(orgPersLink.getRollenLink());
    person.getOrganisationenLinks().add(orgPersLink);
    Person savedPerson = savePerson(person, true);
    return savedPerson;
  }

  @Transactional
  public PersonDTO create(PersonDTO personDTO, UUID organisationId) {
    try {
      if (findPersonByBenutzername(personDTO.benutzername()) != null) {
        String message = "User with username '%s' already exists.".formatted(personDTO.benutzername());
        log.info(message);
        throw new ConflictException(message);
      }
    } catch (NotFoundException e) {
      // User does not exist, proceed with creation
    }

    log.info("Creating user {}", personDTO.benutzername());

    UUID orgId = Optional.ofNullable(organisationId).or(() ->
        Optional.ofNullable(personDTO.organisationids()).stream().flatMap(Collection::stream).findFirst()
    ).orElseThrow(() -> new NotFoundException(Organisation.class,
        organisationId != null ? organisationId : ""));

    log.info("Lookup Organisation with ID {}", orgId);
    Organisation organisation = organisationSrv.findById(orgId);

    Person person = personMapper.toEntity(personDTO);
    if(person.getId() == null) {
      person.setId(UUID.randomUUID());
    }

    handlePassword(personDTO, person);

    OrganisationPersonLink orgPersLink = createOrgPersonLinks(person, organisation);
    populateLinkRollen(orgPersLink, personDTO.rollen());

    person = create(person, orgPersLink);

    return personMapper.toDto(person, orgId);
  }

  private void populateLinkRollen(OrganisationPersonLink orgPersLink, Set<RolleDTO> rollenDTO) {
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

  private OrganisationPersonLink createOrgPersonLinks(Person person, Organisation organisation) {
    OrganisationPersonLink orgPersLink = new OrganisationPersonLink();
    orgPersLink.setChangeDate(Calendar.getInstance());
    orgPersLink.setAktiv(true);
    orgPersLink.setDeleted(false);
    orgPersLink.setOrganisation(organisation);
    orgPersLink.setPerson(person);
    //return orgPersLinkRep.save(orgPersLink);
    return orgPersLink;
  }

  @Transactional
  public PersonDTO updateUserOrganisationRollen(String userIdString, String organisationIdString, Set<RolleDTO> rollenDTOs) {
    UUID userId = UUID.fromString(userIdString);
    UUID organisationId = UUID.fromString(organisationIdString);
    Organisation organisation = organisationSrv.findById(organisationId);

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
        .filter(rl -> !newRolleIds.contains(rl.getRolle().getId().toString()))
        .collect(Collectors.toList());

    rollenLinkRep.deleteAll(toDelete);
    existingRollenLinks.removeAll(toDelete);

    // Roles to add or update
    rollenDTOs.forEach(rolleDTO -> {
      Optional<RollenLink> existingLinkOpt = existingRollenLinks.stream()
          .filter(rl -> rl.getRolle().getId().toString().equals(rolleDTO.getId()))
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
    return personMapper.toDto(updatedPerson, organisationId);
  }

  public String getEncodedPassword(String password) {
    log.debug("passwordEncoder: " + passwordEncoder.toString() + " ,work: " + password);
    return passwordEncoder.encode(password);
  }
}
