package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.TimeplanVorschlag;

@Repository
public interface TimeplanVorschlagRepository extends JpaRepository<TimeplanVorschlag, UUID> {

  List<TimeplanVorschlag> findByAnlassId(UUID anlassId);
}
