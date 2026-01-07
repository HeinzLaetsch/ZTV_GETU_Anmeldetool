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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
@Disabled
class TeilnehmerRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final TeilnehmerRepository teilnehmerRepository;
  private final OrganisationsRepository organisationRepository;

  private List<Teilnehmer> testTeilnehmer;
  private Organisation testOrganisation;

  @Autowired
  TeilnehmerRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      TeilnehmerRepository teilnehmerRepository, OrganisationsRepository organisationRepository) {
    super(verbandsRepository);
    this.teilnehmerRepository = teilnehmerRepository;
    this.organisationRepository = organisationRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create and persist the parent Organisation
    Organisation org = buildDefaultOrganisation("Testorg", VerbandEnum.ZTV);
    testOrganisation = organisationRepository.save(org);

    // 2. Load Teilnehmer data from JSON
    try (InputStream inputStream = getClass().getResourceAsStream("/test-teilnehmer.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-teilnehmer.json");
      }
      testTeilnehmer = objectMapper.readValue(inputStream, new TypeReference<List<Teilnehmer>>() {
      });
    }

    // 3. Associate each Teilnehmer with the persisted Organisation
    testTeilnehmer.forEach(t -> t.setOrganisation(testOrganisation));
  }

  @Test
  @DisplayName("Should save a Teilnehmer and find it by ID")
  void testCreateAndReadTeilnehmer() {
    Teilnehmer teilnehmerToSave = testTeilnehmer.get(0);

    // Create
    Teilnehmer savedTeilnehmer = teilnehmerRepository.save(teilnehmerToSave);

    // Read
    Optional<Teilnehmer> foundTeilnehmerOpt = teilnehmerRepository.findById(
        savedTeilnehmer.getId());

    assertThat(foundTeilnehmerOpt).isPresent();
    assertThat(foundTeilnehmerOpt.get().getName()).isEqualTo("Turner");
    assertThat(foundTeilnehmerOpt.get().getOrganisation()).isEqualTo(testOrganisation);
  }

  @Test
  @DisplayName("Should update an existing Teilnehmer")
  void testUpdateTeilnehmer() {
    Teilnehmer savedTeilnehmer = teilnehmerRepository.save(testTeilnehmer.get(0));
    String newStvNummer = "T-9999";

    // Update
    savedTeilnehmer.setStvNummer(newStvNummer);
    Teilnehmer updatedTeilnehmer = teilnehmerRepository.save(savedTeilnehmer);

    assertThat(updatedTeilnehmer.getStvNummer()).isEqualTo(newStvNummer);
  }

  @Test
  @DisplayName("Should delete a Teilnehmer")
  void testDeleteTeilnehmer() {
    Teilnehmer savedTeilnehmer = teilnehmerRepository.save(testTeilnehmer.get(0));

    // Delete
    teilnehmerRepository.deleteById(savedTeilnehmer.getId());

    Optional<Teilnehmer> foundTeilnehmerOpt = teilnehmerRepository.findById(
        savedTeilnehmer.getId());
    assertThat(foundTeilnehmerOpt).isNotPresent();
  }

  @Test
  @DisplayName("Should find Teilnehmer by name and vorname")
  void testFindByNameAndVorname() {
    teilnehmerRepository.saveAll(testTeilnehmer);

    List<Teilnehmer> found = teilnehmerRepository.findByNameAndVorname("Vogt", "Vera");

    assertThat(found).hasSize(1);
    assertThat(found.get(0).getStvNummer()).isEqualTo("V-2002");
  }

  @Test
  @DisplayName("Should find a page of Teilnehmer by Organisation")
  void testFindByOrganisation() {
    teilnehmerRepository.saveAll(testTeilnehmer);

    // Create another organisation with one teilnehmer to ensure our query is specific
    Organisation otherOrg = buildDefaultOrganisation("Other TV", VerbandEnum.GLZ);
    organisationRepository.save(otherOrg);
    teilnehmerRepository.save(
        Teilnehmer.builder().name("Other").vorname("Person").organisation(otherOrg).build());

    // Find
    Page<Teilnehmer> foundPage = teilnehmerRepository.findByOrganisation(testOrganisation,
        PageRequest.of(0, 5));

    assertThat(foundPage).hasSize(2);
    assertThat(foundPage).extracting(Teilnehmer::getName)
        .containsExactlyInAnyOrder("Turner", "Vogt");
  }

  @Test
  @DisplayName("Should count Teilnehmer by Organisation")
  void testCountByOrganisation() {
    teilnehmerRepository.saveAll(testTeilnehmer);

    long count = teilnehmerRepository.countByOrganisation(testOrganisation);

    assertThat(count).isEqualTo(2);
  }
}
