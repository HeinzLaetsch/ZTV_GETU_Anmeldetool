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
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
class NotenblaetterRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final NotenblaetterRepository notenblaetterRepository;
  private final OrganisationsRepository organisationsRepository;
  private final AnlassRepository anlassRepository;
  private final TeilnehmerRepository teilnehmerRepository;
  private final TeilnehmerAnlassLinkRepository talRepository;

  private Anlass testAnlass;
  private Organisation testOrg;
  private Teilnehmer testTeilnehmer;
  private TeilnehmerAnlassLink tal;
  private List<Notenblatt> notenblaetter;

  @Autowired
  public NotenblaetterRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      NotenblaetterRepository notenblaetterRepository,
      OrganisationsRepository organisationsRepository,
      AnlassRepository anlassRepository,
      TeilnehmerRepository teilnehmerRepository,
      TeilnehmerAnlassLinkRepository talRepository) {
    super(verbandsRepository);
    this.notenblaetterRepository = notenblaetterRepository;
    this.organisationsRepository = organisationsRepository;
    this.anlassRepository = anlassRepository;
    this.teilnehmerRepository = teilnehmerRepository;
    this.talRepository = talRepository;
  }

  @BeforeEach
  void setUp() throws Exception {
    // Organisation
    testOrg = organisationsRepository.save(
        buildDefaultOrganisation("NB Test Org", VerbandEnum.GLZ));

    // Anlass
    testAnlass = new Anlass();
    testAnlass.setAnlassBezeichnung("NB Test Event");
    testAnlass.setOrganisator(testOrg);
    testAnlass.setAktiv(true);
    testAnlass = anlassRepository.save(testAnlass);

    // Teilnehmer
    testTeilnehmer = Teilnehmer.builder()
        .name("Muster")
        .vorname("Max")
        .jahrgang(2010)
        .stvNummer("STV123")
        .tiTu(TiTuEnum.Ti)
        .dirty(false)
        .organisation(testOrg)
        .build();
    testTeilnehmer = teilnehmerRepository.save(testTeilnehmer);

    // TAL (minimal fields)
    tal = new TeilnehmerAnlassLink();
    tal.setTeilnehmer(testTeilnehmer);
    tal.setAnlass(testAnlass);
    tal.setOrganisation(testOrg);
    tal.setMeldeStatus(MeldeStatusEnum.STARTET);
    talRepository.save(tal);

    // Load Notenblaetter from JSON and set relation
    try (InputStream is = getClass().getResourceAsStream("/test-notenblaetter.json")) {
      notenblaetter = objectMapper.readValue(is, new TypeReference<List<Notenblatt>>() {
      });
    }
    notenblaetter.forEach(nb -> nb.setTal(tal));
    notenblaetterRepository.saveAll(notenblaetter);
  }

  @Test
  @DisplayName("Should save Notenblatt and find it by ID")
  void testCreateAndRead() {
    Notenblatt first = notenblaetterRepository.findAll().get(0);
    Optional<Notenblatt> found = notenblaetterRepository.findById(first.getId());
    assertThat(found).isPresent();
    assertThat(found.get().getTal()).isNotNull();
    assertThat(found.get().getGesamtPunktzahl()).isEqualTo(first.getGesamtPunktzahl());
  }

  @Test
  @DisplayName("Should update Notenblatt rang")
  void testUpdate() {
    Notenblatt nb = notenblaetterRepository.findAll().get(0);
    int newRang = nb.getRang() + 1;
    nb.setRang(newRang);
    notenblaetterRepository.save(nb);

    Notenblatt reloaded = notenblaetterRepository.findById(nb.getId()).orElseThrow();
    assertThat(reloaded.getRang()).isEqualTo(newRang);
  }

  @Test
  @DisplayName("Should delete Notenblatt")
  void testDelete() {
    List<Notenblatt> all = notenblaetterRepository.findAll();
    int initial = all.size();
    Notenblatt toDelete = all.get(0);
    notenblaetterRepository.delete(toDelete);
    assertThat(notenblaetterRepository.findById(toDelete.getId())).isNotPresent();
    assertThat(notenblaetterRepository.findAll().size()).isEqualTo(initial - 1);
  }
}
