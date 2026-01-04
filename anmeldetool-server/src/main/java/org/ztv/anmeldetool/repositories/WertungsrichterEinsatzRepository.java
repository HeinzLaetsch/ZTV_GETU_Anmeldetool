package org.ztv.anmeldetool.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;

@Repository
public interface WertungsrichterEinsatzRepository extends JpaRepository<WertungsrichterEinsatz, UUID> {

	Optional<WertungsrichterEinsatz> findByPersonAnlassLink(PersonAnlassLink personAnlassLink);
}
