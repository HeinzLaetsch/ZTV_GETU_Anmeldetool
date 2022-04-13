package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Verband;

@Repository
public interface VerbandsRepository extends JpaRepository<Verband, UUID> {

	Iterable<Verband> findAllByAktivOrderByVerband(boolean aktiv);

	Iterable<Verband> findAllByAktiv(boolean aktiv);

	List<Verband> findByVerband(String verbandAbkz);

}
