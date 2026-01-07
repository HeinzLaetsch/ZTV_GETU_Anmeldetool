package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
@Disabled
class PersonenRepositoryTest extends AbstractRepositoryTest {

  private final PersonenRepository personRepository;

  private final OrganisationsRepository organisationsRepository;

  private final OrganisationPersonLinkRepository organisationPersonLinkRepository;
  private List<Person> testPersons;

  @Autowired
  public PersonenRepositoryTest(VerbandsRepository verbandsRepository,
      PersonenRepository personRepository, OrganisationsRepository organisationsRepository,
      OrganisationPersonLinkRepository organisationPersonLinkRepository) {
    super(verbandsRepository);
    this.personRepository = personRepository;
    this.organisationsRepository = organisationsRepository;
    this.organisationPersonLinkRepository = organisationPersonLinkRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // Load test data from the JSON file in the test resources
    try (InputStream inputStream = getClass().getResourceAsStream("/test-person.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-person.json");
      }
      // Use TypeReference to deserialize the JSON array into a List of Person objects
      testPersons = objectMapper.readValue(inputStream, new TypeReference<List<Person>>() {
      });
    }
  }

  @Test
  @DisplayName("Should load multiple persons from JSON file")
  void testLoadPersonsFromFile() {
    assertThat(testPersons).isNotNull();
    assertThat(testPersons).hasSize(6);
    assertThat(testPersons).extracting(Person::getBenutzername)
        .containsExactly("jdoe_from_file", "asmith_from_file", "1aaa_from_file", "2bbb_from_file",
            "3ccc_from_file", "4ddd_from_file");
  }

  @Test
  @DisplayName("Should save a person and find them by ID")
  void testCreateAndReadPerson() {
    Person personToTest = testPersons.get(0);
    // Create
    Person savedPerson = personRepository.save(personToTest);

    // Read
    Optional<Person> foundPersonOpt = personRepository.findById(savedPerson.getId());

    assertThat(foundPersonOpt).isPresent();
    assertThat(foundPersonOpt.get().getBenutzername()).isEqualTo(personToTest.getBenutzername());
  }

  @Test
  @DisplayName("Should update an existing person's details")
  void testUpdatePerson() {
    Person personToTest = testPersons.get(1);
    Person savedPerson = personRepository.save(personToTest);

    // Update
    String newEmail = "john.doe.new@example.com";
    savedPerson.setEmail(newEmail);
    personRepository.save(savedPerson);

    Optional<Person> updatedPersonOpt = personRepository.findById(savedPerson.getId());

    assertThat(updatedPersonOpt).isPresent();
    assertThat(updatedPersonOpt.get().getEmail()).isEqualTo(newEmail);
  }

  @Test
  @DisplayName("Should delete a person from the repository")
  void testDeletePerson() {
    Person personToTest = testPersons.get(2);
    Person savedPerson = personRepository.save(personToTest);

    // Delete
    personRepository.deleteById(savedPerson.getId());

    Optional<Person> deletedPersonOpt = personRepository.findById(savedPerson.getId());

    assertThat(deletedPersonOpt).isNotPresent();
  }

  @Test
  @DisplayName("Should find a person by username, ignoring case")
  void testFindByBenutzernameIgnoreCase() {
    Person personToTest = testPersons.get(3);
    personRepository.save(personToTest);

    // Find with different case
    Optional<Person> foundPerson = personRepository.findByBenutzernameIgnoreCase("2bbb_from_file");

    assertThat(foundPerson).isPresent();
    assertThat(foundPerson.get().getName()).isEqualTo("Bbb");
  }

  @Test
  @DisplayName("Should return null when no person is found by username")
  void testFindByBenutzernameIgnoreCase_NotFound() {
    Optional<Person> foundPerson = personRepository.findByBenutzernameIgnoreCase("nonexistent");
    assertThat(foundPerson).isNull();
  }

  @Test
  @DisplayName("Should find all persons linked to a specific organisation")
  void testFindByOrganisationId() {
    // 1. Setup related entities
    Organisation org1 = buildDefaultOrganisation("Test Org 1", VerbandEnum.GLZ);
    org1 = organisationsRepository.save(org1);

    Organisation org2 = buildDefaultOrganisation("Test Org 2", VerbandEnum.GLZ);
    org2 = organisationsRepository.save(org2);

    // Persist persons from the loaded list
    Person person1 = testPersons.get(4);
    Person person2 = testPersons.get(5);
    person1 = personRepository.save(person1);
    person2 = personRepository.save(person2);

    // 2. Create the links
    OrganisationPersonLink link1 = new OrganisationPersonLink(org1, person1);
    link1 = organisationPersonLinkRepository.save(link1);

    OrganisationPersonLink link2 = new OrganisationPersonLink(org1, person2);
    link2 = organisationPersonLinkRepository.save(link2);

    OrganisationPersonLink link3 = new OrganisationPersonLink(org2,
        person1); // Person 1 is also in Org 2
    link3 = organisationPersonLinkRepository.save(link3);

    // 3. Execute the repository method
    List<Person> personsInOrg1 = personRepository.findByOrganisationId(org1.getId());

    // 4. Assert the results
    assertThat(personsInOrg1).hasSize(2);
    assertThat(personsInOrg1).extracting(Person::getBenutzername)
        .containsExactlyInAnyOrder("3ccc_from_file", "4ddd_from_file");
  }

  @Test
  @DisplayName("Should return an empty list when no persons are linked to an organisation")
  void testFindByOrganisationId_Empty() {
    Organisation org = buildDefaultOrganisation("Test Organisation", VerbandEnum.GLZ);
    organisationsRepository.save(org);

    List<Person> persons = personRepository.findByOrganisationId(org.getId());

    assertThat(persons).isEmpty();
  }
}
