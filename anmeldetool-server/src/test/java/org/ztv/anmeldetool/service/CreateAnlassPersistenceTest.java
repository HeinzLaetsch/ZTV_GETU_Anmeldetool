package org.ztv.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.when;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;
import org.springframework.boot.jpa.test.autoconfigure.TestEntityManager;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterSlotDTO;
import org.ztv.anmeldetool.util.AnlassMapper;

@DataJpaTest(properties = { "spring.jpa.hibernate.ddl-auto=create-drop", "spring.jpa.generate-ddl=true",
        "spring.sql.init.mode=never" }, showSql = false)
@Import(AnlassService.class)
class CreateAnlassPersistenceTest {
    @Autowired
    private TestEntityManager entityManager;
    @Autowired
    private AnlassService service;
    @MockitoBean
    private AnlassMapper anlassMapper;
    @MockitoBean
    private OrganisationService organisationService;
    @MockitoBean
    private OrganisationAnlassLinkService organisationAnlassLinkService;

    @Test
    void deletesEventAndAllItsSlotsWithoutDeletingOtherEventsOrOrganizer() {
        Verband verband = new Verband();
        verband.setVerband("DELETE");
        entityManager.persist(verband);
        Organisation organisator = new Organisation();
        organisator.setName("Shared organizer");
        organisator.setVerband(verband);
        entityManager.persist(organisator);
        Anlass event = new Anlass();
        event.setOrganisator(organisator);
        WertungsrichterSlot first = new WertungsrichterSlot();
        first.setAnlass(event);
        first.setBrevet(WertungsrichterBrevetEnum.Brevet_1);
        WertungsrichterSlot second = new WertungsrichterSlot();
        second.setAnlass(event);
        second.setBrevet(WertungsrichterBrevetEnum.Brevet_2);
        event.getWertungsrichterSlots().addAll(List.of(first, second));
        entityManager.persist(event);
        Anlass other = new Anlass();
        other.setOrganisator(organisator);
        WertungsrichterSlot otherSlot = new WertungsrichterSlot();
        otherSlot.setAnlass(other);
        otherSlot.setBrevet(WertungsrichterBrevetEnum.Brevet_1);
        other.getWertungsrichterSlots().add(otherSlot);
        entityManager.persistAndFlush(other);
        entityManager.clear();

        service.deleteAnlass(event.getId());
        entityManager.clear();

        assertThat(entityManager.find(Anlass.class, event.getId())).isNull();
        assertThat(entityManager.find(WertungsrichterSlot.class, first.getId())).isNull();
        assertThat(entityManager.find(WertungsrichterSlot.class, second.getId())).isNull();
        assertThat(entityManager.find(Anlass.class, other.getId())).isNotNull();
        assertThat(entityManager.find(WertungsrichterSlot.class, otherSlot.getId())).isNotNull();
        assertThat(entityManager.find(Organisation.class, organisator.getId())).isNotNull();
    }

    @Test
    void updatesExistingEventAndSlotsWithoutChangingTheirIdentity() {
        Verband verband = new Verband();
        verband.setVerband("EDIT");
        entityManager.persist(verband);
        Organisation organisator = new Organisation();
        organisator.setName("Existing organizer");
        organisator.setVerband(verband);
        entityManager.persist(organisator);
        Anlass event = new Anlass();
        event.setAnlassBezeichnung("Before editing");
        event.setOrganisator(organisator);
        event.setBank("Existing bank");
        event.setPublished(true);
        WertungsrichterSlot retained = new WertungsrichterSlot();
        retained.setAnlass(event);
        retained.setBrevet(WertungsrichterBrevetEnum.Brevet_1);
        WertungsrichterSlot removed = new WertungsrichterSlot();
        removed.setAnlass(event);
        removed.setBrevet(WertungsrichterBrevetEnum.Brevet_1);
        event.getWertungsrichterSlots().addAll(List.of(retained, removed));
        entityManager.persistAndFlush(event);
        entityManager.clear();
        AnlassDTO update = AnlassDTO.builder().id(event.getId()).anlassBezeichnung("After editing")
                .wertungsrichterSlots(List.of(
                        WertungsrichterSlotDTO.builder().id(retained.getId()).brevet(2)
                                .tag(LocalDate.of(2027, 3, 1)).beschreibung("Updated slot").build(),
                        WertungsrichterSlotDTO.builder().brevet(1).egalSlot(true).build()))
                .build();
        doAnswer(invocation -> {
            Anlass target = invocation.getArgument(1);
            target.setAnlassBezeichnung(update.getAnlassBezeichnung());
            return null;
        }).when(anlassMapper).updateFromDto(any(AnlassDTO.class), any(Anlass.class));

        service.updateAnlass(update);
        entityManager.flush();
        entityManager.clear();
        Anlass reloaded = entityManager.find(Anlass.class, event.getId());
        assertThat(reloaded.getAnlassBezeichnung()).isEqualTo("After editing");
        assertThat(reloaded.getOrganisator().getId()).isEqualTo(organisator.getId());
        assertThat(reloaded.getBank()).isEqualTo("Existing bank");
        assertThat(reloaded.isPublished()).isTrue();
        assertThat(reloaded.getWertungsrichterSlots()).hasSize(2).allSatisfy(slot -> {
            assertThat(slot.getAnlass().getId()).isEqualTo(event.getId());
            assertThat(slot.isAktiv()).isTrue();
        });
        assertThat(entityManager.find(WertungsrichterSlot.class, retained.getId()).getBrevet())
                .isEqualTo(WertungsrichterBrevetEnum.Brevet_2);
        assertThat(entityManager.find(WertungsrichterSlot.class, removed.getId())).isNull();
    }

    @Test
    void persistsAllSlotsAndTheirAnlassForeignKeysWithCascade() {
        Verband verband = new Verband();
        verband.setVerband("TEST");
        entityManager.persist(verband);
        Organisation organisator = new Organisation();
        organisator.setName("Testverein");
        organisator.setVerband(verband);
        entityManager.persistAndFlush(organisator);
        when(organisationService.findById(organisator.getId())).thenReturn(organisator);
        when(anlassMapper.toDto(any(Anlass.class))).thenAnswer(invocation -> {
            Anlass saved = invocation.getArgument(0);
            return AnlassDTO.builder().id(saved.getId()).build();
        });
        WertungsrichterSlotDTO first = WertungsrichterSlotDTO.builder().brevet(1)
                .tag(LocalDate.of(2027, 3, 1)).start_zeit(LocalTime.of(8, 0))
                .end_zeit(LocalTime.of(12, 0)).beschreibung("Vormittag").build();
        WertungsrichterSlotDTO second = WertungsrichterSlotDTO.builder().brevet(2)
                .tag(LocalDate.of(2027, 3, 2)).start_zeit(LocalTime.of(13, 0))
                .end_zeit(LocalTime.of(17, 0)).beschreibung("Nachmittag").build();
        WertungsrichterSlotDTO withoutOptionalFields = WertungsrichterSlotDTO.builder().brevet(1)
                .tag(LocalDate.of(2027, 3, 1)).build();
        AnlassDTO input = AnlassDTO.builder().anlassBezeichnung("Testanlass").ort("Zuerich").halle("Turnhalle")
                .organisatorId(organisator.getId()).tiTu(TiTuEnum.Alle)
                .iban(" CH93 0076 2011 6238 5295 7 ").smQuali(true).ausserkantonal(true)
                .tiefsteKategorie(KategorieEnum.K1).hoechsteKategorie(KategorieEnum.K7)
                .anmeldungBeginn(LocalDateTime.of(2027, 1, 1, 0, 0))
                .erfassenGeschlossen(LocalDateTime.of(2027, 2, 1, 0, 0))
                .crossKategorieAenderungenGeschlossen(LocalDateTime.of(2027, 2, 2, 0, 0))
                .aenderungenInKategorieGeschlossen(LocalDateTime.of(2027, 2, 3, 0, 0))
                .aenderungenNichtMehrErlaubt(LocalDateTime.of(2027, 2, 4, 0, 0))
                .startDatum(LocalDateTime.of(2027, 3, 1, 0, 0))
                .endDatum(LocalDateTime.of(2027, 3, 2, 0, 0))
                .wertungsrichterSlots(List.of(first, second, withoutOptionalFields)).build();

        AnlassDTO result = service.createAnlass(input);
        entityManager.flush();
        entityManager.clear();
        Anlass reloaded = entityManager.find(Anlass.class, result.getId());

        assertThat(reloaded.getIban()).isEqualTo("CH93 0076 2011 6238 5295 7");
        assertThat(reloaded.isSmQuali()).isTrue();
        assertThat(reloaded.isAusserkantonal()).isTrue();
        assertThat(reloaded.getWertungsrichterSlots()).hasSize(3).allSatisfy(slot -> {
            assertThat(slot.getId()).isNotNull();
            assertThat(slot.getAnlass().getId()).isEqualTo(reloaded.getId());
            assertThat(slot.isAktiv()).isTrue();
        });
        assertThat(reloaded.getWertungsrichterSlots()).extracting("beschreibung")
                .containsExactlyInAnyOrder("Vormittag", "Nachmittag", "");
        assertThat(reloaded.getWertungsrichterSlots()).extracting("reihenfolge")
                .containsExactlyInAnyOrder(1, 2, 3);
        assertThat(reloaded.getWertungsrichterSlots()).filteredOn(slot -> slot.getReihenfolge() == 3)
                .singleElement().satisfies(slot -> {
                    assertThat(slot.getStart_zeit()).isNull();
                    assertThat(slot.getEnd_zeit()).isNull();
                    assertThat(slot.getBeschreibung()).isEmpty();
                });
    }
}