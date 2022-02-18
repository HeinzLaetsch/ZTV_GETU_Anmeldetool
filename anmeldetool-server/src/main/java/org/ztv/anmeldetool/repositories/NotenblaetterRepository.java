package org.ztv.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Notenblatt;

@Repository
public interface NotenblaetterRepository extends JpaRepository<Notenblatt, UUID> {
}
