package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
/**
 * 
 * @author heinz
 * gemäss https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods
 */
@Repository
public interface AnlassRepository extends CrudRepository<Anlass, UUID> {

	Iterable<Anlass> findByAktivOrderByAnlassBezeichnung(boolean aktiv);

}
