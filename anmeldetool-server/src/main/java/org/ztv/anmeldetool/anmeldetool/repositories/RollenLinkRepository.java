package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;

@Repository
public interface RollenLinkRepository extends JpaRepository<RollenLink, UUID> {
}
