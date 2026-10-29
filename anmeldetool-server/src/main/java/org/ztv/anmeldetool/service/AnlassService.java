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
import org.ztv.anmeldetool.controller.ErrorResponse;
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
        // Validate required fields
        if (dto.getId() != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "ID must not be set when creating a new anlass");
        }

        if (dto.getAnlassBezeichnung() == null || dto.getAnlassBezeichnung().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Anlassbezeichnung is required");
        }

        if (dto.getOrt() == null || dto.getOrt().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ort is required");
        }

        if (dto.getHalle() == null || dto.getHalle().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Halle is required");
        }

        if (dto.getOrganisatorId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Organisator ID is required");
        }

        if (dto.getTiTu() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "TiTu is required");
        }

        if (dto.getTiefsteKategorie() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tiefste Kategorie is required");
        }

        if (dto.getHoechsteKategorie() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Hoechste Kategorie is required");
        }

        // Validate category range
        if (dto.getTiefsteKategorie() == KategorieEnum.KEIN_START ||
                dto.getHoechsteKategorie() == KategorieEnum.KEIN_START ||
                dto.getTiefsteKategorie().ordinal() > dto.getHoechsteKategorie().ordinal()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ungueltiger Kategorienbereich");
        }

        // Validate date sequence
        LocalDateTime[] dates = {
                dto.getAnmeldungBeginn(),
                dto.getErfassenGeschlossen(),
                dto.getCrossKategorieAenderungenGeschlossen(),
                dto.getAenderungenInKategorieGeschlossen(),
                dto.getAenderungenNichtMehrErlaubt(),
                dto.getStartDatum(),
                dto.getEndDatum()
        };

        for (int index = 0; index < dates.length; index++) {
            if (dates[index] == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Date field at index " + index + " is required");
            }

            if (index > 0 && dates[index].isBefore(dates[index - 1])) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ungueltige Datumsreihenfolge");
            }
        }

        // Validate organisation exists
        Organisation organisator = organisationService.findById(dto.getOrganisatorId());

        // Create and configure anlass
        Anlass anlass = new Anlass();
        anlass.setAnlassBezeichnung(dto.getAnlassBezeichnung().trim());
        anlass.setOrt(dto.getOrt().trim());
        anlass.setHalle(dto.getHalle().trim());
        anlass.setOrganisator(organisator);
        anlass.setIban(dto.getIban() == null ? "" : dto.getIban().trim());
        anlass.setSmQuali(dto.isSmQuali());
        anlass.setAusserkantonal(dto.isAusserkantonal());
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

        // Add wertungsrichter slots
        addWertungsrichterSlots(anlass, dto.getWertungsrichterSlots());

        // Save and return
        return anlassMapper.toDto(anlassRepo.save(anlass));
    }

    private void addWertungsrichterSlots(Anlass anlass, List<WertungsrichterSlotDTO> slots) {
        if (slots == null || slots.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Mindestens ein Wertungsrichter-Slot ist erforderlich");
        }

        for (WertungsrichterSlotDTO input : slots) {
            if (input == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Wertungsrichter-Slot cannot be null");
            }

            if (input.getId() != null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Wertungsrichter-Slot ID must not be set when creating");
            }

            if (input.getBrevet() < 1 || input.getBrevet() > 2) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Brevet must be 1 or 2");
            }

            if (input.getTag() == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tag is required");
            }

            // Validate date range
            if (input.getTag().isBefore(anlass.getStartDate().toLocalDate()) ||
                    input.getTag().isAfter(anlass.getEndDate().toLocalDate())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Slot tag must be within anlass date range");
            }

            // Validate time range if both times are provided
            if (input.getStart_zeit() != null && input.getEnd_zeit() != null &&
                    !input.getEnd_zeit().isAfter(input.getStart_zeit())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "End time must be after start time");
            }

            // Create and configure slot
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

            List<BenutzerDTO> benutzerList = new ArrayList<>();
            for (Organisation org : orgs) {
                if (org.isAktiv()) {
                    for (OrganisationPersonLink opl : org.getPersonenLinks()) {
                        BenutzerDTO benutzer = null;
                        for (RollenLink rl : opl.getRollenLink()) {
                            if (rl.isAktiv() && (RollenEnum.ANMELDER.equals(rl.getRolle().getName()) ||
                                    RollenEnum.VEREINSVERANTWORTLICHER.equals(rl.getRolle().getName()))) {
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
        } catch (Exception ex) {
            log.error("Error getting anmelder and verantwortliche: {}", ex.getMessage(), ex);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                    "Failed to get anmelder and verantwortliche");
        }
    }

    @Transactional(readOnly = true)
    public Optional<Anlass> findPreviousAnlass(Anlass anlass, KategorieEnum kategorie) {
        return getAnlaesse(false).stream()
                .filter(a -> a.getStartDate().isBefore(anlass.getStartDate()) &&
                        a.getTiefsteKategorie().ordinal() <= kategorie.ordinal() &&
                        a.getHoechsteKategorie().ordinal() >= kategorie.ordinal())
                .min((a1, a2) -> a2.getStartDate().compareTo(a1.getStartDate()));
    }

    @Transactional()
    public AnlassDTO updateAnlass(AnlassDTO anlass) {
        Anlass existing = anlassRepo.findById(anlass.getId())
                .orElseThrow(() -> new NotFoundException(Anlass.class, anlass.getId()));
        anlassMapper.updateFromDto(anlass, existing);
        if (anlass.getWertungsrichterSlots() != null) {
            Map<UUID, WertungsrichterSlot> currentSlots = existing.getWertungsrichterSlots().stream()
                    .collect(Collectors.toMap(WertungsrichterSlot::getId, slot -> slot));
            List<WertungsrichterSlot> updatedSlots = new ArrayList<>();
            for (WertungsrichterSlotDTO input : anlass.getWertungsrichterSlots()) {
                WertungsrichterSlot slot = input.getId() == null ? new WertungsrichterSlot()
                        : currentSlots.get(input.getId());
                if (slot == null) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Slot does not belong to this anlass");
                }
                if (input.getBrevet() < 1 || input.getBrevet() > 2) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Brevet must be 1 or 2");
                }
                slot.setAnlass(existing);
                slot.setAktiv(true);
                slot.setReihenfolge(updatedSlots.size() + 1);
                slot.setBrevet(WertungsrichterBrevetEnum.fromInt(input.getBrevet()));
                slot.setTag(input.getTag());
                slot.setStart_zeit(input.getStart_zeit());
                slot.setEnd_zeit(input.getEnd_zeit());
                slot.setBeschreibung(input.getBeschreibung() == null ? "" : input.getBeschreibung().trim());
                slot.setEgalSlot(input.isEgalSlot());
                updatedSlots.add(slot);
            }
            existing.getWertungsrichterSlots().clear();
            existing.getWertungsrichterSlots().addAll(updatedSlots);
        }
        return anlassMapper.toDto(anlassRepo.save(existing));
    }

    @Transactional
    public void deleteAnlass(UUID anlassId) {
        Anlass anlass = anlassRepo.findById(anlassId)
                .orElseThrow(() -> new NotFoundException(Anlass.class, anlassId));
        anlassRepo.delete(anlass);
        anlassRepo.flush();
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
    public Optional<PersonAnlassLink> getAnlassLink(Anlass anlass, Organisation organisation, Person person) {
        List<PersonAnlassLink> pals = personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person,
                organisation, anlass);
        if (pals.isEmpty()) {
            return Optional.empty();
        }
        if (pals.size() > 1) {
            log.error("Data integrity violation: multiple PersonAnlassLink for person={}, org={}, anlass={}",
                    person, organisation, anlass);
        }
        return Optional.ofNullable(pals.get(0));
    }

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
    public Map<Teilnehmer, List<TeilnehmerAnlassLink>> getTeilnahmen(int jahr, Organisation organisation) {
        LocalDateTime startDate = LocalDateTime.of(jahr, 1, 1, 0, 0);
        LocalDateTime endDate = LocalDateTime.of(jahr + 1, 12, 31, 23, 59);
        List<Anlass> anlaesse = anlassRepo.findByStartDateBetweenAndAktivOrderByStartDate(startDate, endDate, true);
        Map<Teilnehmer, List<TeilnehmerAnlassLink>> teilnahmenDTOMap = new HashMap<>();

        anlaesse.forEach(anlass -> {
            getTeilnahmen(anlass, organisation, false).forEach(tal -> {
                if (!teilnahmenDTOMap.containsKey(tal.getTeilnehmer())) {
                    List<TeilnehmerAnlassLink> tals = new ArrayList<>();
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

        return anlassRepo.findWettkaempfeByCriteria(true, nurSmQuali, tiTu, TiTuEnum.Alle, KategorieEnum.K7, start,
                end);
    }

    // TODO Move to TeilnehmerAnlassLinkService
    @Transactional(readOnly = true)
    public List<TeilnehmerAnlassLink> getTeilnahmen(Anlass anlass, Organisation organisation, boolean exclude) {
        List<TeilnehmerAnlassLink> teilnahmen = null;

        if (exclude) {
            List<MeldeStatusEnum> exclusion = Arrays.asList(
                    MeldeStatusEnum.ABGEMELDET,
                    MeldeStatusEnum.ABGEMELDET_1,
                    MeldeStatusEnum.ABGEMELDET_2,
                    MeldeStatusEnum.ABGEMELDET_3,
                    MeldeStatusEnum.UMMELDUNG);
            teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisationExclude(anlass, organisation,
                    exclusion);
        } else {
            teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisation(anlass, organisation);
        }

        // Filter out invalid entries
        teilnahmen = teilnahmen.stream().filter(link -> {
            try {
                return link.getTeilnehmer() != null && link.getTeilnehmer().getName() != null;
            } catch (Exception ex) {
                return false;
            }
        }).collect(Collectors.toList());

        if (!teilnahmen.isEmpty()) {
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
        return anlassRepo.findById(id)
                .orElseThrow(() -> new NotFoundException(Anlass.class, id));
    }
}
