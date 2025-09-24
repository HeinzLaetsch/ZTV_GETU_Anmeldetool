package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
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
import org.ztv.anmeldetool.models.Rolle;

@SpringBootTest
@Transactional
class RollenRepositoryIntegrationTest extends AbstractRepositoryTest {
  private final RollenRepository rollenRepository;
  private List<Rolle> testRollen = new ArrayList<>();

  @Autowired
  public RollenRepositoryIntegrationTest(VerbandsRepository verbandsRepository, RollenRepository rollenRepository) {
    super(verbandsRepository);
    this.rollenRepository=rollenRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // Load Rolle data from JSON and save it
    try (InputStream inputStream = getClass().getResourceAsStream("/test-rollen.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-rollen.json");
      }
      List<Rolle> loadedRollen = objectMapper.readValue(inputStream, new TypeReference<>() {
      });
      testRollen.addAll(
          (java.util.Collection<? extends Rolle>) rollenRepository.saveAll(loadedRollen));
    }
  }

  @Test
  @DisplayName("Should create and read a Rolle")
  void testCreateAndReadRolle() {
    Rolle rolleToTest = testRollen.get(0);

    Optional<Rolle> foundRolleOpt = rollenRepository.findById(rolleToTest.getId());

    assertThat(foundRolleOpt).isPresent();
    assertThat(foundRolleOpt.get().getName()).isEqualTo("ANMELDER");
    assertThat(foundRolleOpt.get().isPublicAssignable()).isTrue();
  }

  @Test
  @DisplayName("Should update an existing Rolle")
  void testUpdateRolle() {
    Rolle rolleToUpdate = testRollen.get(0);
    String newDescription = "Kann Anmeldungen für einen Verein erstellen und bearbeiten";

    rolleToUpdate.setBeschreibung(newDescription);
    rollenRepository.save(rolleToUpdate);

    Optional<Rolle> foundRolleOpt = rollenRepository.findById(rolleToUpdate.getId());
    assertThat(foundRolleOpt).isPresent();
    assertThat(foundRolleOpt.get().getBeschreibung()).isEqualTo(newDescription);
  }

  @Test
  @DisplayName("Should delete a Rolle")
  void testDeleteRolle() {
    Rolle rolleToDelete = testRollen.get(0);
    rollenRepository.deleteById(rolleToDelete.getId());
    Optional<Rolle> foundRolleOpt = rollenRepository.findById(rolleToDelete.getId());
    assertThat(foundRolleOpt).isNotPresent();
  }

  @Test
  @DisplayName("Should find a Rolle by its name")
  void testFindByName() {
    Rolle foundRolle = rollenRepository.findByName("VEREINSVERANTWORTLICHER");

    assertThat(foundRolle).isNotNull();
    assertThat(foundRolle.getName()).isEqualTo("VEREINSVERANTWORTLICHER");
    assertThat(foundRolle.isPublicAssignable()).isFalse();
  }

  @Test
  @DisplayName("Should return null when finding by a non-existent name")
  void testFindByName_NotFound() {
    Rolle foundRolle = rollenRepository.findByName("NON_EXISTENT_ROLLE");

    assertThat(foundRolle).isNull();
  }
}
