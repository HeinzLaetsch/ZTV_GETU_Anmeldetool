package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import java.io.InputStream;
import java.time.LocalDateTime;
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
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
class OrganisationAnlassLinkRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final OrganisationAnlassLinkRepository organisationAnlassLinkRepository;
  private final OrganisationsRepository organisationsRepository;
  private final AnlassRepository anlassRepository;

  private Organisation org1;
  private Organisation org2;
  private Anlass anlass;
  private List<OrganisationAnlassLink> links;

  @Autowired
  public OrganisationAnlassLinkRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      OrganisationAnlassLinkRepository organisationAnlassLinkRepository,
      OrganisationsRepository organisationsRepository,
      AnlassRepository anlassRepository) {
    super(verbandsRepository);
    this.organisationAnlassLinkRepository = organisationAnlassLinkRepository;
    this.organisationsRepository = organisationsRepository;
    this.anlassRepository = anlassRepository;
  }

  @BeforeEach
  void setUp() throws Exception {
    org1 = organisationsRepository.save(buildDefaultOrganisation("Org-AL Test 1", VerbandEnum.GLZ));
    org2 = organisationsRepository.save(buildDefaultOrganisation("Org-AL Test 2", VerbandEnum.GLZ));

    anlass = new Anlass();
    anlass.setAnlassBezeichnung("OAL Test Event");
    anlass.setOrganisator(org1);
    anlass.setAktiv(true);
    anlass = anlassRepository.save(anlass);

    try (InputStream is = getClass().getResourceAsStream("/test-organisation-anlass-links.json")) {
      links = objectMapper.readValue(is, new TypeReference<List<OrganisationAnlassLink>>() {
      });
    }

    // set relations and sample dates
    // first record belongs to org1, second to org2 (same Anlass)
    links.get(0).setOrganisation(org1);
    links.get(0).setAnlass(anlass);
    links.get(0).setVerlaengerungsDate(LocalDateTime.now().minusDays(2));

    links.get(1).setOrganisation(org2);
    links.get(1).setAnlass(anlass);
    links.get(1).setVerlaengerungsDate(LocalDateTime.now().minusDays(1));

    organisationAnlassLinkRepository.saveAll(links);
  }

  @Test
  @DisplayName("Should save OrganisationAnlassLink and find it by ID")
  void testCreateAndRead() {
    OrganisationAnlassLink first = organisationAnlassLinkRepository.findAll().get(0);
    Optional<OrganisationAnlassLink> found = organisationAnlassLinkRepository.findById(
        first.getId());
    assertThat(found).isPresent();
    assertThat(found.get().getOrganisation().getId()).isEqualTo(first.getOrganisation().getId());
    assertThat(found.get().getAnlass().getId()).isEqualTo(anlass.getId());
  }

  @Test
  @DisplayName("Should update reminder flags")
  void testUpdate() {
    OrganisationAnlassLink oal = organisationAnlassLinkRepository.findAll().get(0);
    boolean newVal = !oal.isReminderMeldeschlussSent();
    oal.setReminderMeldeschlussSent(newVal);
    organisationAnlassLinkRepository.save(oal);

    OrganisationAnlassLink reloaded = organisationAnlassLinkRepository.findById(oal.getId())
        .orElseThrow();
    assertThat(reloaded.isReminderMeldeschlussSent()).isEqualTo(newVal);
  }

  @Test
  @DisplayName("Should delete OrganisationAnlassLink")
  void testDelete() {
    List<OrganisationAnlassLink> all = organisationAnlassLinkRepository.findAll();
    int initial = all.size();
    OrganisationAnlassLink toDelete = all.get(0);
    organisationAnlassLinkRepository.delete(toDelete);
    assertThat(organisationAnlassLinkRepository.findById(toDelete.getId())).isNotPresent();
    assertThat(organisationAnlassLinkRepository.findAll().size()).isEqualTo(initial - 1);
  }

  @Test
  @DisplayName("Should find by Organisation and Anlass")
  void testFindByOrganisationAndAnlass() {
    List<OrganisationAnlassLink> result = organisationAnlassLinkRepository.findByOrganisationAndAnlass(
        org1, anlass);
    assertThat(result).hasSize(1);
    assertThat(result.get(0).getOrganisation().getId()).isEqualTo(org1.getId());
  }

  @Test
  @DisplayName("Should find all by Anlass")
  void testFindByAnlass() {
    List<OrganisationAnlassLink> result = organisationAnlassLinkRepository.findByAnlass(anlass);
    assertThat(result).hasSize(links.size());
  }
}
