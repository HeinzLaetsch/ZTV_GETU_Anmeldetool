package org.ztv.anmeldetool.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Rolle;

@Repository
public interface RollenRepository extends JpaRepository<Rolle, UUID> {

	Optional<Rolle> findByName(String name);

}
