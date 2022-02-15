package org.ztv.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Organisation;
/**
 * 
 * @author heinz
 * gemäss https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods
 */
@Repository
public interface OrganisationsRepository extends CrudRepository<Organisation, UUID> {

	Organisation findAllByName(String organisationName);

	Organisation findByName(String organisationName);

	Iterable<Organisation> findByAktivOrderByName(boolean aktiv);

}
