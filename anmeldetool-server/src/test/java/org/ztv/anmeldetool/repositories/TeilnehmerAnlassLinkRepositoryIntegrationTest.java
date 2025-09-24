package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
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
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.models.VerbandEnum;

@SpringBootTest
@Transactional
class TeilnehmerAnlassLinkRepositoryIntegrationTest extends AbstractRepositoryTest {

  private final TeilnehmerAnlassLinkRepository linkRepository;
  private final OrganisationsRepository organisationRepository;
  private final TeilnehmerRepository teilnehmerRepository;
  private final AnlassRepository anlassRepository;

  private NotenblaetterRepository notenblattRepository;
  private List<TeilnehmerAnlassLink> testLinks = new ArrayList<>();
  private Anlass testAnlass;
  private Teilnehmer testTeilnehmer1;
  private Organisation testOrganisation1;

  @Autowired
  public TeilnehmerAnlassLinkRepositoryIntegrationTest(VerbandsRepository verbandsRepository,
      TeilnehmerAnlassLinkRepository linkRepository,
      OrganisationsRepository organisationRepository,
      TeilnehmerRepository teilnehmerRepository,
      AnlassRepository anlassRepository,
      NotenblaetterRepository notenblattRepository
  ) {
    super(verbandsRepository);
    this.linkRepository = linkRepository;
    this.organisationRepository = organisationRepository;
    this.teilnehmerRepository = teilnehmerRepository;
    this.anlassRepository = anlassRepository;
    this.notenblattRepository = notenblattRepository;
  }

  @BeforeEach
  void setUp() throws IOException {
    // 1. Setup Verband, Organisation, Person, Teilnehmer, Anlass
    Verband verband = new Verband();
    verband.setVerbandLong(VerbandEnum.ZTV.name());
    verband.setVerband(VerbandEnum.ZTV.name());
    verbandsRepository.save(verband);

    List<Organisation> orgs = new ArrayList<>();
    try (InputStream s = getClass().getResourceAsStream("/test-organisations.json")) {
      List<Organisation> loaded = objectMapper.readValue(s, new TypeReference<>() {
      });
      loaded.forEach(o -> o.setVerband(verband));
      orgs.addAll(organisationRepository.saveAll(loaded));
    }
    testOrganisation1 = orgs.get(0);

    List<Teilnehmer> teilnehmers = new ArrayList<>();
    try (InputStream s = getClass().getResourceAsStream("/test-teilnehmer.json")) {
      List<Teilnehmer> loaded = objectMapper.readValue(s, new TypeReference<>() {
      });
      loaded.get(0).setOrganisation(orgs.get(0));
      loaded.get(1).setOrganisation(orgs.get(1));
      teilnehmers.addAll(teilnehmerRepository.saveAll(loaded));
    }
    testTeilnehmer1 = teilnehmers.get(0);

    try (InputStream s = getClass().getResourceAsStream("/test-anlass.json")) {
      Anlass loaded = objectMapper.readValue(s, new TypeReference<List<Anlass>>() {
      }).get(0);
      loaded.setOrganisator(orgs.get(0));
      testAnlass = anlassRepository.save(loaded);
    }

    // 2. Load Link data and create full entities
    try (InputStream s = getClass().getResourceAsStream("/test-teilnehmer-anlass-link.json")) {
      List<TeilnehmerAnlassLink> loadedLinks = objectMapper.readValue(s, new TypeReference<>() {
      });

      // Link first two to testTeilnehmer1 from org1
      TeilnehmerAnlassLink link1 = loadedLinks.get(0);
      link1.setAnlass(testAnlass);
      link1.setTeilnehmer(teilnehmers.get(0));
      link1.setOrganisation(orgs.get(0));
      link1.setNotenblatt(notenblattRepository.save(new Notenblatt()));
      testLinks.add(linkRepository.save(link1));

      TeilnehmerAnlassLink link2 = loadedLinks.get(1);
      link2.setAnlass(testAnlass);
      link2.setTeilnehmer(teilnehmers.get(0)); // Same teilnehmer, different link properties
      link2.setOrganisation(orgs.get(0));
      link2.setNotenblatt(notenblattRepository.save(new Notenblatt()));
      testLinks.add(linkRepository.save(link2));

      // Link next two to testTeilnehmer2 from org2
      TeilnehmerAnlassLink link3 = loadedLinks.get(2);
      link3.setAnlass(testAnlass);
      link3.setTeilnehmer(teilnehmers.get(1));
      link3.setOrganisation(orgs.get(1));
      link3.setNotenblatt(notenblattRepository.save(new Notenblatt()));
      testLinks.add(linkRepository.save(link3));
    }
  }

  @Test
  @DisplayName("Should create and read a TeilnehmerAnlassLink")
  void testCreateAndRead() {
    Optional<TeilnehmerAnlassLink> found = linkRepository.findById(testLinks.get(0).getId());
    assertThat(found).isPresent();
    assertThat(found.get().getKategorie()).isEqualTo(KategorieEnum.K1);
    assertThat(found.get().getTeilnehmer()).isEqualTo(testTeilnehmer1);
  }

  @Test
  @DisplayName("Should find by Teilnehmer and Anlass")
  void testFindByTeilnehmerAndAnlass() {
    List<TeilnehmerAnlassLink> found = linkRepository.findByTeilnehmerAndAnlass(testTeilnehmer1,
        testAnlass);
    assertThat(found).hasSize(2);
  }

  @Test
  @DisplayName("Should find by Anlass and Teilnehmer")
  void testFindByAnlassAndTeilnehmer() {
    // TODO Methode macht keinen Sinn
    // Optional<TeilnehmerAnlassLink> found = linkRepository.findByAnlassAndTeilnehmer(testAnlass, testTeilnehmer1);
    // assertThat(found);
  }

  @Test
  @DisplayName("Should find by Anlass and Organisation")
  void testFindByAnlassAndOrganisation() {
    List<TeilnehmerAnlassLink> found = linkRepository.findByAnlassAndOrganisation(testAnlass,
        testOrganisation1);
    assertThat(found).hasSize(2);
  }

  @Test
  @DisplayName("Should find by Anlass and Organisation excluding certain statuses")
  void testFindByAnlassAndOrganisationExclude() {
    testLinks.get(0).setMeldeStatus(MeldeStatusEnum.NICHTGESTARTET);
    linkRepository.save(testLinks.get(0));

    List<TeilnehmerAnlassLink> found = linkRepository.findByAnlassAndOrganisationExclude(
        testAnlass, testOrganisation1, List.of(MeldeStatusEnum.NICHTGESTARTET));

    assertThat(found).hasSize(1);
    assertThat(found.get(0).getMeldeStatus()).isEqualTo(MeldeStatusEnum.STARTET);
  }

  @Test
  @DisplayName("Should find top by startnummer ordered descending")
  void findTopByStartnummerNotNullOrderByStartnummerDesc() {
    Optional<TeilnehmerAnlassLink> found = linkRepository.findTopByStartnummerNotNullOrderByStartnummerDesc();
    assertThat(found).isPresent();
    assertThat(found.get().getStartnummer()).isEqualTo(201);
  }

  @Test
  @DisplayName("Should find distinct Abteilungen for an Anlass and Kategorie")
  void testFindDistinctByAnlassAndAktivAndKategorie() {
    List<AbteilungEnum> abteilungen = linkRepository.findDistinctByAnlassAndAktivAndKategorie(
        testAnlass.getId(), false, "K1");
    assertThat(abteilungen).hasSize(1).contains(AbteilungEnum.ABTEILUNG_1);
  }

  @Test
  @DisplayName("Should find distinct Anlagen for Anlass, Kategorie, and Abteilung")
  void testFindDistinctByAnlassAndAktivAndKategorieAndAbteilung() {
    List<AnlageEnum> anlagen = linkRepository.findDistinctByAnlassAndAktivAndKategorieAndAbteilung(
        testAnlass.getId(), false, "K5", AbteilungEnum.ABTEILUNG_2.name());
    assertThat(anlagen).hasSize(1).contains(AnlageEnum.ANLAGE_2);
  }
}
