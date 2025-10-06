package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
class OrganisationPersonLinkRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final OrganisationPersonLinkRepository linkRepository;

  private final OrganisationsRepository organisationRepository;

  private final PersonenRepository personenRepository;


  private List<Organisation> testOrganisations = new ArrayList<>();
  private List<Person> testPersons = new ArrayList<>();

  @Autowired
  public OrganisationPersonLinkRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      OrganisationsRepository organisationRepository,
      OrganisationPersonLinkRepository linkRepository, PersonenRepository personenRepository) {
    super(verbandsRepository);
    this.linkRepository = linkRepository;
    this.organisationRepository = organisationRepository;
    this.personenRepository = personenRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create and persist the Verband
    Verband verband = new Verband();
    verband.setVerbandLong(VerbandEnum.ZTV.name());
    verband.setVerband(VerbandEnum.ZTV.name());
    verbandsRepository.save(verband);

    // 2. Load Organisation data from JSON, link to Verband, and save
    try (InputStream orgInputStream = getClass().getResourceAsStream("/test-organisations.json")) {
      List<Organisation> loadedOrgs = objectMapper.readValue(orgInputStream, new TypeReference<>() {
      });
      loadedOrgs.forEach(org -> {
        org.setVerband(verband);
        testOrganisations.add(organisationRepository.save(org));
      });
    }

    // 3. Load Person data from JSON and save
    try (InputStream personInputStream = getClass().getResourceAsStream("/test-person.json")) {
      List<Person> loadedPersons = objectMapper.readValue(personInputStream, new TypeReference<>() {
      });
      loadedPersons.forEach(p -> testPersons.add(personenRepository.save(p)));
    }
  }

  @Test
  @DisplayName("Should create a link between an Organisation and a Person")
  void testCreateAndReadLink() {
    Organisation org = testOrganisations.get(0);
    Person person = testPersons.get(0);

    // Create
    OrganisationPersonLink newLink = new OrganisationPersonLink(org, person);
    OrganisationPersonLink savedLink = linkRepository.save(newLink);

    // Read
    Optional<OrganisationPersonLink> foundLinkOpt = linkRepository.findById(savedLink.getId());

    assertThat(foundLinkOpt).isPresent();
    assertThat(foundLinkOpt.get().getOrganisation()).isEqualTo(org);
    assertThat(foundLinkOpt.get().getPerson()).isEqualTo(person);
  }

  @Test
  @DisplayName("Should update a link's property (e.g., aktiv status)")
  void testUpdateLink() {
    OrganisationPersonLink savedLink = linkRepository.save(
        new OrganisationPersonLink(testOrganisations.get(0), testPersons.get(0)));
    assertThat(savedLink.isAktiv()).isFalse(); // Default from Base class

    // Update
    savedLink.setAktiv(true);
    OrganisationPersonLink updatedLink = linkRepository.save(savedLink);

    assertThat(updatedLink.isAktiv()).isTrue();
  }

  @Test
  @DisplayName("Should delete a link between an Organisation and a Person")
  void testDeleteLink() {
    OrganisationPersonLink savedLink = linkRepository.save(
        new OrganisationPersonLink(testOrganisations.get(0), testPersons.get(0)));

    // Delete
    linkRepository.deleteById(savedLink.getId());

    Optional<OrganisationPersonLink> foundLinkOpt = linkRepository.findById(savedLink.getId());
    assertThat(foundLinkOpt).isNotPresent();
  }

  @Test
  @DisplayName("Should find links by a specific Organisation and Person")
  void testFindByOrganisationAndPerson() {
    Organisation org1 = testOrganisations.get(0);
    Person person1 = testPersons.get(0);
    Person person2 = testPersons.get(1);

    // Create links
    linkRepository.save(new OrganisationPersonLink(org1, person1));
    linkRepository.save(
        new OrganisationPersonLink(org1, person2)); // Another person in the same org

    // Find
    Iterable<OrganisationPersonLink> foundLinks = linkRepository.findByOrganisationAndPerson(org1,
        person1);

    assertThat(foundLinks).hasSize(1);
    assertThat(foundLinks.iterator().next().getPerson().getBenutzername()).isEqualTo(
        "jdoe_from_file");
  }

  @Test
  @DisplayName("Should return an empty iterable when no link exists for a given Organisation and Person")
  void testFindByOrganisationAndPerson_NotFound() {
    Organisation org = testOrganisations.get(0);
    Person person = testPersons.get(0);

    // Do not create a link, just search
    Iterable<OrganisationPersonLink> foundLinks = linkRepository.findByOrganisationAndPerson(org,
        person);

    assertThat(foundLinks).isEmpty();
  }
}
