package org.ztv.anmeldetool.repositories;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;
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
public interface AnlassRepository extends CrudRepository<Anlass, UUID> {

	List<Anlass> findByAktivOrderByAnlassBezeichnung(boolean aktiv);

	List<Anlass> findByAktivOrderByStartDate(boolean aktiv);

	List<Anlass> findAllByOrderByStartDate();

	List<Anlass> findByStartDateBetweenAndAktivOrderByStartDate(LocalDateTime startDate, LocalDateTime endDate,
			boolean aktiv);

	List<Anlass> findByAktivAndSmQualiAndTiTuOrTiTuAndHoechsteKategorieEqualsAndStartDateBetweenOrderByStartDate(
			boolean aktiv, boolean smQuali, TiTuEnum tiTu, TiTuEnum tiTuAlle, KategorieEnum kategorie,
			LocalDateTime start, LocalDateTime end);

	List<Anlass> findByAktivTrueAndSmQualiInAndTiTuInAndHoechsteKategorieEqualsAndStartDateBetweenOrderByStartDate(
			boolean[] smQuali, TiTuEnum tiTu[], KategorieEnum kategorie, LocalDateTime start, LocalDateTime end);
}
