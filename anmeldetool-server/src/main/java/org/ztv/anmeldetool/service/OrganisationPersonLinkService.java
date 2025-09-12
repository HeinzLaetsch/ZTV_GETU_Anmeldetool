package org.ztv.anmeldetool.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.repositories.OrganisationPersonLinkRepository;

@Service("organisationPersonLinkService")
@Slf4j
@AllArgsConstructor
public class OrganisationPersonLinkService {
  private final OrganisationPersonLinkRepository orgPersLinkRep;

  public OrganisationPersonLink createOrgPersonLinks(Person person, Organisation organisation) {
    OrganisationPersonLink orgPersLink = new OrganisationPersonLink();
    orgPersLink.setAktiv(true);
    orgPersLink.setOrganisation(organisation);
    orgPersLink.setPerson(person);
    orgPersLinkRep.save(orgPersLink);
    return orgPersLink;
  }

}
