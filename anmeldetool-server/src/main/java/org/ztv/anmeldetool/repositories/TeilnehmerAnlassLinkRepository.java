package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;

@Repository
public interface TeilnehmerAnlassLinkRepository extends JpaRepository<TeilnehmerAnlassLink, UUID> {
	List<TeilnehmerAnlassLink> findByTeilnehmerAndAnlass(Teilnehmer teilnehmer, Anlass anlass);

	// List<TeilnehmerAnlassLink> findByAnlassAndAktivAndMeldeStatusNotIn(Anlass
	// anlass, boolean aktiv,
	// List<MeldeStatusEnum> exclusion);

	List<TeilnehmerAnlassLink> findByTeilnehmer(Teilnehmer teilnehmer);

	@Query("SELECT tal FROM TeilnehmerAnlassLink tal WHERE tal.anlass = :anlass AND tal.kategorie= :kategorie "
			+ "AND tal.aktiv= :aktiv AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL) ORDER BY tal.organisation, tal.notenblatt.rang")
	List<TeilnehmerAnlassLink> findByAnlassAndAktivAndKategorieOrderByOrganisation(Anlass anlass, boolean aktiv,
			List<MeldeStatusEnum> exclusion, KategorieEnum kategorie);

	@Query("SELECT tal FROM TeilnehmerAnlassLink tal WHERE tal.anlass = :anlass AND tal.kategorie= :kategorie AND tal.aktiv= :aktiv AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)")
	List<TeilnehmerAnlassLink> findByAnlassAndAktivAndKategorie(Anlass anlass, boolean aktiv,
			List<MeldeStatusEnum> exclusion, KategorieEnum kategorie);

	@Query("SELECT tal FROM TeilnehmerAnlassLink tal WHERE tal.anlass = :anlass AND tal.kategorie= :kategorie AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)")
	List<TeilnehmerAnlassLink> findByAnlassAndKategorie(Anlass anlass, List<MeldeStatusEnum> exclusion,
			KategorieEnum kategorie);

	@Query("SELECT tal FROM TeilnehmerAnlassLink tal WHERE tal.anlass = :anlass AND tal.aktiv= :aktiv AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL) AND tal.kategorie!='KEIN_START' AND tal.organisation IN (:orgs)")
	List<TeilnehmerAnlassLink> findByAnlassAndAktiv(Anlass anlass, boolean aktiv, List<MeldeStatusEnum> exclusion,
			List<Organisation> orgs);

	@Query("SELECT tal FROM TeilnehmerAnlassLink tal WHERE tal.anlass = :anlass AND tal.aktiv= true AND tal.kategorie <> 'KEIN_START' AND (:kategorie is null or tal.kategorie = :kategorie) AND (:abteilung is null or tal.abteilung = :abteilung) AND (:anlage is null or tal.anlage = :anlage) AND (:geraet is null or tal.startgeraet = :geraet)")
	List<TeilnehmerAnlassLink> findByAnlass(Anlass anlass, KategorieEnum kategorie, AbteilungEnum abteilung,
			AnlageEnum anlage, GeraetEnum geraet);

	List<TeilnehmerAnlassLink> findByAnlassAndOrganisation(Anlass anlass, Organisation organisation);

	Optional<TeilnehmerAnlassLink> findTopByStartnummerNotNullOrderByStartnummerDesc();

	@Query(value = "SELECT DISTINCT tal.abteilung FROM teilnehmer_anlass_link tal WHERE tal.anlass_id = :anlass_id AND tal.aktiv= :aktiv AND tal.kategorie= :kategorie AND tal.abteilung IS NOT NULL ORDER BY tal.abteilung", nativeQuery = true)
	List<AbteilungEnum> findDistinctByAnlassAndAktivAndKategorie(@Param("anlass_id") UUID anlass_id,
			@Param("aktiv") boolean aktiv, @Param("kategorie") String kategorie);

	@Query(value = "SELECT DISTINCT tal.anlage FROM teilnehmer_anlass_link tal WHERE tal.anlass_id = :anlass_id AND tal.aktiv= :aktiv AND tal.kategorie= :kategorie AND tal.abteilung= :abteilung AND tal.anlage IS NOT NULL ORDER BY tal.anlage", nativeQuery = true)
	List<AnlageEnum> findDistinctByAnlassAndAktivAndKategorieAndAbteilung(@Param("anlass_id") UUID anlass_id,
			@Param("aktiv") boolean aktiv, @Param("kategorie") String kategorie, @Param("abteilung") String abteilung);
}
