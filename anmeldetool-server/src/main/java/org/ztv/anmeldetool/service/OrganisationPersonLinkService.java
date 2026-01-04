package org.ztv.anmeldetool.service;

import java.util.Collection;
import java.util.Set;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.repositories.OrganisationPersonLinkRepository;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.util.RolleMapper;

@Service("organisationPersonLinkService")
@Slf4j
@RequiredArgsConstructor
public class OrganisationPersonLinkService {
  private final OrganisationPersonLinkRepository orgPersLinkRep;
  private final RolleMapper rolleMapper;

  public boolean isPersonMemberOfOrganisation(Person person, Organisation organisation) {
    return orgPersLinkRep.findByOrganisationAndPerson(organisation, person).isPresent();

  }
  public Collection<RolleDTO> findRolesForUser(Organisation org, Person person) {
    return orgPersLinkRep.findByOrganisationAndPerson(org, person)
        .stream() // Stream the Optional<OrganisationPersonLink>
        .flatMap(opl -> opl.getRollenLink().stream()) // Flatten the Set<RollenLink> into a single stream
        .map(rolleMapper::toDto) // Map each RollenLink to a RolleDTO
        .toList();
  }
}
