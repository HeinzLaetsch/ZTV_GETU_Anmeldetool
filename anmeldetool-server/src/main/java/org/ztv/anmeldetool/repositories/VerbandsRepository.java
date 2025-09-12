package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Verband;

@Repository
public interface VerbandsRepository extends JpaRepository<Verband, UUID> {

	List<Verband> findAllByAktivOrderByVerband(boolean aktiv);

	List<Verband> findAllByAktiv(boolean aktiv);

	Optional<Verband> findByVerband(String verband);

}
