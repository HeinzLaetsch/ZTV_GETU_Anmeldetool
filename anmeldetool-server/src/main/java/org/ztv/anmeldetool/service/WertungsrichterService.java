package org.ztv.anmeldetool.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.repositories.WertungsrichterRepository;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterDTO;
import org.ztv.anmeldetool.util.PersonMapper;
import org.ztv.anmeldetool.util.WertungsrichterMapper;

@Service("wertungsrichterService")
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class WertungsrichterService extends AbstractBaseService<Wertungsrichter> {

  private final WertungsrichterRepository wertungsrichterRepo;
  private final WertungsrichterEinsatzService wertungsrichterEinsatzSrv;

  private final PersonService personSrv;
  //private final PersonAnlassLinkService personAnlassLinkSrv;

  private final WertungsrichterMapper wrMapper;
  private final PersonMapper personMapper;
  //private final PersonAnlassLinkMapper personAnlassLinkMapper;


  public List<PersonDTO> getVerfuegbareWertungsrichterDTOs(List<Person> personen,
      List<PersonAnlassLink> eingeteilteWrs,
      WertungsrichterBrevetEnum brevet) {
    List<Person> wrs = personen.stream().filter(person ->
        (person.getWertungsrichter() != null && person.getWertungsrichter().getBrevet()
            .equals(brevet))
    ).toList();

    List<Person> verfuegbare = wrs.stream().filter(person -> {
          if (eingeteilteWrs.size() == 0) {
            return true;
          }
          boolean already = eingeteilteWrs.stream().filter(pal -> {
            log.debug("verfügbar: {}, eingeteilt: {}, gleich: {}", person.getId(),
                pal.getPerson().getId(),
                pal.getPerson().getId().equals(person.getId()));
            return !pal.getPerson().getId().equals(person.getId());
          }).count() == eingeteilteWrs.size();
          log.debug("Person {} ist eingeteilt {}", person.getBenutzername(), already);
          return already;
        }
    ).toList();
    return personMapper.toDtoList(verfuegbare);
  }


  //public List<PersonAnlassLink> getEingeteilteWertungsrichter(Anlass anlass) {
  public List<PersonAnlassLink> getEingeteilteWertungsrichter(List<PersonAnlassLink> pals) {
    // List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlass(anlass);
    pals.forEach(pal -> {
      List<WertungsrichterEinsatz> allEinsaetze = pal.getEinsaetze().stream().filter(einsatz ->
          einsatz.isEingesetzt()
      ).toList();
      pal.setEinsaetze(allEinsaetze);
    });
    return pals;
  }

  public WertungsrichterDTO getWertungsrichterByPerson(Person person) {
    Optional<Wertungsrichter> wrOpt = wertungsrichterRepo.findByPersonId(person.getId());
    return wrOpt.map(wrMapper::WertungsrichterToWertungsrichterDTO).orElseThrow();
  }

  @Transactional
  public WertungsrichterDTO update(UUID personId, WertungsrichterDTO wertungsrichterDto) {
    Wertungsrichter wertungsrichter = wrMapper.WertungsrichterDTOToWertungsrichter(
        wertungsrichterDto);
    if (wertungsrichterDto.getId() != null) {
      wertungsrichter.setId(wertungsrichterDto.getId());
    }
    wertungsrichter = wertungsrichterRepo.save(wertungsrichter);

    Person person = personSrv.findPersonById(personId);
    // wertungsrichter.getPerson().setWertungsrichter(wertungsrichter);
    person.setWertungsrichter(wertungsrichter);
    personSrv.savePerson(wertungsrichter.getPerson(), false);
    return wrMapper.WertungsrichterToWertungsrichterDTO(wertungsrichter);
  }

  @Transactional
  public void deleteWertungsrichterByPerson(Person person) {
    Optional<Wertungsrichter> wrOpt = wertungsrichterRepo.findByPersonId(person.getId());
    if (wrOpt.isEmpty()) {
      log.warn("Kein Wertungsrichter für Person mit ID {} gefunden.", person.getId());
      return;
    }
    person.setWertungsrichter(null);
    personSrv.savePerson(person, false);
    wertungsrichterRepo.delete(wrOpt.get());
  }

  //TODO proper exception
  @Override
  public Wertungsrichter findById(UUID id) {
    return wertungsrichterRepo.findById(id)
        .orElseThrow(
            () -> new RuntimeException("Wertungsrichter mit ID " + id + " nicht gefunden."));
  }
}
