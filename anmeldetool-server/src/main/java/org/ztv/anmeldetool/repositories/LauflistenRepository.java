package org.ztv.anmeldetool.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Laufliste;

@Repository
public interface LauflistenRepository extends JpaRepository<Laufliste, UUID> {
	/**
	 * Finds a Laufliste by its unique key.
	 *
	 * @param key The unique key of the Laufliste.
	 * @return An {@link Optional} containing the found Laufliste or an empty
	 *         optional if none is found.
	 */
	Optional<Laufliste> findByKey(String key);

	@Query(value = "SELECT nextval('lauflisten_nummer')", nativeQuery = true)
	Long getNextSequence();
}
