package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterEinsatz;

@Repository
public interface WertungsrichterEinsatzRepository extends CrudRepository<WertungsrichterEinsatz, UUID> {

	Optional<WertungsrichterEinsatz> findOneByPersonAnlassLink(PersonAnlassLink personAnlassLink);
}
