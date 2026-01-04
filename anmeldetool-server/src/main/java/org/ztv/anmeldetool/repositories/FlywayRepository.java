package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.FlywayHistory;

@Repository
public interface FlywayRepository extends JpaRepository<FlywayHistory, Integer> {
	List<FlywayHistory> findByOrderByInstalledRank();

	Optional<FlywayHistory> findByVersionAndSuccess(String version, boolean success);
}
