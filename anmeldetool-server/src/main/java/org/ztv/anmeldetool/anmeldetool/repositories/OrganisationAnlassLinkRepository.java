package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;

@Repository
public interface OrganisationAnlassLinkRepository extends CrudRepository<OrganisationAnlassLink, UUID> {
	
	OrganisationAnlassLink findFirstByOrganisationAndAnlass(Organisation organisation, Anlass anlass);

	Iterable<OrganisationAnlassLink> findByAnlass(Anlass anlass);
}