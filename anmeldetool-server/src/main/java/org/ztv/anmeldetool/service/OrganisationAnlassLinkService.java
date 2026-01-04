package org.ztv.anmeldetool.service;

import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.util.OrganisationAnlassLinkMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;

@Service("organisationAnlassLinkService")
@Slf4j
@AllArgsConstructor
public class OrganisationAnlassLinkService extends AbstractBaseService<OrganisationAnlassLink> {

  private final OrganisationAnlassLinkRepository orgAnlassRepo;
  private final OrganisationAnlassLinkMapper orgAnlassLinkMapper;
  private final OrganisationMapper organisationMapper;

  @Transactional(readOnly = true)
  public List<OrganisationAnlassLink> getOrganisationAnlassLinks() {
    List<OrganisationAnlassLink> teilnahmen = orgAnlassRepo.findAll();
    return teilnahmen;
  }

  @Override
  @Transactional(readOnly = true)
  public  OrganisationAnlassLink findById(UUID id) {
    return orgAnlassRepo.findById(id).orElseThrow(() -> new NotFoundException(OrganisationAnlassLink.class, id));
  }
  //TODO Move to OrganisationAnlassLinkService
  @Transactional(readOnly = true)
  public OrganisationAnlassLinkDTO getVereinStartDTO(Anlass anlass, Organisation organisation) {
    Optional<OrganisationAnlassLink> teilnahme = orgAnlassRepo.findByOrganisationAndAnlass(organisation, anlass);
    return orgAnlassLinkMapper.toDto(teilnahme.orElse(null));
  }

public List<OrganisationDTO> getVereinsStartsDTOs(Anlass anlass) {
    List<Organisation> orgs = getVereinsStarts(anlass);
    return  orgs.stream().map(organisationMapper::toDto).toList();
  }
  //TODO isAktiv check to DB Layer, können mehrere Links zurückgegeben werden? Wäre wohl falsch
  public List<Organisation> getVereinsStarts(Anlass anlass) {
    List<OrganisationAnlassLink> orgLinks = anlass.getOrganisationenLinks();
    Set<UUID> ids = new HashSet<>();
    List<Organisation> orgs = orgLinks.stream().map(orgLink -> {
      if (orgLink.isAktiv() && !ids.contains(orgLink.getOrganisation().getId())) {
        ids.add(orgLink.getOrganisation().getId());
        return orgLink.getOrganisation();
      }
      return null;
    }).filter(Objects::nonNull).toList();
    return orgs;
  }

  @Transactional
  public OrganisationAnlassLinkDTO updateTeilnehmendeVereine(Anlass anlass, Organisation organisation, OrganisationAnlassLinkDTO oal) {
    Optional<OrganisationAnlassLink> teilnahme = orgAnlassRepo.findByOrganisationAndAnlass(organisation, anlass);
    OrganisationAnlassLink organisationAnlassLink = teilnahme.orElseGet(OrganisationAnlassLink::new);
    organisationAnlassLink.setAktiv(oal.isStartet());
    organisationAnlassLink.setAnlass(anlass);
    organisationAnlassLink.setOrganisation(organisation);
    organisationAnlassLink.setVerlaengerungsDate(oal.getVerlaengerungsDate());

    organisationAnlassLink = orgAnlassRepo.save(organisationAnlassLink);

    return orgAnlassLinkMapper.toDto(organisationAnlassLink);
  }

}
