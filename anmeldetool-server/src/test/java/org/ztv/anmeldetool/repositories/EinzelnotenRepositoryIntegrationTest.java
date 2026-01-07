package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Einzelnote;
import org.ztv.anmeldetool.models.Notenblatt;

@SpringBootTest
@Transactional
@Disabled
class EinzelnotenRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final EinzelnotenRepository einzelnotenRepository;

  private List<Einzelnote> testEinzelnoten;

  @Autowired
  public EinzelnotenRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      EinzelnotenRepository einzelnotenRepository) {
    super(verbandsRepository);
    this.einzelnotenRepository = einzelnotenRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    try (InputStream inputStream = getClass().getResourceAsStream("/test-einzelnote.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-einzelnote.json");
      }
      testEinzelnoten = AbstractRepositoryTest.objectMapper.readValue(inputStream,
          new TypeReference<List<Einzelnote>>() {
          });
    }

    // Ensure each Einzelnote has a Notenblatt (required, not nullable)
    for (Einzelnote en : testEinzelnoten) {
      if (en.getNotenblatt() == null) {
        en.setNotenblatt(new Notenblatt());
      }
    }

    einzelnotenRepository.saveAll(testEinzelnoten);
  }

  @Test
  @DisplayName("Should save Einzelnote and find it by ID")
  void testCreateAndReadEinzelnote() {
    Einzelnote sample = testEinzelnoten.get(0);
    UUID id = sample.getId();
    Optional<Einzelnote> found = einzelnotenRepository.findById(id);
    assertThat(found).isPresent();
    assertThat(found.get().getGeraet()).isEqualTo(sample.getGeraet());
    assertThat(found.get().getZaehlbar()).isEqualTo(sample.getZaehlbar());
    assertThat(found.get().getNotenblatt()).isNotNull();
  }

  @Test
  @DisplayName("Should update an existing Einzelnote")
  void testUpdateEinzelnote() {
    Einzelnote en = einzelnotenRepository.findAll().get(0);
    float newZaehlbar = en.getZaehlbar() + 0.1f;
    en.setZaehlbar(newZaehlbar);
    einzelnotenRepository.save(en);

    Optional<Einzelnote> found = einzelnotenRepository.findById(en.getId());
    assertThat(found).isPresent();
    assertThat(found.get().getZaehlbar()).isEqualTo(newZaehlbar);
  }

  @Test
  @DisplayName("Should delete an Einzelnote")
  void testDeleteEinzelnote() {
    List<Einzelnote> all = einzelnotenRepository.findAll();
    int initial = all.size();
    Einzelnote toDelete = all.get(0);

    einzelnotenRepository.deleteById(toDelete.getId());

    assertThat(einzelnotenRepository.findById(toDelete.getId())).isNotPresent();
    assertThat(einzelnotenRepository.findAll().size()).isEqualTo(initial - 1);
  }
}
