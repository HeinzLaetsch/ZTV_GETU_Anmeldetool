package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Anlass;

/**
 * 
 * @author heinz gemäss
 *         https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods
 */
@Repository
public interface AnlassRepository extends CrudRepository<Anlass, UUID> {

	List<Anlass> findByAktivOrderByAnlassBezeichnung(boolean aktiv);

	List<Anlass> findByAktivOrderByStartDate(boolean aktiv);
}
