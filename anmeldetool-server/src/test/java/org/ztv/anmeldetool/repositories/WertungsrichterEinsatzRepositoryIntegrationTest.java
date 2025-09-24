package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.VerbandEnum;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.models.WertungsrichterSlot;

@SpringBootTest
@Transactional
class WertungsrichterEinsatzRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final WertungsrichterEinsatzRepository einsatzRepository;
  private final PersonAnlassLinkRepository personAnlassLinkRepository;
  private final WertungsrichterSlotRepository wertungsrichterSlotRepository;
  private final AnlassRepository anlassRepository;
  private final OrganisationsRepository organisationRepository;
  private final PersonenRepository personenRepository;
  private final WertungsrichterRepository wertungsrichterRepository;

  private PersonAnlassLink testPersonAnlassLink;
  private WertungsrichterSlot testWertungsrichterSlot;
  private WertungsrichterEinsatz testEinsatz;

  @Autowired
  public WertungsrichterEinsatzRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      WertungsrichterEinsatzRepository einsatzRepository,
      PersonAnlassLinkRepository personAnlassLinkRepository,
      WertungsrichterSlotRepository wertungsrichterSlotRepository,
      AnlassRepository anlassRepository,
      OrganisationsRepository organisationRepository,
      PersonenRepository personenRepository,
      WertungsrichterRepository wertungsrichterRepository) {
    super(verbandsRepository);
    this.einsatzRepository = einsatzRepository;
    this.personAnlassLinkRepository = personAnlassLinkRepository;
    this.wertungsrichterSlotRepository = wertungsrichterSlotRepository;
    this.anlassRepository = anlassRepository;
    this.organisationRepository = organisationRepository;
    this.personenRepository = personenRepository;
    this.wertungsrichterRepository = wertungsrichterRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create base data
    Organisation org = buildDefaultOrganisation("Test Org for Einsatz", VerbandEnum.ZTV);
    org = organisationRepository.save(org);

    // 2. Create Person and Wertungsrichter
    Person person = Person.builder().id(UUID.randomUUID()).benutzername("testjudge").name("Judge")
        .vorname("Judy")
        .build();
    person = personenRepository.save(person);
    Wertungsrichter wr = new Wertungsrichter();
    wr.setPerson(person);
    wr.setBrevet(WertungsrichterBrevetEnum.Brevet_1);
    wr = wertungsrichterRepository.save(wr);

    // 3. Create Anlass and WertungsrichterSlot
    Anlass anlass = Anlass.builder().anlassBezeichnung("Einsatz-Test-Anlass").ort("Halle")
        .startDate(LocalDateTime.now()).build();
    anlass.setOrganisator(org);
    anlass = anlassRepository.save(anlass);
    testWertungsrichterSlot = new WertungsrichterSlot();
    testWertungsrichterSlot.setAnlass(anlass);
    testWertungsrichterSlot.setBeschreibung("Test Slot");
    testWertungsrichterSlot = wertungsrichterSlotRepository.save(testWertungsrichterSlot);

    // 4. Create the parent PersonAnlassLink
    testPersonAnlassLink = new PersonAnlassLink();
    testPersonAnlassLink.setAnlass(anlass);
    testPersonAnlassLink.setPerson(person);
    testPersonAnlassLink.setOrganisation(org);
    testPersonAnlassLink = personAnlassLinkRepository.save(testPersonAnlassLink);

    // 5. Load Einsatz data from JSON and create the entity
    try (InputStream inputStream = getClass().getResourceAsStream(
        "/test-wertungsrichter-einsatz.json")) {
      testEinsatz = objectMapper.readValue(inputStream, WertungsrichterEinsatz.class);
    }
    testEinsatz.setPersonAnlassLink(testPersonAnlassLink);
    testEinsatz.setWertungsrichterSlot(testWertungsrichterSlot);
  }

  @Test
  @DisplayName("Should create and read a WertungsrichterEinsatz")
  void testCreateAndReadEinsatz() {
    WertungsrichterEinsatz savedEinsatz = einsatzRepository.save(testEinsatz);

    Optional<WertungsrichterEinsatz> foundOpt = einsatzRepository.findById(savedEinsatz.getId());

    assertThat(foundOpt).isPresent();
    assertThat(foundOpt.get().isEingesetzt()).isTrue();
    assertThat(foundOpt.get().getPersonAnlassLink()).isEqualTo(testPersonAnlassLink);
    assertThat(foundOpt.get().getWertungsrichterSlot()).isEqualTo(testWertungsrichterSlot);
  }

  @Test
  @DisplayName("Should update a WertungsrichterEinsatz")
  void testUpdateEinsatz() {
    WertungsrichterEinsatz savedEinsatz = einsatzRepository.save(testEinsatz);
    assertThat(savedEinsatz.isEingesetzt()).isTrue();

    savedEinsatz.setEingesetzt(false);
    einsatzRepository.save(savedEinsatz);

    Optional<WertungsrichterEinsatz> foundOpt = einsatzRepository.findById(savedEinsatz.getId());
    assertThat(foundOpt).isPresent();
    assertThat(foundOpt.get().isEingesetzt()).isFalse();
  }

  @Test
  @DisplayName("Should delete a WertungsrichterEinsatz")
  void testDeleteEinsatz() {
    WertungsrichterEinsatz savedEinsatz = einsatzRepository.save(testEinsatz);
    einsatzRepository.deleteById(savedEinsatz.getId());
    Optional<WertungsrichterEinsatz> foundOpt = einsatzRepository.findById(savedEinsatz.getId());
    assertThat(foundOpt).isNotPresent();
  }

  @Test
  @DisplayName("Should find one Einsatz by PersonAnlassLink")
  void testFindOneByPersonAnlassLink() {
    einsatzRepository.save(testEinsatz);

    Optional<WertungsrichterEinsatz> foundOpt = einsatzRepository.findOneByPersonAnlassLink(
        testPersonAnlassLink);

    assertThat(foundOpt).isPresent();
    assertThat(foundOpt.get().getId()).isEqualTo(testEinsatz.getId());
  }

  @Test
  @DisplayName("Should return empty Optional when no Einsatz exists for a PersonAnlassLink")
  void testFindOneByPersonAnlassLink_NotFound() {
    // Don't save the testEinsatz
    Optional<WertungsrichterEinsatz> foundOpt = einsatzRepository.findOneByPersonAnlassLink(
        testPersonAnlassLink);

    assertThat(foundOpt).isNotPresent();
  }
}
