package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;

@Repository
public interface OrganisationAnlassLinkRepository extends JpaRepository<OrganisationAnlassLink, UUID> {

	List<OrganisationAnlassLink> findByOrganisationAndAnlass(Organisation organisation, Anlass anlass);

	List<OrganisationAnlassLink> findByAnlass(Anlass anlass);

	List<OrganisationAnlassLink> findByAnlassAndAktiv(Anlass anlass, boolean aktiv);
}