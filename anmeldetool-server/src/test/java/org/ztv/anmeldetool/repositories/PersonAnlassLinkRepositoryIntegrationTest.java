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
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
class PersonAnmeldetoolLinkRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final PersonAnlassLinkRepository linkRepository;
  private final OrganisationsRepository organisationRepository;
  private final PersonenRepository personenRepository;
  private final AnlassRepository anlassRepository;
  private List<Organisation> testOrganisations = new ArrayList<>();
  private List<Person> testPersons = new ArrayList<>();
  private List<Anlass> testAnlaesse = new ArrayList<>();

  @Autowired
  public PersonAnmeldetoolLinkRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      PersonAnlassLinkRepository linkRepository, OrganisationsRepository organisationRepository,
      PersonenRepository personenRepository, AnlassRepository anlassRepository) {
    super(verbandsRepository);
    this.anlassRepository = anlassRepository;
    this.linkRepository = linkRepository;
    this.organisationRepository = organisationRepository;
    this.personenRepository = personenRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create Verband
    Verband verband = new Verband();
    verband.setVerbandLong(VerbandEnum.ZTV.name());
    verband.setVerband(VerbandEnum.ZTV.name());
    verbandsRepository.save(verband);

    // 2. Load and save Organisations
    try (InputStream orgInputStream = getClass().getResourceAsStream("/test-organisations.json")) {
      List<Organisation> loadedOrgs = objectMapper.readValue(orgInputStream, new TypeReference<>() {
      });
      loadedOrgs.forEach(org -> {
        org.setVerband(verband);
        testOrganisations.add(organisationRepository.save(org));
      });
    }

    // 3. Load and save Persons
    try (InputStream personInputStream = getClass().getResourceAsStream("/test-person.json")) {
      testPersons.addAll((java.util.Collection<? extends Person>) personenRepository.saveAll(
          objectMapper.readValue(personInputStream, new TypeReference<>() {
          })));
    }

    // 4. Load and save Anlaesse, linking to the first organisation as organisator
    try (InputStream anlassInputStream = getClass().getResourceAsStream("/test-anlass.json")) {
      List<Anlass> loadedAnlaesse = objectMapper.readValue(anlassInputStream,
          new TypeReference<>() {
          });
      loadedAnlaesse.forEach(anlass -> {
        anlass.setOrganisator(testOrganisations.get(0));
        testAnlaesse.add(anlassRepository.save(anlass));
      });
    }
  }

  private PersonAnlassLink createAndSaveTestLink() {
    PersonAnlassLink link = new PersonAnlassLink();
    link.setPerson(testPersons.get(0));
    link.setOrganisation(testOrganisations.get(1)); // Use a different org for specificity
    link.setAnlass(testAnlaesse.get(0));
    link.setKommentar("Testkommentar");
    return linkRepository.save(link);
  }

  @Test
  @DisplayName("Should create and read a PersonAnlassLink")
  void testCreateAndReadLink() {
    PersonAnlassLink savedLink = createAndSaveTestLink();
    Optional<PersonAnlassLink> foundLink = linkRepository.findById(savedLink.getId());

    assertThat(foundLink).isPresent();
    assertThat(foundLink.get().getKommentar()).isEqualTo("Testkommentar");
    assertThat(foundLink.get().getPerson().getBenutzername()).isEqualTo("jdoe_from_file");
  }

  @Test
  @DisplayName("Should update a PersonAnlassLink")
  void testUpdateLink() {
    PersonAnlassLink savedLink = createAndSaveTestLink();
    savedLink.setKommentar("Neuer Kommentar");
    linkRepository.save(savedLink);

    Optional<PersonAnlassLink> foundLink = linkRepository.findById(savedLink.getId());
    assertThat(foundLink).isPresent();
    assertThat(foundLink.get().getKommentar()).isEqualTo("Neuer Kommentar");
  }

  @Test
  @DisplayName("Should delete a PersonAnlassLink")
  void testDeleteLink() {
    PersonAnlassLink savedLink = createAndSaveTestLink();
    linkRepository.deleteById(savedLink.getId());
    Optional<PersonAnlassLink> foundLink = linkRepository.findById(savedLink.getId());
    assertThat(foundLink).isNotPresent();
  }

  @Test
  @DisplayName("Should find a link by Person, Organisation, and Anlass")
  void testFindByPersonAndOrganisationAndAnlass() {
    PersonAnlassLink savedLink = createAndSaveTestLink();

    List<PersonAnlassLink> foundLinks = linkRepository.findByPersonAndOrganisationAndAnlass(
        savedLink.getPerson(), savedLink.getOrganisation(), savedLink.getAnlass());

    assertThat(foundLinks).hasSize(1);
    assertThat(foundLinks.get(0)).isEqualTo(savedLink);
  }

  @Test
  @DisplayName("Should find all links for a given Anlass")
  void testFindByAnlass() {
    Anlass anlass = testAnlaesse.get(0);
    // Link person 1 and person 2 to the same Anlass
    PersonAnlassLink link1 = new PersonAnlassLink();
    link1.setAnlass(anlass);
    link1.setPerson(testPersons.get(0));
    link1.setOrganisation(testOrganisations.get(0));
    linkRepository.save(link1);

    PersonAnlassLink link2 = new PersonAnlassLink();
    link2.setAnlass(anlass);
    link2.setPerson(testPersons.get(1));
    link2.setOrganisation(testOrganisations.get(1));
    linkRepository.save(link2);

    List<PersonAnlassLink> foundLinks = linkRepository.findByAnlass(anlass);
    assertThat(foundLinks).hasSize(2);
  }

  @Test
  @DisplayName("Should find all links for a given Anlass and Organisation")
  void testFindByAnlassAndOrganisation() {
    Anlass anlass = testAnlaesse.get(0);
    Organisation org = testOrganisations.get(0);

    // Link person 1 to Anlass/Org
    PersonAnlassLink link1 = new PersonAnlassLink();
    link1.setAnlass(anlass);
    link1.setPerson(testPersons.get(0));
    link1.setOrganisation(org);
    linkRepository.save(link1);

    // Link person 2 to the same Anlass but a different Org
    PersonAnlassLink link2 = new PersonAnlassLink();
    link2.setAnlass(anlass);
    link2.setPerson(testPersons.get(1));
    link2.setOrganisation(testOrganisations.get(1));
    linkRepository.save(link2);

    List<PersonAnlassLink> foundLinks = linkRepository.findByAnlassAndOrganisation(anlass, org);
    assertThat(foundLinks).hasSize(1);
    assertThat(foundLinks.get(0).getPerson().getBenutzername()).isEqualTo("jdoe_from_file");
  }
}
