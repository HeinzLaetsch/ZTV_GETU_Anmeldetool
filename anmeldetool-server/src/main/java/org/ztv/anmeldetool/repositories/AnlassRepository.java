package org.ztv.anmeldetool.repositories;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;

/**
 * 
 * @author heinz gemäss
 *         https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods
 */
@Repository
public interface AnlassRepository extends JpaRepository<Anlass, UUID> {

	List<Anlass> findByAktivOrderByAnlassBezeichnung(boolean aktiv);

	List<Anlass> findByAktivOrderByStartDate(boolean aktiv);

	List<Anlass> findAllByOrderByStartDate();

	List<Anlass> findByStartDateBetweenAndAktivOrderByStartDate(LocalDateTime startDate, LocalDateTime endDate,
			boolean aktiv);

	/**
	 * Finds active events that are SM-Qualifying for a specific or any TiTu, match a category, and fall within a date range.
	 * This replaces a complex derived query method with a clearer, more stable JPQL query.
	 */
	@Query("""
			SELECT a FROM Anlass a
			WHERE a.aktiv = :aktiv
			  AND a.smQuali = :smQuali
			  AND (a.tiTu = :tiTu OR a.tiTu = :tiTuAlle)
			  AND a.hoechsteKategorie = :kategorie
			  AND a.startDate BETWEEN :start AND :end
			ORDER BY a.startDate
			""")
	List<Anlass> findWettkaempfeByCriteria(boolean aktiv, boolean smQuali, TiTuEnum tiTu, TiTuEnum tiTuAlle,
			KategorieEnum kategorie, LocalDateTime start, LocalDateTime end);

	@Query("""
			SELECT a FROM Anlass a
			WHERE a.aktiv = true
			  AND a.smQuali IN :smQuali
			  AND a.tiTu IN :tiTu
			  AND a.hoechsteKategorie = :kategorie
			  AND a.startDate BETWEEN :start AND :end
			ORDER BY a.startDate
			""")
	List<Anlass> findActiveEventsByComplexCriteria(
			List<Boolean> smQuali, List<TiTuEnum> tiTu, KategorieEnum kategorie, LocalDateTime start, LocalDateTime end);
}
