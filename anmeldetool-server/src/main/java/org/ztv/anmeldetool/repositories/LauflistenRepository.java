package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.NativeQuery;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Laufliste;

@Repository
public interface LauflistenRepository extends JpaRepository<Laufliste, UUID> {
	List<Laufliste> findByKey(String key);

	@NativeQuery("SELECT nextval('lauflisten_nummer')")
	Long getNextSequence();
}
