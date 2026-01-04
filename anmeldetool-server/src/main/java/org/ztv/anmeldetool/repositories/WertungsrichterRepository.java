package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Wertungsrichter;

@Repository
public interface WertungsrichterRepository extends JpaRepository<Wertungsrichter, UUID> {
	List<Wertungsrichter> findAllByAktiv(boolean aktiv);

	Optional<Wertungsrichter> findByPersonId(UUID id);
}
