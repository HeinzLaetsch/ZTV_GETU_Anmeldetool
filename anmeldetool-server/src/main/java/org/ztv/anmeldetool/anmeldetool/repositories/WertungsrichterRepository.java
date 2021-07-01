package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;

@Repository
public interface WertungsrichterRepository extends CrudRepository<Wertungsrichter, UUID> {

	Iterable<Wertungsrichter> findAllByAktiv(boolean aktiv);

	Optional<Wertungsrichter> findByPersonId(UUID id);
}
