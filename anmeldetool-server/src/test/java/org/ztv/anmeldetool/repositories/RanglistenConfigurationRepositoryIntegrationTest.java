package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
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
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
@Disabled
class RanglistenConfigurationRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final RanglisteConfigurationRepository configurationRepository;
  private final AnlassRepository anlassRepository;
  private final OrganisationsRepository organisationRepository;
  private Anlass testAnlass;
  private List<RanglisteConfiguration> testConfigurations = new ArrayList<>();

  @Autowired
  public RanglistenConfigurationRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      RanglisteConfigurationRepository configurationRepository, AnlassRepository anlassRepository,
      OrganisationsRepository organisationRepository) {
    super(verbandsRepository);
    this.anlassRepository = anlassRepository;
    this.organisationRepository = organisationRepository;
    this.configurationRepository = configurationRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create Verband and Organisation
    Organisation organisator = buildDefaultOrganisation("Test Organisator für Ranglisten",
        VerbandEnum.ZTV);
    organisationRepository.save(organisator);

    // 2. Create a parent Anlass
    testAnlass = Anlass.builder()
        .anlassBezeichnung("Test-Anlass für Konfigurationen")
        .ort("Testort")
        .startDate(LocalDateTime.now())
        .build();
    testAnlass.setOrganisator(organisator);
    anlassRepository.save(testAnlass);

    // 3. Load RanglistenConfiguration data from JSON
    try (InputStream inputStream = getClass().getResourceAsStream(
        "/test-ranglisten-configuration.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-ranglisten-configuration.json");
      }
      List<RanglisteConfiguration> loadedConfigs = objectMapper.readValue(inputStream,
          new TypeReference<>() {
          });

      // 4. Link configurations to the Anlass and save
      loadedConfigs.forEach(config -> {
        config.setAnlass(testAnlass);
        testConfigurations.add(configurationRepository.save(config));
      });
    }
  }

  @Test
  @DisplayName("Should create and read a RanglistenConfiguration")
  void testCreateAndReadConfiguration() {
    RanglisteConfiguration configToTest = testConfigurations.get(0);

    Optional<RanglisteConfiguration> foundConfigOpt = configurationRepository.findById(
        configToTest.getId());

    assertThat(foundConfigOpt).isPresent();
    assertThat(foundConfigOpt.get().getMaxAuszeichnungen()).isEqualTo(10);
    assertThat(foundConfigOpt.get().getAnlass()).isEqualTo(testAnlass);
  }

  @Test
  @DisplayName("Should update a RanglistenConfiguration")
  void testUpdateConfiguration() {
    RanglisteConfiguration configToUpdate = testConfigurations.get(0);
    configToUpdate.setMaxAuszeichnungen(15);
    configurationRepository.save(configToUpdate);

    Optional<RanglisteConfiguration> foundConfigOpt = configurationRepository.findById(
        configToUpdate.getId());
    assertThat(foundConfigOpt).isPresent();
    assertThat(foundConfigOpt.get().getMaxAuszeichnungen()).isEqualTo(15);
  }

  @Test
  @DisplayName("Should delete a RanglistenConfiguration")
  void testDeleteConfiguration() {
    RanglisteConfiguration configToDelete = testConfigurations.get(0);
    configurationRepository.deleteById(configToDelete.getId());
    Optional<RanglisteConfiguration> foundConfigOpt = configurationRepository.findById(
        configToDelete.getId());
    assertThat(foundConfigOpt).isNotPresent();
  }

    /*
    @Test
    @DisplayName("Should find a configuration by Anlass, Kategorie, and TiTu")
    void testFindByAnlassAndKategorieAndTiTu() {
        // This test assumes a method like findByAnlassAndKategorieAndTiTu exists.
        Optional<RanglisteConfiguration> foundConfigOpt = configurationRepository.findByAnlassAndKategorieAndTiTu(
            testAnlass, KategorieEnum.K5, TiTuEnum.Tu);

        assertThat(foundConfigOpt).isPresent();
        assertThat(foundConfigOpt.get().getMaxAuszeichnungen()).isEqualTo(8);
        assertThat(foundConfigOpt.get().getProzentAuszeichnungen()).isEqualTo(25.0);
    }

    @Test
    @DisplayName("Should return empty Optional for a non-existent configuration")
    void testFindByAnlassAndKategorieAndTiTu_NotFound() {
        Optional<RanglistenConfiguration> foundConfigOpt = configurationRepository.findByAnlassAndKategorieAndTiTu(
            testAnlass, KategorieEnum.K7, TiTuEnum.Alle); // This combination doesn't exist in the JSON

        assertThat(foundConfigOpt).isNotPresent();
    }

     */
}
