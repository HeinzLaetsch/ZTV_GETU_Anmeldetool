package org.ztv.anmeldetool.repositories;

import java.util.List;
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

	Organisation findAllByName(String organisationName);

	Organisation findByName(String organisationName);

	Iterable<Organisation> findByAktivOrderByName(boolean aktiv);

	@Query("SELECT org FROM Organisation org WHERE org.aktiv=TRUE AND org.verband IN (:zh_verbaende) ORDER BY org.name")
	List<Organisation> findZuercherOrganisationen(List<Verband> zh_verbaende);
}
