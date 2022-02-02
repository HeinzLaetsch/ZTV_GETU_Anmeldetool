package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;

@Repository
public interface TeilnehmerAnlassLinkRepository extends JpaRepository<TeilnehmerAnlassLink, UUID> {
	List<TeilnehmerAnlassLink> findByTeilnehmerAndAnlass(Teilnehmer teilnehmer, Anlass anlass);

	// List<TeilnehmerAnlassLink> findByAnlassAndAktivAndMeldeStatusNotIn(Anlass
	// anlass, boolean aktiv,
	// List<MeldeStatusEnum> exclusion);

	List<TeilnehmerAnlassLink> findByTeilnehmer(Teilnehmer teilnehmer);

	@Query("SELECT tal FROM TeilnehmerAnlassLink tal WHERE tal.anlass = :anlass AND tal.kategorie= :kategorie AND tal.aktiv= :aktiv AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)")
	List<TeilnehmerAnlassLink> findByAnlassAndAktivAndKategorie(Anlass anlass, boolean aktiv,
			List<MeldeStatusEnum> exclusion, KategorieEnum kategorie);

	@Query("SELECT tal FROM TeilnehmerAnlassLink tal WHERE tal.anlass = :anlass AND tal.aktiv= :aktiv AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)")
	List<TeilnehmerAnlassLink> findByAnlassAndAktiv(Anlass anlass, boolean aktiv, List<MeldeStatusEnum> exclusion);

	List<TeilnehmerAnlassLink> findByAnlassAndOrganisation(Anlass anlass, Organisation organisation);

	Optional<TeilnehmerAnlassLink> findTopByStartnummerNotNullOrderByStartnummerDesc();

	@Query(value = "SELECT DISTINCT tal.abteilung FROM teilnehmer_anlass_link tal WHERE tal.anlass_id = :anlass_id AND tal.aktiv= :aktiv AND tal.kategorie= :kategorie AND tal.abteilung IS NOT NULL", nativeQuery = true)
	List<AbteilungEnum> findDistinctByAnlassAndAktivAndKategorie(@Param("anlass_id") UUID anlass_id,
			@Param("aktiv") boolean aktiv, @Param("kategorie") String kategorie);
}
