package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.VerbandEnum;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterSlot;

@SpringBootTest
@Transactional
class WertungsrichterSlotRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final WertungsrichterSlotRepository slotRepository;
  private final AnlassRepository anlassRepository;
  private final OrganisationsRepository organisationRepository;

  private Anlass testAnlass;
  private List<WertungsrichterSlot> testSlots = new ArrayList<>();

  @Autowired
  public WertungsrichterSlotRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      WertungsrichterSlotRepository slotRepository,
      AnlassRepository anlassRepository,
      OrganisationsRepository organisationRepository) {
    super(verbandsRepository);
    this.slotRepository = slotRepository;
    this.anlassRepository = anlassRepository;
    this.organisationRepository = organisationRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Create Verband and Organisation
    Organisation organisator = buildDefaultOrganisation("Test Organisator for Slots",
        VerbandEnum.ZTV);
    organisationRepository.save(organisator);

    // 2. Create a parent Anlass
    testAnlass = Anlass.builder()
        .anlassBezeichnung("Test-Anlass für Slots")
        .ort("Testort")
        .startDate(LocalDateTime.now())
        .build();
    testAnlass.setOrganisator(organisator);
    anlassRepository.save(testAnlass);

    // 3. Load WertungsrichterSlot data from JSON
    try (InputStream inputStream = getClass().getResourceAsStream(
        "/test-wertungsrichter-slot.json")) {
      if (inputStream == null) {
        throw new IOException("Cannot find resource file test-wertungsrichter-slot.json");
      }
      List<WertungsrichterSlot> loadedSlots = objectMapper.readValue(inputStream,
          new TypeReference<>() {
          });

      // 4. Link slots to the Anlass and save
      loadedSlots.forEach(slot -> {
        slot.setAnlass(testAnlass);
        testSlots.add(slotRepository.save(slot));
      });
    }
  }

  @Test
  @DisplayName("Should create and read a WertungsrichterSlot")
  void testCreateAndReadSlot() {
    WertungsrichterSlot slotToTest = testSlots.get(0);

    Optional<WertungsrichterSlot> foundSlotOpt = slotRepository.findById(slotToTest.getId());

    assertThat(foundSlotOpt).isPresent();
    WertungsrichterSlot found = foundSlotOpt.get();
    assertThat(found.getBeschreibung()).isEqualTo("Vormittag Brevet 1");
    assertThat(found.getBrevet()).isEqualTo(WertungsrichterBrevetEnum.Brevet_1);
    assertThat(found.getAnlass()).isEqualTo(testAnlass);
  }

  @Test
  @DisplayName("Should update an existing WertungsrichterSlot")
  void testUpdateSlot() {
    WertungsrichterSlot slotToUpdate = testSlots.get(0);
    slotToUpdate.setStart_zeit(LocalTime.of(8, 30));
    slotRepository.save(slotToUpdate);

    Optional<WertungsrichterSlot> foundSlotOpt = slotRepository.findById(slotToUpdate.getId());
    assertThat(foundSlotOpt).isPresent();
    assertThat(foundSlotOpt.get().getStart_zeit()).isEqualTo(LocalTime.of(8, 30));
  }

  @Test
  @DisplayName("Should delete a WertungsrichterSlot")
  void testDeleteSlot() {
    WertungsrichterSlot slotToDelete = testSlots.get(0);
    slotRepository.deleteById(slotToDelete.getId());
    Optional<WertungsrichterSlot> foundSlotOpt = slotRepository.findById(slotToDelete.getId());
    assertThat(foundSlotOpt).isNotPresent();
  }

  @Test
  @DisplayName("Should find all slots for a given Anlass")
  void testFindByAnlass() {
    // The setup links both slots from the JSON to the same testAnlass
    List<WertungsrichterSlot> foundSlots = slotRepository.findByAnlass(testAnlass);

    assertThat(foundSlots).hasSize(2);
    assertThat(foundSlots).extracting(WertungsrichterSlot::getBeschreibung)
        .containsExactlyInAnyOrder("Vormittag Brevet 1", "Nachmittag Brevet 2");
  }

  @Test
  @DisplayName("Should return an empty list for an Anlass with no slots")
  void testFindByAnlass_NotFound() {
    // Create a new Anlass with no slots
    Anlass emptyAnlass = Anlass.builder().anlassBezeichnung("Empty Anlass").build();
    emptyAnlass.setOrganisator(testAnlass.getOrganisator());
    anlassRepository.save(emptyAnlass);

    List<WertungsrichterSlot> foundSlots = slotRepository.findByAnlass(emptyAnlass);

    assertThat(foundSlots).isEmpty();
  }
}
