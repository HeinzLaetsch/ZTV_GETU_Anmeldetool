package org.ztv.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Einzelnote;

@Repository
public interface EinzelnotenRepository extends JpaRepository<Einzelnote, UUID> {
}
