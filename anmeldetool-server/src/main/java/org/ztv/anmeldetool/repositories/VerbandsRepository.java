package org.ztv.anmeldetool.repositories;

import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Verband;

@Repository
public interface VerbandsRepository extends CrudRepository<Verband, UUID> {

	Iterable<Verband> findAllByAktivOrderByVerband(boolean aktiv);

	Iterable<Verband> findAllByAktiv(boolean aktiv);

	Iterable<Verband> findByVerband(String verbandAbkz);
	
}
