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
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
class RollenLinkRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final RollenLinkRepository rollenLinkRepository;
  private final RollenRepository rollenRepository;
  private final OrganisationPersonLinkRepository orgPersonLinkRepository;
  private final OrganisationsRepository organisationRepository;
  private final PersonenRepository personenRepository;

  private OrganisationPersonLink testOrgPersonLink;
  private List<Rolle> testRollen = new ArrayList<>();

  @Autowired
  public RollenLinkRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      RollenLinkRepository rollenLinkRepository, RollenRepository rollenRepository,
      OrganisationPersonLinkRepository orgPersonLinkRepository,
      OrganisationsRepository organisationRepository,
      PersonenRepository personenRepository) {
    super(verbandsRepository);
    this.rollenRepository=rollenRepository;
    this.rollenLinkRepository=rollenLinkRepository;
    this.orgPersonLinkRepository=orgPersonLinkRepository;
    this.organisationRepository=organisationRepository;
    this.personenRepository=personenRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create Verband
    Verband verband = new Verband();
    verband.setVerbandLong(VerbandEnum.ZTV.name());
    verband.setVerband(VerbandEnum.ZTV.name());
    verbandsRepository.save(verband);

    // 2. Load and save Organisation
    Organisation org;
    try (InputStream orgInputStream = getClass().getResourceAsStream("/test-organisations.json")) {
      List<Organisation> loadedOrgs = objectMapper.readValue(orgInputStream, new TypeReference<>() {
      });
      loadedOrgs.get(0).setVerband(verband);
      org = organisationRepository.save(loadedOrgs.get(0));
    }

    // 3. Load and save Person
    Person person;
    try (InputStream personInputStream = getClass().getResourceAsStream("/test-person.json")) {
      List<Person> loadedPersons = objectMapper.readValue(personInputStream, new TypeReference<>() {
      });
      person = personenRepository.save(loadedPersons.get(0));
    }

    // 4. Create the parent OrganisationPersonLink
    testOrgPersonLink = orgPersonLinkRepository.save(new OrganisationPersonLink(org, person));

    // 5. Load and save Rollen
    try (InputStream rollenInputStream = getClass().getResourceAsStream("/test-rollen.json")) {
      testRollen.addAll(
          (java.util.Collection<? extends Rolle>) rollenRepository.saveAll(
              objectMapper.readValue(rollenInputStream, new TypeReference<>() {
              })));
    }
  }

  private RollenLink createAndSaveTestLink() {
    RollenLink rollenLink = new RollenLink();
    rollenLink.setLink(testOrgPersonLink);
    rollenLink.setRolle(testRollen.get(0)); // Assign the first role (ANMELDER)
    return rollenLinkRepository.save(rollenLink);
  }

  @Test
  @DisplayName("Should create and read a RollenLink")
  void testCreateAndReadRollenLink() {
    RollenLink savedLink = createAndSaveTestLink();

    Optional<RollenLink> foundLinkOpt = rollenLinkRepository.findById(savedLink.getId());

    assertThat(foundLinkOpt).isPresent();
    RollenLink foundLink = foundLinkOpt.get();
    assertThat(foundLink.getLink()).isEqualTo(testOrgPersonLink);
    assertThat(foundLink.getRolle().getName()).isEqualTo("ANMELDER");
  }

  @Test
  @DisplayName("Should update a RollenLink (e.g., change role)")
  void testUpdateRollenLink() {
    RollenLink savedLink = createAndSaveTestLink();
    Rolle newRolle = testRollen.get(1); // VEREINSVERANTWORTLICHER

    // Update
    savedLink.setRolle(newRolle);
    rollenLinkRepository.save(savedLink);

    Optional<RollenLink> foundLinkOpt = rollenLinkRepository.findById(savedLink.getId());
    assertThat(foundLinkOpt).isPresent();
    assertThat(foundLinkOpt.get().getRolle().getName()).isEqualTo("VEREINSVERANTWORTLICHER");
  }

  @Test
  @DisplayName("Should delete a RollenLink")
  void testDeleteRollenLink() {
    RollenLink savedLink = createAndSaveTestLink();

    // Delete
    rollenLinkRepository.deleteById(savedLink.getId());

    Optional<RollenLink> foundLinkOpt = rollenLinkRepository.findById(savedLink.getId());
    assertThat(foundLinkOpt).isNotPresent();
  }
}
