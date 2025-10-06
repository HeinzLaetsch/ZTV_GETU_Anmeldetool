package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.InputStream;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Laufliste;
import org.ztv.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
class LauflistenRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final LauflistenRepository lauflistenRepository;
  private final LauflistenContainerRepository lauflistenContainerRepository;
  private final OrganisationsRepository organisationsRepository;
  private final AnlassRepository anlassRepository;

  private Anlass testAnlass;
  private LauflistenContainer container;
  private List<Laufliste> lauflisten;

  @Autowired
  public LauflistenRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      LauflistenRepository lauflistenRepository,
      LauflistenContainerRepository lauflistenContainerRepository,
      OrganisationsRepository organisationsRepository,
      AnlassRepository anlassRepository) {
    super(verbandsRepository);
    this.lauflistenRepository = lauflistenRepository;
    this.lauflistenContainerRepository = lauflistenContainerRepository;
    this.organisationsRepository = organisationsRepository;
    this.anlassRepository = anlassRepository;
  }

  @BeforeEach
  void setUp() throws Exception {
    var org = buildDefaultOrganisation("LL Test Org", VerbandEnum.GLZ);
    var savedOrg = organisationsRepository.save(org);

    testAnlass = new Anlass();
    testAnlass.setAnlassBezeichnung("LL Test Event");
    testAnlass.setOrganisator(savedOrg);
    testAnlass.setAktiv(true);
    testAnlass = anlassRepository.save(testAnlass);

    container = new LauflistenContainer();
    container.setAnlass(testAnlass);
    container.setChecked(false);
    container = lauflistenContainerRepository.save(container);

    try (InputStream is = getClass().getResourceAsStream("/test-lauflisten.json")) {
      lauflisten = objectMapper.readValue(is, new TypeReference<List<Laufliste>>() {
      });
    }

    // set relation to container and persist
    lauflisten.forEach(l -> l.setLauflistenContainer(container));
    lauflistenRepository.saveAll(lauflisten);
  }

  @Test
  @DisplayName("Should save and find Laufliste by id")
  void testCreateAndRead() {
    Laufliste first = lauflistenRepository.findAll().get(0);
    Optional<Laufliste> found = lauflistenRepository.findById(first.getId());
    assertThat(found).isPresent();
    assertThat(found.get().getKey()).isEqualTo(first.getKey());
    assertThat(found.get().getLauflistenContainer().getId()).isEqualTo(container.getId());
  }

  @Test
  @DisplayName("Should find by key")
  void testFindByKey() {
    String key = lauflisten.get(0).getKey();
    List<Laufliste> found = lauflistenRepository.findByKey(key);
    assertThat(found).isNotEmpty();
    assertThat(found.get(0).getKey()).isEqualTo(key);
  }

  @Test
  @DisplayName("Should update erfasst flag")
  void testUpdate() {
    Laufliste ll = lauflistenRepository.findAll().get(0);
    boolean newVal = !ll.isErfasst();
    ll.setErfasst(newVal);
    lauflistenRepository.save(ll);

    Laufliste reloaded = lauflistenRepository.findById(ll.getId()).orElseThrow();
    assertThat(reloaded.isErfasst()).isEqualTo(newVal);
  }

  @Test
  @DisplayName("Should delete Laufliste")
  void testDelete() {
    List<Laufliste> all = lauflistenRepository.findAll();
    int initial = all.size();
    Laufliste toDelete = all.get(0);
    lauflistenRepository.delete(toDelete);
    assertThat(lauflistenRepository.findById(toDelete.getId())).isNotPresent();
    assertThat(lauflistenRepository.findAll().size()).isEqualTo(initial - 1);
  }

  @Test
  @DisplayName("Should return next sequence value from DB")
  void testGetNextSequence() {
    Long seq1 = lauflistenRepository.getNextSequence();
    Long seq2 = lauflistenRepository.getNextSequence();
    assertThat(seq1).isNotNull();
    assertThat(seq2).isNotNull();
    assertThat(seq2).isGreaterThan(seq1);
  }
}
