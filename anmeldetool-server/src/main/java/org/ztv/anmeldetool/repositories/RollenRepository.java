package org.ztv.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Rolle;

@Repository
public interface RollenRepository extends CrudRepository<Rolle, UUID> {

	Rolle findByName(String rolle);

}
