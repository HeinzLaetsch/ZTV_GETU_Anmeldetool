package org.ztv.anmeldetool.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;

@Repository
public interface OrganisationPersonLinkRepository extends JpaRepository<OrganisationPersonLink, UUID> {

	Optional<OrganisationPersonLink> findByOrganisationAndPerson(Organisation org, Person person);
}
