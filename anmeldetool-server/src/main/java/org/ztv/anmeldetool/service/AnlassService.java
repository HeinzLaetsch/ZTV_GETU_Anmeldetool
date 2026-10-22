package org.ztv.anmeldetool.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.util.Pair;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.BenutzerDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterSlotDTO;
import org.ztv.anmeldetool.util.AnlassMapper;

/**
 *
 * @author heinz
 */
@Service("anlassService")
@Slf4j
@AllArgsConstructor
public class AnlassService extends AbstractBaseService<Anlass> {

  private final AnlassRepository anlassRepo;

  private final OrganisationAnlassLinkService organisationAnlassLinkService;

  private final TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

  private final PersonAnlassLinkRepository personAnlassLinkRepository;

  private final AnlassMapper anlassMapper;

  private final OrganisationService organisationService;

  @Transactional
  public AnlassDTO createAnlass(AnlassDTO dto) {
    if (dto.getId() != null || dto.getAnlassBezeichnung() == null
        || dto.getAnlassBezeichnung().isBlank() || dto.getOrt() == null || dto.getOrt().isBlank()
        || dto.getHalle() == null || dto.getHalle().isBlank() || dto.getOrganisatorId() == null
        || dto.getTiTu() == null || dto.getTiefsteKategorie() == null
        || dto.getHoechsteKategorie() == null) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pflichtangaben fehlen oder ID ist gesetzt");
    }
    if (dto.getTiefsteKategorie() == KategorieEnum.KEIN_START
        || dto.getHoechsteKategorie() == KategorieEnum.KEIN_START
        || dto.getTiefsteKategorie().ordinal() > dto.getHoechsteKategorie().ordinal()) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ungueltiger Kategorienbereich");
    }
    LocalDateTime[] dates = { dto.getAnmeldungBeginn(), dto.getErfassenGeschlossen(),
        dto.getCrossKategorieAenderungenGeschlossen(), dto.getAenderungenInKategorieGeschlossen(),
        dto.getAenderungenNichtMehrErlaubt(), dto.getStartDatum(), dto.getEndDatum() };
    for (int index = 0; index < dates.length; index++) {
      if (dates[index] == null || (index > 0 && dates[index].isBefore(dates[index - 1]))) {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ungueltige Datumsreihenfolge");
      }
    }
    Organisation organisator = organisationService.findById(dto.getOrganisatorId());
    Anlass anlass = new Anlass();
    anlass.setAnlassBezeichnung(dto.getAnlassBezeichnung().trim());
    anlass.setOrt(dto.getOrt().trim());
    anlass.setHalle(dto.getHalle().trim());
    anlass.setOrganisator(organisator);
    anlass.setTiTu(dto.getTiTu());
    anlass.setTiefsteKategorie(dto.getTiefsteKategorie());
    anlass.setHoechsteKategorie(dto.getHoechsteKategorie());
    anlass.setStartDate(dto.getStartDatum());
    anlass.setEndDate(dto.getEndDatum());
    anlass.setAnmeldungBeginn(dto.getAnmeldungBeginn());
    anlass.setErfassenGeschlossen(dto.getErfassenGeschlossen());
    anlass.setCrossKategorieAenderungenGeschlossen(dto.getCrossKategorieAenderungenGeschlossen());
    anlass.setAenderungenInKategorieGeschlossen(dto.getAenderungenInKategorieGeschlossen());
    anlass.setAenderungenNichtMehrErlaubt(dto.getAenderungenNichtMehrErlaubt());
    anlass.setAktiv(true);
    anlass.setPublished(false);
    addWertungsrichterSlots(anlass, dto.getWertungsrichterSlots());
    return anlassMapper.toDto(anlassRepo.save(anlass));
  }

  private void addWertungsrichterSlots(Anlass anlass, List<WertungsrichterSlotDTO> slots) {
    if (slots == null || slots.isEmpty()) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Mindestens ein Wertungsrichter-Slot ist erforderlich");
    }
    for (WertungsrichterSlotDTO input : slots) {
      if (input == null || input.getId() != null || input.getBrevet() < 1 || input.getBrevet() > 2
          || input.getTag() == null) {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ungueltige Wertungsrichter-Slot-Angaben");
      }
      if (input.getTag().isBefore(anlass.getStartDate().toLocalDate())
          || input.getTag().isAfter(anlass.getEndDate().toLocalDate())
          || (input.getStart_zeit() != null && input.getEnd_zeit() != null
              && !input.getEnd_zeit().isAfter(input.getStart_zeit()))) {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ungueltiger Slot-Tag oder Zeitraum");
      }
      WertungsrichterSlot slot = new WertungsrichterSlot();
      slot.setAnlass(anlass);
      slot.setAktiv(true);
      slot.setReihenfolge(anlass.getWertungsrichterSlots().size() + 1);
      slot.setBrevet(WertungsrichterBrevetEnum.fromInt(input.getBrevet()));
      slot.setTag(input.getTag());
      slot.setStart_zeit(input.getStart_zeit());
      slot.setEnd_zeit(input.getEnd_zeit());
      slot.setBeschreibung(input.getBeschreibung() == null ? "" : input.getBeschreibung().trim());
      slot.setEgalSlot(input.isEgalSlot());
      anlass.getWertungsrichterSlots().add(slot);
    }
  }

  public List<BenutzerDTO> getAnmelderAndVerantwortliche(Anlass anlass) {
    try {
      List<Organisation> orgs = organisationAnlassLinkService.getVereinsStarts(anlass);

      List<BenutzerDTO> benutzerList = new ArrayList<BenutzerDTO>();
      for (Organisation org : orgs) {
        if (org.isAktiv()) {
          for (OrganisationPersonLink opl : org.getPersonenLinks()) {
            BenutzerDTO benutzer = null;
            for (RollenLink rl : opl.getRollenLink()) {
              if (rl.isAktiv() && (RollenEnum.ANMELDER.equals(rl.getRolle().getName())
                  || RollenEnum.VEREINSVERANTWORTLICHER.equals(rl.getRolle().getName()))) {
                if (benutzer == null) {
                  benutzer = new BenutzerDTO();
                  benutzer.setBenutzername(opl.getPerson().getBenutzername());
                  benutzer.setName(opl.getPerson().getName());
                  benutzer.setVorname(opl.getPerson().getVorname());
                  benutzer.setHandy(opl.getPerson().getHandy());
                  benutzer.setEmail(opl.getPerson().getEmail());
                  benutzer.setVerein(org.getName());
                }
                if (RollenEnum.ANMELDER.equals(rl.getRolle().getName())) {
                  benutzer.setAnmelder(true);
                } else {
                  benutzer.setVerantwortlicher(true);
                }
              }
            }
            if (benutzer != null) {
              benutzerList.add(benutzer);
            }
          }
        }
      }
      return benutzerList;
      // TODO throw proper execption
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  @Transactional(readOnly = true)
  public Optional<Anlass> findPreviousAnlass(Anlass anlass, KategorieEnum kategorie) {

    return getAnlaesse(false).stream()
        .filter(a -> a.getStartDate().isBefore(anlass.getStartDate())
            && a.getTiefsteKategorie().ordinal() <= kategorie.ordinal()
            && a.getHoechsteKategorie().ordinal() >= kategorie.ordinal())
        .min((a1, a2) -> a2.getStartDate().compareTo(a1.getStartDate()));
  }

  @Transactional()
  public AnlassDTO updateAnlass(AnlassDTO anlass) {
    return anlassMapper.toDto(this.anlassRepo.save(anlassMapper.toEntity(anlass)));
  }

  @Transactional()
  public Anlass updateAnlass(Anlass anlass) {
    return this.anlassRepo.save(anlass);
  }

  @Transactional()
  public Anlass save(Anlass anlass) {
    return anlassRepo.save(anlass);
  }

  @Transactional(readOnly = true)
  public Optional<PersonAnlassLink> getAnlassLink(Anlass anlass, Organisation organisation,
      Person person) {
    List<PersonAnlassLink> pals = personAnlassLinkRepository
        .findByPersonAndOrganisationAndAnlass(person, organisation, anlass);
    if (pals.isEmpty()) {
      return Optional.empty();
    }
    if (pals.size() > 1) {
      log.error(
          "Data integrity violation: multiple PersonAnlassLink for person={}, org={}, anlass={}",
          person, organisation, anlass);
    }
    return Optional.ofNullable(pals.get(0));
  }
  // ***************************************************
  // Ab hier missing
  // ***************************************************

  @Transactional(readOnly = true)
  public List<Anlass> getAnlaesse(boolean onlyAktiv) {
    if (onlyAktiv) {
      return anlassRepo.findByAktivOrderByStartDate(true);
    } else {
      return anlassRepo.findAllByOrderByStartDate();
    }
  }

  public List<AnlassDTO> getAnlaesseDto(boolean onlyAktiv) {
    return getAnlaesse(onlyAktiv).stream().map(anlassMapper::toDto).toList();
  }

  @Transactional(readOnly = true)
  public Map<Teilnehmer, List<TeilnehmerAnlassLink>> getTeilnahmen(int jahr,
      Organisation organisation) {
    LocalDateTime startDate = LocalDateTime.of(jahr, 1, 1, 0, 0);
    LocalDateTime endDate = LocalDateTime.of(jahr + 1, 12, 31, 23, 59);
    List<Anlass> anlaesse = anlassRepo.findByStartDateBetweenAndAktivOrderByStartDate(startDate,
        endDate, true);
    Map<Teilnehmer, List<TeilnehmerAnlassLink>> teilnahmenDTOMap = new HashMap<>();
    anlaesse.forEach(anlass -> {
      getTeilnahmen(anlass, organisation, false).forEach(tal -> {
        if (!teilnahmenDTOMap.containsKey(tal.getTeilnehmer())) {
          List<TeilnehmerAnlassLink> tals = new ArrayList();
          tals.add(tal);
          teilnahmenDTOMap.put(tal.getTeilnehmer(), tals);
        } else {
          teilnahmenDTOMap.get(tal.getTeilnehmer()).add(tal);
        }
      });
    });
    return teilnahmenDTOMap;
  }

  @Transactional(readOnly = true)
  public List<Anlass> getAnlaesseFiltered(int jahr, boolean nurSmQuali, TiTuEnum tiTu) {
    LocalDateTime start = LocalDateTime.parse(jahr + "-01-01T00:00:00");
    LocalDateTime end = LocalDateTime.now();
    boolean[] nurSmQualis = { true, false };
    if (nurSmQuali) {
      nurSmQualis[1] = true;
    }
    return anlassRepo
        .findWettkaempfeByCriteria(true, nurSmQuali, tiTu, TiTuEnum.Alle, KategorieEnum.K7, start,
            end);
  }

  // TODO Move to TeilnehmerAnlassLinkService
  @Transactional(readOnly = true)
  public List<TeilnehmerAnlassLink> getTeilnahmen(Anlass anlass, Organisation organisation,
      boolean exclude) {
    List<TeilnehmerAnlassLink> teilnahmen = null;
    if (exclude) {
      List<MeldeStatusEnum> exclusion = Arrays
          .asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.ABGEMELDET_1,
              MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3,
              MeldeStatusEnum.UMMELDUNG });
      teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisationExclude(anlass,
          organisation,
          exclusion);
    } else {
      teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisation(anlass, organisation);
    }
    teilnahmen = teilnahmen.stream().filter(link -> {
      try {
        String name = link.getTeilnehmer().getName();
        return true;
      } catch (Exception ex) {
        return false;
      }
    }).collect(Collectors.toList());

    if (teilnahmen.size() > 0) {
      log.debug("Teilnehmer {}", teilnahmen.get(0).getKategorie());
      try {
        log.debug("Teilnehmer {}", teilnahmen.get(0).getTeilnehmer().getName());
      } catch (Exception ex) {
        log.warn("Kein Teilnehmer message: {} ", ex.getMessage());
      }
      log.debug("Teilnehmer {}", teilnahmen.get(0).getOrganisation().getName());
    }
    return teilnahmen;
  }

  @Override
  @Transactional(readOnly = true)
  public Anlass findById(UUID id) {
    return anlassRepo.findById(id).orElseThrow(() -> new NotFoundException(Organisation.class, id));
  }
}
