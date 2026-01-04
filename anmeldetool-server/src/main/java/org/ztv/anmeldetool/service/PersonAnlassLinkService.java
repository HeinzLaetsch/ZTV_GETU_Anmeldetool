package org.ztv.anmeldetool.service;

import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.util.PersonAnlassLinkExportImportMapper;
import org.ztv.anmeldetool.util.PersonAnlassLinkMapper;

@Service("personAnlassLinkService")
@Slf4j
@RequiredArgsConstructor
public class PersonAnlassLinkService {

  private final PersonAnlassLinkRepository personAnlassLinkRepository;
  private final PersonAnlassLinkMapper personAnlassLinkMapper;
  private final PersonAnlassLinkExportImportMapper personAnlassLinkExportImportMapper;
  private final WertungsrichterEinsatzService wertungsrichterEinsatzSrv;

  @Transactional(readOnly = true)
  public PersonAnlassLinkDTO getPersonAnlassLinkDTO(Person person, Organisation organisation, Anlass anlass) {
    return personAnlassLinkMapper.toDto(getPersonAnlassLink(person, organisation, anlass));
  }
  @Transactional(readOnly = true)
  public PersonAnlassLink getPersonAnlassLink(Person person, Organisation organisation, Anlass anlass) {
    List<PersonAnlassLink> pals = personAnlassLinkRepository
        .findByPersonAndOrganisationAndAnlass(person, organisation, anlass);
    if (pals.size() > 1) {
      log.error("Elements: {}", pals.size());
      // Todo proper exception
      throw new RuntimeException("too many elements");
    }
    if (pals.size() == 0) {
      return null;
    }
    return pals.getFirst();
  }

  @Transactional(readOnly = true)
  public List<PersonAnlassLinkCsvDTO> getWertungsrichterForAnlassAsCsvDTO(Anlass anlass) {
    List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlass(anlass);
    return pals.stream().map(personAnlassLinkExportImportMapper::fromEntity)
        .toList();
  }



  @Transactional(readOnly = true)
  public List<PersonAnlassLink> getEingeteilteWertungsrichter(Anlass anlass,
      Organisation organisation,
      WertungsrichterBrevetEnum brevet) {
    List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlassAndOrganisation(anlass,
        organisation);
    return pals.stream().filter(pal ->
        pal.getPerson().getWertungsrichter().getBrevet().equals(brevet)
    ).toList();
  }

  public List<PersonAnlassLinkDTO> getEingeteilteWertungsrichterDTOs(Anlass anlass,
      Organisation organisation,
      WertungsrichterBrevetEnum brevet) {
    return getEingeteilteWertungsrichter(anlass, organisation, brevet).stream()
        .map(personAnlassLinkMapper::toDto).toList();
  }

  @Transactional
  public PersonAnlassLinkDTO getEinsaetzeDTO(PersonAnlassLink pal) {
    if (pal.getEinsaetze() == null || pal.getEinsaetze().isEmpty()) {
      if (pal.getAnlass().getWertungsrichterSlots() != null) {
        PersonAnlassLink finalPal = pal;
        List<WertungsrichterSlot> slots = pal.getAnlass().getWertungsrichterSlots().stream()
            .filter(slot -> {
              if (finalPal.getAnlass().getHoechsteKategorie().isJugend()) {
                return true;
              }
              return finalPal.getPerson().getWertungsrichter().getBrevet() == slot.getBrevet();
            }).toList();

        PersonAnlassLink finalPal1 = pal;
        List<WertungsrichterEinsatz> wrEs = slots.stream().map(slot -> {
          WertungsrichterEinsatz wrE = WertungsrichterEinsatz.builder().personAnlassLink(finalPal1)
              .eingesetzt(false).wertungsrichterSlot(slot).build();
          wrE.setId(UUID.randomUUID());
          wrE.setAktiv(true);
          wrE = this.wertungsrichterEinsatzSrv.update(wrE);
          return wrE;
        }).toList();
        pal.setEinsaetze(wrEs);
        pal = personAnlassLinkRepository.save(pal);
      }
    }
    return personAnlassLinkMapper.toDto(pal);
  }

  @Transactional
  public PersonAnlassLinkDTO createOrUpdateEingeteilteWertungsrichter(Anlass anlass,
      Organisation organisation, Person person, PersonAnlassLinkDTO personAnlassLinkDto) {
    PersonAnlassLinkDTO palDTO = null;
    PersonAnlassLink pal = getPersonAnlassLink(person, organisation, anlass);
    if (pal != null) {
      pal.setKommentar(personAnlassLinkDto.getKommentar());
      pal = personAnlassLinkRepository.save(pal);
    } else {
      pal = createEingeteilteWertungsrichter(anlass, organisation, person, personAnlassLinkDto.getKommentar());
    }
    palDTO = this.personAnlassLinkMapper.toDto(pal);
    return palDTO;
  }
  @Transactional
  public PersonAnlassLink createEingeteilteWertungsrichter( Anlass anlass, Organisation organisation, Person person, String kommentar) {
    PersonAnlassLink pal = new PersonAnlassLink();
    pal.setAktiv(true);
    pal.setAnlass(anlass);
    pal.setOrganisation(organisation);
    pal.setPerson(person);
    pal.setKommentar(kommentar);
    pal = personAnlassLinkRepository.save(pal);
    wertungsrichterEinsatzSrv.initEinsaetzeForPersonAnlassLink(pal);
    pal = personAnlassLinkRepository.save(pal);
    return pal;
  }

  @Transactional
  public PersonAnlassLink save(PersonAnlassLink pal) {
    return personAnlassLinkRepository.save(pal);
  }

  @Transactional
  public void deleteEingeteilteWertungsrichter(Anlass anlass, Organisation organisation,
      Person person) {
    PersonAnlassLink pal = getPersonAnlassLink(person, organisation, anlass);
    personAnlassLinkRepository.delete(pal);
  }
}
