package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;

@Repository
public interface TeilnehmerRepository extends PagingAndSortingRepository<Teilnehmer, UUID> {

	public List<Teilnehmer> findByNameAndVorname(String name, String vorname);
	
	public List<Teilnehmer> findByOrganisation(Organisation organisation, Pageable pageable);
	
	public int countByOrganisation(Organisation organisation);
	
	// public List<Teilnehmer> findByOrganisation(UUID orgId);
}
