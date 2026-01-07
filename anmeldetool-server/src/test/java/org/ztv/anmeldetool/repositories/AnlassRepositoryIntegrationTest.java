package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
@Disabled
class AnlassRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final AnlassRepository anlassRepository;

  private final OrganisationsRepository organisationRepository;

  private List<Anlass> testAnlaesse;
  private Organisation testOrganisator;

  @Autowired
  public AnlassRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      AnlassRepository anlassRepository, OrganisationsRepository organisationRepository) {
    super(verbandsRepository);
    this.anlassRepository = anlassRepository;
    this.organisationRepository = organisationRepository;
  }

  @BeforeEach
  void setUp() throws IOException {

    Organisation org = buildDefaultOrganisation("Test Organisator", VerbandEnum.GLZ);
    testOrganisator = organisationRepository.save(org);

    // 2. Load Anlass data from JSON
    try (InputStream inputStream = getClass().getResourceAsStream("/test-anlass.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-anlass.json");
      }
      testAnlaesse = objectMapper.readValue(inputStream, new TypeReference<List<Anlass>>() {
      });
    }

    // 3. Associate each Anlass with the persisted Organisation and save
    testAnlaesse.forEach(anlass -> anlass.setOrganisator(testOrganisator));
    anlassRepository.saveAll(testAnlaesse);
  }

  @Test
  @DisplayName("Should save an Anlass and find it by ID")
  void testCreateAndReadAnlass() {
    Anlass anlass = testAnlaesse.get(0);
    Optional<Anlass> found = anlassRepository.findById(anlass.getId());
    assertThat(found).isPresent();
    assertThat(found.get().getAnlassBezeichnung()).isEqualTo("Fruehlings-Cup");
    assertThat(found.get().getOrganisator()).isEqualTo(testOrganisator);
  }

  @Test
  @DisplayName("Should update an existing Anlass")
  void testUpdateAnlass() {
    Anlass anlass = anlassRepository.findAll().iterator().next();
    String newLocation = "Neuer Ort";
    anlass.setOrt(newLocation);
    anlassRepository.save(anlass);

    Optional<Anlass> found = anlassRepository.findById(anlass.getId());
    assertThat(found).isPresent();
    assertThat(found.get().getOrt()).isEqualTo(newLocation);
  }

  @Test
  @DisplayName("Should delete an Anlass")
  void testDeleteAnlass() {
    Anlass anlass = anlassRepository.findAll().iterator().next();
    anlassRepository.deleteById(anlass.getId());
    Optional<Anlass> found = anlassRepository.findById(anlass.getId());
    assertThat(found).isNotPresent();
  }

  @Test
  @DisplayName("Should find active Anlaesse ordered by bezeichnung")
  void testFindByAktivOrderByAnlassBezeichnung() {
    List<Anlass> activeAnlaesse = anlassRepository.findByAktivOrderByAnlassBezeichnung(true);
    assertThat(activeAnlaesse).hasSize(3);
    assertThat(activeAnlaesse).extracting(Anlass::getAnlassBezeichnung)
        .containsExactly("Fruehlings-Cup", "Herbst-Meeting", "Sommer-Wettkampf");
  }

  @Test
  @DisplayName("Should find active Anlaesse ordered by start date")
  void testFindByAktivOrderByStartDate() {
    List<Anlass> activeAnlaesse = anlassRepository.findByAktivOrderByStartDate(true);
    assertThat(activeAnlaesse).hasSize(3);
    assertThat(activeAnlaesse).extracting(Anlass::getAnlassBezeichnung)
        .containsExactly("Fruehlings-Cup", "Sommer-Wettkampf", "Herbst-Meeting");
  }

  @Test
  @DisplayName("Should find all Anlaesse ordered by start date")
  void testFindAllByOrderByStartDate() {
    List<Anlass> allAnlaesse = anlassRepository.findAllByOrderByStartDate();
    assertThat(allAnlaesse).hasSize(4);
    assertThat(allAnlaesse).extracting(Anlass::getAnlassBezeichnung)
        .containsExactly("Archivierter Anlass", "Fruehlings-Cup", "Sommer-Wettkampf",
            "Herbst-Meeting");
  }

  @Test
  @DisplayName("Should find active Anlaesse within a specific date range")
  void testFindByStartDateBetweenAndAktivOrderByStartDate() {
    LocalDateTime start = LocalDateTime.of(2024, 1, 1, 0, 0);
    LocalDateTime end = LocalDateTime.of(2024, 8, 1, 0, 0);

    List<Anlass> anlaesseInRange = anlassRepository.findByStartDateBetweenAndAktivOrderByStartDate(
        start, end, true);

    assertThat(anlaesseInRange).hasSize(2);
    assertThat(anlaesseInRange).extracting(Anlass::getAnlassBezeichnung)
        .containsExactly("Fruehlings-Cup", "Sommer-Wettkampf");
  }
}
