package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;

@Repository
public interface TeilnehmerRepository extends JpaRepository<Teilnehmer, UUID> {

	List<Teilnehmer> findByNameAndVorname(String name, String vorname);

	Page<Teilnehmer> findByOrganisation(Organisation organisation, Pageable pageable);

	long countByOrganisation(Organisation organisation);

	// public List<Teilnehmer> findByOrganisation(UUID orgId);
}
