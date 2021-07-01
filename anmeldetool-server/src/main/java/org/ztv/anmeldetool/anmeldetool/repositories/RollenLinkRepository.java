package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;

@Repository
public interface RollenLinkRepository extends CrudRepository<RollenLink, UUID> {
}
