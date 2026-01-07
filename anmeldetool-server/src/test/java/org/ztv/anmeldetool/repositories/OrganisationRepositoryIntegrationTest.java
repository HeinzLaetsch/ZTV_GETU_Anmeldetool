package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
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
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
@Disabled
class OrganisationRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final OrganisationsRepository organisationRepository;

  private List<Organisation> testOrganisations = new ArrayList<>();

  // Constructor to satisfy the parent class AbstractRepositoryTest
  @Autowired
  public OrganisationRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      OrganisationsRepository organisationRepository) {
    super(verbandsRepository);
    this.organisationRepository = organisationRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create and persist the Verband (dependency for Organisation)
    Verband verband = new Verband();
    verband.setVerbandLong(VerbandEnum.ZTV.name());
    verband.setVerband(VerbandEnum.ZTV.name());
    verbandsRepository.save(verband);

    // 2. Load Organisation data from JSON
    try (InputStream inputStream = getClass().getResourceAsStream("/test-organisations.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-organisations.json");
      }
      List<Organisation> loadedOrgs = objectMapper.readValue(inputStream, new TypeReference<>() {
      });

      // 3. Link to Verband and save, collecting the managed entities
      loadedOrgs.forEach(org -> {
        org.setVerband(verband);
        testOrganisations.add(organisationRepository.save(org));
      });
    }
  }

  @Test
  @DisplayName("Should load and save organisations from JSON")
  void testSetupLoadsData() {
    assertThat(testOrganisations).isNotNull();
    assertThat(testOrganisations).hasSize(2);

    List<Organisation> allOrgs = (List<Organisation>) organisationRepository.findAll();
    assertThat(allOrgs).hasSize(2);
    assertThat(allOrgs).extracting(Organisation::getName).contains("TV Zuerich", "TV Winterthur");
  }

  @Test
  @DisplayName("Should save an Organisation and find it by ID")
  void testCreateAndReadOrganisation() {
    Organisation orgToTest = testOrganisations.get(0);

    // Read
    Optional<Organisation> foundOrgOpt = organisationRepository.findById(orgToTest.getId());

    assertThat(foundOrgOpt).isPresent();
    assertThat(foundOrgOpt.get().getName()).isEqualTo("TV Zuerich");
    assertThat(foundOrgOpt.get().getVerband()).isNotNull();
    assertThat(foundOrgOpt.get().getVerband().getVerband()).isEqualTo(VerbandEnum.ZTV.name());
  }

  @Test
  @DisplayName("Should update an existing Organisation")
  void testUpdateOrganisation() {
    Organisation orgToUpdate = testOrganisations.get(0);
    String newName = "Turnverein Zuerich Altstetten";

    // Update
    orgToUpdate.setName(newName);
    Organisation updatedOrg = organisationRepository.save(orgToUpdate);

    Optional<Organisation> foundOrgOpt = organisationRepository.findById(updatedOrg.getId());
    assertThat(foundOrgOpt).isPresent();
    assertThat(foundOrgOpt.get().getName()).isEqualTo(newName);
  }

  @Test
  @DisplayName("Should delete an Organisation")
  void testDeleteOrganisation() {
    Organisation orgToDelete = testOrganisations.get(0);

    // Delete
    organisationRepository.deleteById(orgToDelete.getId());

    Optional<Organisation> foundOrgOpt = organisationRepository.findById(orgToDelete.getId());
    assertThat(foundOrgOpt).isNotPresent();
  }
}
