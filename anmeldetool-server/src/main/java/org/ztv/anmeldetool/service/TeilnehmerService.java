package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;
import org.ztv.anmeldetool.util.TeilnehmerHelper;

@Service("teilnehmerService")
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TeilnehmerService {

  private final OrganisationService organisationSrv;
  private final AnlassService anlassSrv;
  private final TeilnehmerRepository teilnehmerRepository;

  private final TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;
  private final TeilnehmerAnlassLinkMapper talMapper;

  public long countTeilnehmerByOrganisation(UUID orgId) {
    Organisation organisation = organisationSrv.findById(orgId);
    if (organisation == null) {
      throw new NotFoundException(Organisation.class, orgId);
    }
    long anzahl = teilnehmerRepository.countByOrganisation(organisation);
    return anzahl;
  }

  public Page<Teilnehmer> findTeilnehmerByOrganisation(Organisation organisation,
      Pageable pageable) {
    Page<Teilnehmer> teilnehmerListe = teilnehmerRepository.findByOrganisation(organisation,
        pageable);
    return teilnehmerListe;
  }

  public ResponseEntity<Collection<TeilnehmerDTO>> findTeilnehmerDtoByOrganisation(
      Organisation organisation, Pageable pageable) {
    Page<Teilnehmer> teilnehmerListe = findTeilnehmerByOrganisation(organisation, pageable);

    List<TeilnehmerDTO> teilnehmerDTOs = new ArrayList<TeilnehmerDTO>();
    for (Teilnehmer teilnehmer : teilnehmerListe) {
      List<TeilnehmerAnlassLink> tals = teilnehmerAnlassLinkRepository.findByTeilnehmer(teilnehmer);
      Optional<TeilnehmerAnlassLink> res = tals.stream().max((tal1, tal2) -> {
        if (KategorieEnum.KEIN_START.equals(tal1.getKategorie())) {
          return -1;
        }
        return tal1.getKategorie().compareTo(tal2.getKategorie());
      });
      KategorieEnum letzteKategorie = res.map(TeilnehmerAnlassLink::getKategorie).orElse(null);
      TeilnehmerDTO teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer,
          organisation.getId(), letzteKategorie);
      teilnehmerDTOs.add(teilnehmerDTO);
    }
    return ResponseEntity.ok(teilnehmerDTOs);
  }

  public Teilnehmer findTeilnehmerById(UUID id) {
    return teilnehmerRepository.findById(id)
        .orElseThrow(() -> new NotFoundException(Teilnehmer.class, id));
  }

  public List<Teilnehmer> findTeilnehmerByBenutzername(String name, String vorname) {
    List<Teilnehmer> teilnehmerList = teilnehmerRepository.findByNameAndVorname(name, vorname);
    return teilnehmerList;
  }

  @Transactional
  public ResponseEntity<TeilnehmerDTO> create(UUID orgId, TeilnehmerDTO teilnehmerDTORaw) {
    TeilnehmerDTO teilnehmerDTO = TeilnehmerDTO.builder().aktiv(true).id(UUID.randomUUID())
        .organisationid(orgId)
        .name(teilnehmerDTORaw.getName()).vorname(teilnehmerDTORaw.getVorname())
        .stvNummer(teilnehmerDTORaw.getStvNummer()).jahrgang(teilnehmerDTORaw.getJahrgang())
        .letzteKategorie(teilnehmerDTORaw.getLetzteKategorie()).tiTu(teilnehmerDTORaw.getTiTu())
        .dirty(false)
        .build();

    Organisation organisation = organisationSrv.findById(teilnehmerDTO.getOrganisationid());
    if (organisation == null) {
      return ResponseEntity.notFound().build();
    }

    Teilnehmer teilnehmer = TeilnehmerHelper.createTeilnehmer(teilnehmerDTO);
    teilnehmer.setOrganisation(organisation);

    teilnehmer = teilnehmerRepository.save(teilnehmer);

    teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, organisation);
    return ResponseEntity.ok(teilnehmerDTO);
  }

  @Transactional
  public Teilnehmer create(Teilnehmer teilnehmer) {
    return teilnehmerRepository.save(teilnehmer);
  }

  // Kein Softdelete !
  @Transactional
  public ResponseEntity<UUID> delete(UUID orgId, UUID teilnehmerId) {
    Organisation organisation = organisationSrv.findById(orgId);
    if (organisation == null) {
      return ResponseEntity.notFound().build();
    }
    Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(teilnehmerId);
    if (teilnehmerOptional.isEmpty()) {
      return ResponseEntity.notFound().build();
    }
    Teilnehmer teilnehmer = teilnehmerOptional.get();
    List<TeilnehmerAnlassLink> links = this.teilnehmerAnlassLinkRepository.findByTeilnehmer(
        teilnehmer);
    this.teilnehmerAnlassLinkRepository.deleteAll(links);
    teilnehmerRepository.delete(teilnehmer);
    return ResponseEntity.ok(teilnehmerId);
  }

  public TeilnehmerDTO update(UUID orgId, TeilnehmerDTO teilnehmerDTO) throws NotFoundException {
    Organisation organisation = organisationSrv.findById(orgId);
    if (organisation == null) {
      throw new NotFoundException(Organisation.class, orgId);// ResponseEntity.notFound().build();
    }
    return update(organisation, teilnehmerDTO);
  }

  public TeilnehmerDTO update(TeilnehmerDTO teilnehmerDTO) throws NotFoundException {
    return update(teilnehmerDTO.getOrganisationid(), teilnehmerDTO);
  }

  @Transactional
  public TeilnehmerDTO update(Organisation organisation, TeilnehmerDTO teilnehmerDTO)
      throws NotFoundException {
    Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(teilnehmerDTO.getId());
    if (teilnehmerOptional.isEmpty()) {
      log.warn("Could not find Teilnehmer with ID: {}", teilnehmerDTO.getId());
      throw new NotFoundException(Teilnehmer.class,
          teilnehmerDTO.getId()); // ResponseEntity.notFound().build();
    }
    Teilnehmer teilnehmer2 = TeilnehmerHelper.createTeilnehmer(teilnehmerDTO);

    Teilnehmer teilnehmer = teilnehmerOptional.get();
    teilnehmer.setAktiv(teilnehmer2.isAktiv());
    teilnehmer.setChangeDate(Calendar.getInstance());

    teilnehmer.setJahrgang(teilnehmer2.getJahrgang());
    teilnehmer.setTiTu(teilnehmer2.getTiTu());
    teilnehmer.setName(teilnehmer2.getName());
    teilnehmer.setVorname(teilnehmer2.getVorname());
    teilnehmer.setDirty(teilnehmer2.isDirty());
    teilnehmer.setStvNummer(teilnehmer2.getStvNummer());

    teilnehmer = create(teilnehmer);
    teilnehmerDTO = TeilnehmerHelper.createTeilnehmerDTO(teilnehmer, organisation);
    return teilnehmerDTO;
  }

  @Transactional
  public TeilnehmerAnlassLinkDTO updateAnlassTeilnahmen(UUID anlassId, UUID teilnehmerId,
      TeilnehmerAnlassLinkDTO tal) {

    Anlass anlass = anlassSrv.findById(anlassId);

    Optional<Teilnehmer> teilnehmerOptional = teilnehmerRepository.findById(teilnehmerId);
    if (teilnehmerOptional.isEmpty()) {
      return null;
    }
    Teilnehmer teilnehmer = teilnehmerOptional.get();

    Iterable<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository
        .findByTeilnehmerAndAnlass(teilnehmer, anlass);
    TeilnehmerAnlassLink teilnehmerAnlassLink;
    if (teilnahmen.iterator().hasNext()) {
      teilnehmerAnlassLink = teilnahmen.iterator().next();
    } else {
      teilnehmerAnlassLink = new TeilnehmerAnlassLink();
    }

    teilnehmerAnlassLink.setAnlass(anlass);
    teilnehmerAnlassLink.setOrganisation(teilnehmer.getOrganisation());
    teilnehmerAnlassLink.setTeilnehmer(teilnehmer);
    teilnehmerAnlassLink.setAktiv(true);
    if (KategorieEnum.KEIN_START.equals(tal.getKategorie())) {
      teilnehmerAnlassLink.setAktiv(false);
    } else {
      teilnehmerAnlassLink.setAktiv(true);
    }
    if (tal.getKategorie() != null) {
      teilnehmerAnlassLink.setKategorie(tal.getKategorie());
    }
    MeldeStatusEnum neuerStatus = MeldeStatusEnum.valueOf(tal.getMeldeStatus().toUpperCase());
    if (tal.getMeldeStatus() != null && !(
        teilnehmerAnlassLink.getMeldeStatus() == MeldeStatusEnum.NEUMELDUNG
            && neuerStatus == MeldeStatusEnum.STARTET)) {
      teilnehmerAnlassLink.setMeldeStatus(neuerStatus);
    }
    teilnehmerAnlassLink = teilnehmerAnlassLinkRepository.save(teilnehmerAnlassLink);

    return talMapper.toDto(teilnehmerAnlassLink);
  }
}
