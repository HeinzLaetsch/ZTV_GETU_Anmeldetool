package org.ztv.anmeldetool.repositories;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Verband;

/**
 * 
 * @author heinz gemäss
 *         https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods
 */
@Repository
public interface OrganisationsRepository extends JpaRepository<Organisation, UUID> {

	/**
	 * Finds an organisation by its unique name.
	 *
	 * @param organisationName The name of the organisation.
	 * @return An {@link Optional} containing the found organisation or an empty
	 *         optional if no organisation with that name exists.
	 */
	Optional<Organisation> findByName(String organisationName);

	Collection<Organisation> findByAktivOrderByName(boolean aktiv);

	@Query("SELECT org FROM Organisation org WHERE org.aktiv=TRUE AND org.verband IN (:verbaende) ORDER BY org.name")
	List<Organisation> findZuercherOrganisationen(List<Verband> verbaende);
}
