package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;

@Repository
public interface OrganisationPersonLinkRepository extends CrudRepository<OrganisationPersonLink, UUID> {
	
	Iterable<OrganisationPersonLink> findByOrganisationAndPerson(Organisation org, Person person);
}
