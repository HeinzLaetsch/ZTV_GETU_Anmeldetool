package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;

@SpringBootTest
@Transactional
class WertungsrichterRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final WertungsrichterRepository wertungsrichterRepository;
  private final PersonenRepository personenRepository;

  private List<Wertungsrichter> testWertungsrichter = new ArrayList<>();
  private List<Person> testPersons = new ArrayList<>();

  @Autowired
  public WertungsrichterRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      WertungsrichterRepository wertungsrichterRepository,
      PersonenRepository personenRepository) {
    super(verbandsRepository);
    this.wertungsrichterRepository = wertungsrichterRepository;
    this.personenRepository = personenRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Load and save Persons from their JSON file
    try (InputStream personStream = getClass().getResourceAsStream("/test-person.json")) {
      List<Person> loadedPersons = objectMapper.readValue(personStream, new TypeReference<>() {
      });
      testPersons.addAll(
          (java.util.Collection<? extends Person>) personenRepository.saveAll(loadedPersons));
    }

    // 2. Load Wertungsrichter data from its JSON file
    try (InputStream wrStream = getClass().getResourceAsStream("/test-wertungsrichter.json")) {
      List<Wertungsrichter> loadedWRs = objectMapper.readValue(wrStream, new TypeReference<>() {
      });

      // 3. Link each Wertungsrichter to a Person and save
      for (int i = 0; i < loadedWRs.size(); i++) {
        Wertungsrichter wr = loadedWRs.get(i);
        wr.setPerson(testPersons.get(i)); // Link WR 1 to Person 1, WR 2 to Person 2
        testWertungsrichter.add(wertungsrichterRepository.save(wr));
      }
    }
  }

  @Test
  @DisplayName("Should create and read a Wertungsrichter")
  void testCreateAndReadWertungsrichter() {
    Wertungsrichter wrToTest = testWertungsrichter.get(0);

    Optional<Wertungsrichter> foundOpt = wertungsrichterRepository.findById(wrToTest.getId());

    assertThat(foundOpt).isPresent();
    Wertungsrichter found = foundOpt.get();
    assertThat(found.getBrevet()).isEqualTo(WertungsrichterBrevetEnum.Brevet_1);
    assertThat(found.isGueltig()).isTrue();
    assertThat(found.getPerson().getBenutzername()).isEqualTo("jdoe_from_file");
  }

  @Test
  @DisplayName("Should update an existing Wertungsrichter")
  void testUpdateWertungsrichter() {
    Wertungsrichter wrToUpdate = testWertungsrichter.get(0);
    wrToUpdate.setGueltig(false);
    wertungsrichterRepository.save(wrToUpdate);

    Optional<Wertungsrichter> foundOpt = wertungsrichterRepository.findById(wrToUpdate.getId());
    assertThat(foundOpt).isPresent();
    assertThat(foundOpt.get().isGueltig()).isFalse();
  }

  @Test
  @DisplayName("Should delete a Wertungsrichter")
  void testDeleteWertungsrichter() {
    Wertungsrichter wrToDelete = testWertungsrichter.get(0);
    wertungsrichterRepository.deleteById(wrToDelete.getId());
    Optional<Wertungsrichter> foundOpt = wertungsrichterRepository.findById(wrToDelete.getId());
    assertThat(foundOpt).isNotPresent();
  }

  @Test
  @DisplayName("Should find all active Wertungsrichter")
  void testFindAllByAktiv() {
    // The setup creates one active and one inactive Wertungsrichter
    List<Wertungsrichter> activeWRs = wertungsrichterRepository.findAllByAktiv(false);
    assertThat(activeWRs).hasSize(2);
    assertThat(activeWRs.get(0).getBrevet()).isEqualTo(WertungsrichterBrevetEnum.Brevet_1);
  }

  @Test
  @DisplayName("Should find a Wertungsrichter by its associated Person ID")
  void testFindByPersonId() {
    Person personToFind = testPersons.get(1);
    List<Wertungsrichter> foundWRs = wertungsrichterRepository.findByPersonId(personToFind.getId());

    assertThat(foundWRs).hasSize(1);
    assertThat(foundWRs.get(0).getBrevet()).isEqualTo(WertungsrichterBrevetEnum.Brevet_2);
    assertThat(foundWRs.get(0).getPerson()).isEqualTo(personToFind);
  }

  @Test
  @DisplayName("Should return an empty list when finding by a non-existent Person ID")
  void testFindByPersonId_NotFound() {
    List<Wertungsrichter> foundWRs = wertungsrichterRepository.findByPersonId(UUID.randomUUID());
    assertThat(foundWRs).isEmpty();
  }
}
