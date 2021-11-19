package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterSlot;

/**
 * 
 * @author heinz gemäss
 *         https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods
 */
@Repository
public interface WertungsrichterSlotRepository extends CrudRepository<WertungsrichterSlot, UUID> {

	List<WertungsrichterSlot> findByAnlass(Anlass anlass);

}
