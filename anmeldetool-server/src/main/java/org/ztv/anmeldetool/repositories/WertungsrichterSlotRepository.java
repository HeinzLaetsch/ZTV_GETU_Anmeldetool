package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.WertungsrichterSlot;

/**
 * 
 * @author heinz gemäss
 *         https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods
 */
@Repository
public interface WertungsrichterSlotRepository extends JpaRepository<WertungsrichterSlot, UUID> {

	List<WertungsrichterSlot> findByAnlass(Anlass anlass);

}
