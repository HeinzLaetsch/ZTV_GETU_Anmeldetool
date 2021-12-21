package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;

@Repository
public interface WertungsrichterRepository extends CrudRepository<Wertungsrichter, UUID> {
	List<Wertungsrichter> findAllByAktiv(boolean aktiv);

	List<Wertungsrichter> findByPersonId(UUID id);
}
