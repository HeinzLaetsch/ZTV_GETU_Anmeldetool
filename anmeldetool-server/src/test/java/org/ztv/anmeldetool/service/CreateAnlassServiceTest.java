package org.ztv.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterSlotDTO;
import org.ztv.anmeldetool.util.AnlassMapper;

@ExtendWith(MockitoExtension.class)
class CreateAnlassServiceTest {
  @Mock
  private AnlassRepository anlassRepo;
  @Mock
  private AnlassMapper anlassMapper;
  @Mock
  private OrganisationService organisationService;
  @InjectMocks
  private AnlassService service;

  private AnlassDTO.AnlassDTOBuilder validAnlass() {
    return AnlassDTO.builder().anlassBezeichnung(" Testanlass ").ort("Zuerich").halle("Turnhalle")
        .organisatorId(UUID.randomUUID()).tiTu(TiTuEnum.Alle)
        .tiefsteKategorie(KategorieEnum.K1).hoechsteKategorie(KategorieEnum.K7)
        .anmeldungBeginn(LocalDateTime.of(2027, 1, 1, 0, 0))
        .erfassenGeschlossen(LocalDateTime.of(2027, 2, 1, 0, 0))
        .crossKategorieAenderungenGeschlossen(LocalDateTime.of(2027, 2, 2, 0, 0))
        .aenderungenInKategorieGeschlossen(LocalDateTime.of(2027, 2, 3, 0, 0))
        .aenderungenNichtMehrErlaubt(LocalDateTime.of(2027, 2, 4, 0, 0))
        .startDatum(LocalDateTime.of(2027, 3, 1, 0, 0))
        .endDatum(LocalDateTime.of(2027, 3, 2, 0, 0))
        .wertungsrichterSlots(List.of(validSlot().build()));
  }

  private WertungsrichterSlotDTO.WertungsrichterSlotDTOBuilder validSlot() {
    return WertungsrichterSlotDTO.builder().brevet(1).reihenfolge(1)
        .tag(LocalDate.of(2027, 3, 1)).start_zeit(LocalTime.of(8, 0))
        .end_zeit(LocalTime.of(12, 0)).beschreibung(" Vormittag ");
  }

  @Test
  void createsActiveUnpublishedAnlassWithOrganisator() {
    AnlassDTO input = validAnlass().published(true).build();
    Organisation organisator = new Organisation();
    when(organisationService.findById(input.getOrganisatorId())).thenReturn(organisator);
    when(anlassRepo.save(any(Anlass.class))).thenAnswer(invocation -> invocation.getArgument(0));
    when(anlassMapper.toDto(any(Anlass.class))).thenReturn(input);

    assertThat(service.createAnlass(input)).isEqualTo(input);

    ArgumentCaptor<Anlass> captor = ArgumentCaptor.forClass(Anlass.class);
    verify(anlassRepo).save(captor.capture());
    Anlass created = captor.getValue();
    assertThat(created.getId()).isNotNull();
    assertThat(created.getAnlassBezeichnung()).isEqualTo("Testanlass");
    assertThat(created.getOrganisator()).isSameAs(organisator);
    assertThat(created.isAktiv()).isTrue();
    assertThat(created.isPublished()).isFalse();
    assertThat(created.getOrganisationenLinks()).isEmpty();
    assertThat(created.getWertungsrichterSlots()).hasSize(1);
    assertThat(created.getWertungsrichterSlots().getFirst().getAnlass()).isSameAs(created);
    assertThat(created.getWertungsrichterSlots().getFirst().getBeschreibung()).isEqualTo("Vormittag");
    assertThat(created.getAnmeldungBeginn()).isEqualTo(input.getAnmeldungBeginn());
  }

  @Test
  void rejectsExistingId() {
    assertThatThrownBy(() -> service.createAnlass(validAnlass().id(UUID.randomUUID()).build()))
        .isInstanceOf(ResponseStatusException.class);
    verifyNoInteractions(anlassRepo);
  }

  @Test
  void rejectsMissingRequiredFields() {
    assertThatThrownBy(() -> service.createAnlass(validAnlass().anlassBezeichnung(" ").build()))
        .isInstanceOf(ResponseStatusException.class);
    verifyNoInteractions(anlassRepo);
  }

  @Test
  void rejectsReversedDates() {
    assertThatThrownBy(() -> service.createAnlass(validAnlass()
        .endDatum(LocalDateTime.of(2027, 1, 1, 0, 0)).build()))
        .isInstanceOf(ResponseStatusException.class);
    verifyNoInteractions(anlassRepo);
  }

  @Test
  void rejectsMissingDeadline() {
    assertThatThrownBy(() -> service.createAnlass(validAnlass().anmeldungBeginn(null).build()))
        .isInstanceOf(ResponseStatusException.class);
    verifyNoInteractions(anlassRepo);
  }

  @Test
  void rejectsReversedCategories() {
    assertThatThrownBy(() -> service.createAnlass(validAnlass()
        .tiefsteKategorie(KategorieEnum.K7).hoechsteKategorie(KategorieEnum.K1).build()))
        .isInstanceOf(ResponseStatusException.class);
    verifyNoInteractions(anlassRepo);
  }

  @Test
  void createsMultipleSlotsWithNewIdsAndSequentialOrder() {
    AnlassDTO input = validAnlass().wertungsrichterSlots(List.of(validSlot().build(),
        validSlot().brevet(2).reihenfolge(99).tag(LocalDate.of(2027, 3, 2)).build())).build();
    when(anlassRepo.save(any(Anlass.class))).thenAnswer(invocation -> invocation.getArgument(0));
    service.createAnlass(input);
    ArgumentCaptor<Anlass> captor = ArgumentCaptor.forClass(Anlass.class);
    verify(anlassRepo).save(captor.capture());
    Anlass created = captor.getValue();
    assertThat(created.getWertungsrichterSlots()).hasSize(2);
    assertThat(created.getWertungsrichterSlots()).allSatisfy(slot -> {
      assertThat(slot.getId()).isNotNull();
      assertThat(slot.getAnlass()).isSameAs(created);
      assertThat(slot.isAktiv()).isTrue();
    });
    assertThat(created.getWertungsrichterSlots()).extracting("reihenfolge").containsExactly(1, 2);
    assertThat(created.getWertungsrichterSlots().get(1).getBrevet()).isEqualTo(WertungsrichterBrevetEnum.Brevet_2);
    assertThat(created.getWertungsrichterSlots().getFirst().getId())
        .isNotEqualTo(created.getWertungsrichterSlots().get(1).getId());
  }

  @Test
  void rejectsMissingSlots() {
    assertThatThrownBy(() -> service.createAnlass(validAnlass().wertungsrichterSlots(null).build()))
        .isInstanceOf(ResponseStatusException.class);
    assertThatThrownBy(() -> service.createAnlass(validAnlass().wertungsrichterSlots(List.of()).build()))
        .isInstanceOf(ResponseStatusException.class);
    verifyNoInteractions(anlassRepo);
  }

  @Test
  void rejectsInvalidSlotFieldsAndExistingIds() {
    for (WertungsrichterSlotDTO invalid : List.of(validSlot().id(UUID.randomUUID()).build(),
        validSlot().brevet(3).build(), validSlot().tag(null).build())) {
      assertThatThrownBy(() -> service.createAnlass(validAnlass().wertungsrichterSlots(List.of(invalid)).build()))
          .isInstanceOf(ResponseStatusException.class);
    }
    verifyNoInteractions(anlassRepo);
  }

  @Test
  void acceptsOptionalTimesAndComments() {
    AnlassDTO input = validAnlass().wertungsrichterSlots(List.of(
        validSlot().start_zeit(null).end_zeit(null).beschreibung(null).build(),
        validSlot().start_zeit(null).beschreibung(" ").build(),
        validSlot().end_zeit(null).beschreibung("").build())).build();
    when(anlassRepo.save(any(Anlass.class))).thenAnswer(invocation -> invocation.getArgument(0));

    service.createAnlass(input);

    ArgumentCaptor<Anlass> captor = ArgumentCaptor.forClass(Anlass.class);
    verify(anlassRepo).save(captor.capture());
    var slots = captor.getValue().getWertungsrichterSlots();
    assertThat(slots).hasSize(3).allSatisfy(slot -> assertThat(slot.getBeschreibung()).isEmpty());
    assertThat(slots.getFirst().getStart_zeit()).isNull();
    assertThat(slots.getFirst().getEnd_zeit()).isNull();
    assertThat(slots.get(1).getStart_zeit()).isNull();
    assertThat(slots.get(1).getEnd_zeit()).isEqualTo(LocalTime.of(12, 0));
    assertThat(slots.get(2).getStart_zeit()).isEqualTo(LocalTime.of(8, 0));
    assertThat(slots.get(2).getEnd_zeit()).isNull();
  }

  @Test
  void rejectsSlotsOutsideEventAndInvalidTimeRanges() {
    for (WertungsrichterSlotDTO invalid : List.of(validSlot().tag(LocalDate.of(2027, 2, 28)).build(),
        validSlot().tag(LocalDate.of(2027, 3, 3)).build(),
        validSlot().end_zeit(LocalTime.of(8, 0)).build(),
        validSlot().end_zeit(LocalTime.of(7, 0)).build())) {
      assertThatThrownBy(() -> service.createAnlass(validAnlass().wertungsrichterSlots(List.of(invalid)).build()))
          .isInstanceOf(ResponseStatusException.class);
    }
    verifyNoInteractions(anlassRepo);
  }
}