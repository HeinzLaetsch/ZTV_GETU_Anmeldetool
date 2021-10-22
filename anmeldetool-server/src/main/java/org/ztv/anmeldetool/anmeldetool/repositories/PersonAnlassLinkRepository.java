package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;

@Repository
public interface PersonAnlassLinkRepository extends JpaRepository<PersonAnlassLink, UUID> {
	List<PersonAnlassLink> findByPersonAndOrganisationAndAnlass(Person person, Organisation organisation, Anlass anlass);
	List<PersonAnlassLink> findByAnlass(Anlass anlass);
	List<PersonAnlassLink> findByAnlassAndOrganisation(Anlass anlass, Organisation organisation);
}
