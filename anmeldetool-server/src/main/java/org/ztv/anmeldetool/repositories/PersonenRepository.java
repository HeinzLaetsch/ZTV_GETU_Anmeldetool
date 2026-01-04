package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Person;

@Repository
public interface PersonenRepository extends JpaRepository<Person, UUID> {

	Optional<Person> findByBenutzernameIgnoreCase(String benutzername);

	/**
	 * Finds all persons associated with a given organisation by its ID.
	 * This uses a JPQL query to traverse the entity relationships, which is more portable and safer than a native query.
	 */
	@Query("""
			SELECT p FROM Person p
			JOIN p.organisationenLinks opl
			WHERE opl.organisation.id = :orgId
			""")
	List<Person> findByOrganisationId(UUID orgId);
}
