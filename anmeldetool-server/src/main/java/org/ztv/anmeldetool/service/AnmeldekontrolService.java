package org.ztv.anmeldetool.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.VereinsStartDTO;
import org.ztv.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;
import org.ztv.anmeldetool.util.OrganisationPersonLinkMapper;

import java.util.Comparator;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

/**
 *
 * @author heinz
 */
@Service("anlassKontrolService")
@Slf4j
@AllArgsConstructor
public class AnmeldekontrolService {
  private final OrganisationPersonLinkMapper organisationPersonLinkMapper;

  private final OrganisationAnlassLinkService organisationAnlassLinkService;

  private final AnlassMapper anlassMapper;

  private final OrganisationMapper orgMapper;
  private final PersonAnlassLinkService personAnlassLinkSrv;
  private final AnlassService anlassSrv;

  // Helper method to dynamically set field values
  private void setFieldValue(VereinsStartDTO obj, String fieldName, Object value) {
    try {
      java.lang.reflect.Field field = obj.getClass().getDeclaredField(fieldName);
      field.setAccessible(true);
      field.set(obj, value);
    } catch (Exception e) {
      throw new RuntimeException("Error setting field " + fieldName, e);
    }
  }

  private void calculateCategoryCounts(VereinsStartDTO vereinsStart, List<TeilnehmerAnlassLink> participations) {
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K1, TiTuEnum.Alle);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K2, TiTuEnum.Alle);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K3, TiTuEnum.Alle);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K4, TiTuEnum.Alle);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K5, TiTuEnum.Tu);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K5A, TiTuEnum.Ti);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K5B, TiTuEnum.Ti);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K6, TiTuEnum.Alle);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.KH, TiTuEnum.Tu);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.KD, TiTuEnum.Ti);
    calculateTiTuCounts(vereinsStart, participations, KategorieEnum.K7, TiTuEnum.Alle);
  }

  private void calculateTiTuCounts(VereinsStartDTO vereinsStart, List<TeilnehmerAnlassLink> participations,
      KategorieEnum category, TiTuEnum titu) {

    // Set Ti counts
    if (TiTuEnum.Ti.equals(titu) || TiTuEnum.Alle.equals(titu)) {
      calculateCounts(vereinsStart, participations, category, TiTuEnum.Ti);
    }

    // Set Tu counts
    if (TiTuEnum.Tu.equals(titu) || TiTuEnum.Alle.equals(titu)) {
      calculateCounts(vereinsStart, participations, category, TiTuEnum.Tu);
    }
  }

  private void calculateCounts(VereinsStartDTO vereinsStart, List<TeilnehmerAnlassLink> participations, KategorieEnum category,
      TiTuEnum titu) {
    List<TeilnehmerAnlassLink> filteredParticipations = filterParticipations(participations, category, titu);

    String countFieldName = category.name().substring(0, 1).toLowerCase() + category.name().substring(1) + "_" + titu.name();
    String talsFieldName = "tals_" + category.name() + "_" + titu.name();

    setFieldValue(vereinsStart, countFieldName, filteredParticipations.size());
    setFieldValue(vereinsStart, talsFieldName, filteredParticipations);
  }

  private List<TeilnehmerAnlassLink> filterParticipations(List<TeilnehmerAnlassLink> participations,
      KategorieEnum category, TiTuEnum tiTu) {
    return participations.stream()
        .filter(tal -> tal.isAktiv() &&
            category.equals(tal.getKategorie()) &&
            tiTu.equals(tal.getTeilnehmer().getTiTu()))
        .collect(Collectors.toList());
  }

  private void calculateTotals(VereinsStartDTO vereinsStart) {
    // Calculate total for BR1 (K1-K4)
    int totalBr1 = vereinsStart.getK1_Ti() + vereinsStart.getK1_Tu() +
        vereinsStart.getK2_Ti() + vereinsStart.getK2_Tu() +
        vereinsStart.getK3_Ti() + vereinsStart.getK3_Tu() +
        vereinsStart.getK4_Ti() + vereinsStart.getK4_Tu();
    vereinsStart.setTotal_br1(totalBr1);

    // Calculate total for BR2 (K5-K7, KD, KH)
    int totalBr2 = vereinsStart.getK5A_Ti() + vereinsStart.getK5B_Ti() +
        vereinsStart.getK5_Tu() + vereinsStart.getK6_Ti() +
        vereinsStart.getK6_Tu() + vereinsStart.getKD_Ti() +
        vereinsStart.getKH_Tu() + vereinsStart.getK7_Ti() +
        vereinsStart.getK7_Tu();
    vereinsStart.setTotal_br2(totalBr2);

    // Calculate overall total
    vereinsStart.setTotal(vereinsStart.getTotal_br1() + vereinsStart.getTotal_br2());
  }

  private VereinsStartDTO createVereinsStartDto(Anlass anlass, Organisation org) {
    VereinsStartDTO vereinsStart = new VereinsStartDTO();
    vereinsStart.setVereinsName(org.getName());

    // Get all active participations for this organization
    List<TeilnehmerAnlassLink> allParticipations = anlassSrv.getTeilnahmen(anlass, org, true);

    // Calculate judge counts
    vereinsStart.setBr1(personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass, org,
        WertungsrichterBrevetEnum.Brevet_1).size());
    vereinsStart.setBr2(personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass, org,
        WertungsrichterBrevetEnum.Brevet_2).size());

    // Calculate participation counts by category
    calculateCategoryCounts(vereinsStart, allParticipations);

    // Calculate totals
    calculateTotals(vereinsStart);

    return vereinsStart;
  }

  public AnmeldeKontrolleDTO getAnmeldeKontrolle(Anlass anlass, Organisation organisation) {

    List<Organisation> orgs = organisationAnlassLinkService.getVereinsStarts(anlass);
    if (organisation != null) {
      orgs = orgs.stream()
          .filter(org -> org.getId().equals(organisation.getId()))
          .toList();
    }

    List<VereinsStartDTO> vereinsStarts = orgs.stream()
        .map(org -> createVereinsStartDto(anlass, org))
        .toList();

    return new AnmeldeKontrolleDTO(anlassMapper.toDto(anlass),
        vereinsStarts,
        orgMapper.toDto(anlass.getOrganisator()));
  }

  List<TeilnehmerAnlassLink> sortParticipants(List<TeilnehmerAnlassLink> participants) {
      AtomicInteger i = new AtomicInteger();
      participants = participants.stream()
          .peek(participant -> log.debug(
              "Participant before sorting: index {}, Name {}, TiTu: {}, Kategorie: {}, Abteilung: {}, Anlage: {}, Startgeraet: {}",
              i.getAndIncrement(),
              participant != null && participant.getTeilnehmer() != null ? participant.getTeilnehmer().getName() : "null",
              participant != null && participant.getTeilnehmer() != null ? participant.getTeilnehmer().getTiTu() : "null",
              participant != null ? participant.getKategorie() : "null",
              participant != null ? participant.getAbteilung() : "null",
              participant != null ? participant.getAnlage() : "null",
              participant != null ? participant.getStartgeraet() : "null"))
          .filter(participant -> (
              participant != null && participant.getTeilnehmer() != null && participant.getTeilnehmer().getTiTu() != null)
              && participant.getKategorie() != null
              && participant.getAbteilung() != null
              && participant.getAnlage() != null
              && participant.getStartgeraet() != null)
          .sorted(
              //participants.sort(
              Comparator.nullsFirst(
                  Comparator.comparing(TeilnehmerAnlassLink::getKategorie)
//                      .thenComparing(TeilnehmerAnlassLink::getKategorie)
                      .thenComparing(TeilnehmerAnlassLink::getAbteilung)
                      .thenComparing(TeilnehmerAnlassLink::getAnlage)
                      .thenComparing(TeilnehmerAnlassLink::getStartgeraet)
                      .thenComparing(link -> link.getTeilnehmer().getTiTu())
              ))
          .toList();
    return participants;
  }

  public Map<Organisation, HashMap<String, Boolean>> getAufgeteilteRiegen(Anlass anlass) {
    List<Organisation> orgs = organisationAnlassLinkService.getVereinsStarts(anlass);
    var aufgeteilteRiegen = new HashMap<Organisation, HashMap<String, Boolean>>();
    orgs.forEach(org -> {
      List<TeilnehmerAnlassLink> allParticipations = anlassSrv.getTeilnahmen(anlass, org, true);

      allParticipations = sortParticipants(allParticipations);
      AtomicReference<TiTuEnum> tiTu = new AtomicReference<>(TiTuEnum.Alle);
      AtomicReference<KategorieEnum> kategorie = new AtomicReference<>(KategorieEnum.KEIN_START);
      AtomicReference<AnlageEnum> anlage = new AtomicReference<>(AnlageEnum.UNDEFINED);
      AtomicReference<GeraetEnum> geraet = new AtomicReference<>(GeraetEnum.UNDEFINED);
      var aufgeteilt = new HashMap<String, Boolean>();
      allParticipations.forEach(participant -> {
        if (tiTu.get() != participant.getTeilnehmer().getTiTu() || kategorie.get() != participant.getKategorie()) {
          tiTu.set(participant.getTeilnehmer().getTiTu());
          kategorie.set(participant.getKategorie());
          aufgeteilt.put(tiTu.get().name()+participant.getKategorie().name(), false);
          anlage.set(participant.getAnlage());
          geraet.set(participant.getStartgeraet());
        } else {
          if (participant.getAnlage() != anlage.get() || participant.getStartgeraet() != geraet.get()) {
            log.info("Split found for Organisation {}, Kategorie: {}, Anlage: {}/{}, Geraet: {}/{}", org.getName(), participant.getKategorie(), anlage.get(),
                participant.getAnlage(), geraet.get(), participant.getStartgeraet());
            aufgeteilt.put(tiTu.get().name()+participant.getKategorie().name(), true);
            anlage.set(participant.getAnlage());
            geraet.set(participant.getStartgeraet());
          }
        }
      });
      aufgeteilteRiegen.put(org, aufgeteilt);
    });
    return aufgeteilteRiegen;
  }
}


