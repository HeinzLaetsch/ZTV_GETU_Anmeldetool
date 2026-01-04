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
import org.ztv.anmeldetool.models.TiTuEnum;

@Repository
public interface TeilnehmerAnlassLinkRepository extends JpaRepository<TeilnehmerAnlassLink, UUID> {
	List<TeilnehmerAnlassLink> findByTeilnehmerAndAnlass(Teilnehmer teilnehmer, Anlass anlass);

	// List<TeilnehmerAnlassLink> findByAnlassAndAktivAndMeldeStatusNotIn(Anlass
	// anlass, boolean aktiv,
	// List<MeldeStatusEnum> exclusion);

	List<TeilnehmerAnlassLink> findByTeilnehmer(Teilnehmer teilnehmer);

	Optional<TeilnehmerAnlassLink> findByAnlassAndTeilnehmer(Anlass anlass, Teilnehmer teilnehmer);

	@Query("""
			SELECT tal FROM TeilnehmerAnlassLink tal
			JOIN tal.teilnehmer t
			WHERE tal.anlass = :anlass
			  AND tal.kategorie = :kategorie
			  AND t.tiTu = :tiTu
			  AND tal.aktiv = :aktiv
			  AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)
			ORDER BY tal.organisation, tal.notenblatt.rang
			""")
	List<TeilnehmerAnlassLink> findByAnlassAndAktivAndKategorieAndTiTuOrderByOrganisation(Anlass anlass, boolean aktiv,
			List<MeldeStatusEnum> exclusion, KategorieEnum kategorie, TiTuEnum tiTu);

	@Query("""
			SELECT tal FROM TeilnehmerAnlassLink tal
			WHERE tal.anlass = :anlass
			  AND tal.kategorie = :kategorie
			  AND tal.aktiv = :aktiv
			  AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)
			""")
	List<TeilnehmerAnlassLink> findByAnlassAndAktivAndKategorie(Anlass anlass, boolean aktiv,
			List<MeldeStatusEnum> exclusion, KategorieEnum kategorie);

	@Query("""
			SELECT tal FROM TeilnehmerAnlassLink tal
			JOIN tal.teilnehmer t
			WHERE tal.anlass = :anlass
			  AND tal.kategorie = :kategorie
			  AND t.tiTu = :tiTu
			  AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)
			""")
	List<TeilnehmerAnlassLink> findByAnlassAndKategorieAndTiTu(Anlass anlass, List<MeldeStatusEnum> exclusion,
			KategorieEnum kategorie, TiTuEnum tiTu);

	@Query("""
			SELECT tal FROM TeilnehmerAnlassLink tal
			WHERE tal.anlass = :anlass
			  AND tal.aktiv = :aktiv
			  AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)
			  AND tal.kategorie <> org.ztv.anmeldetool.models.KategorieEnum.KEIN_START
			  AND tal.organisation IN (:orgs)
			""")
	List<TeilnehmerAnlassLink> findByAnlassAndAktiv(Anlass anlass, boolean aktiv, List<MeldeStatusEnum> exclusion,
			List<Organisation> orgs);

	@Query("""
			SELECT tal FROM TeilnehmerAnlassLink tal
			WHERE tal.anlass = :anlass
			  AND tal.aktiv = true
			  AND tal.kategorie <> org.ztv.anmeldetool.models.KategorieEnum.KEIN_START
			  AND (:kategorie IS NULL OR tal.kategorie = :kategorie)
			  AND (:abteilung IS NULL OR tal.abteilung = :abteilung)
			  AND (:anlage IS NULL OR tal.anlage = :anlage)
			  AND (:geraet IS NULL OR tal.startgeraet = :geraet)
			""")
	List<TeilnehmerAnlassLink> findByAnlass(Anlass anlass, KategorieEnum kategorie, AbteilungEnum abteilung,
			AnlageEnum anlage, GeraetEnum geraet);

	List<TeilnehmerAnlassLink> findByAnlassAndOrganisation(Anlass anlass, Organisation organisation);

	@Query("""
			SELECT tal FROM TeilnehmerAnlassLink tal
			WHERE tal.anlass = :anlass
			  AND tal.organisation = :organisation
			  AND (tal.meldeStatus NOT IN (:exclusion) OR tal.meldeStatus IS NULL)
			""")
	List<TeilnehmerAnlassLink> findByAnlassAndOrganisationExclude(Anlass anlass, Organisation organisation,
			List<MeldeStatusEnum> exclusion);

	Optional<TeilnehmerAnlassLink> findTopByStartnummerNotNullOrderByStartnummerDesc();

	@Query("SELECT DISTINCT tal.abteilung FROM TeilnehmerAnlassLink tal WHERE tal.anlass.id = :anlassId AND tal.aktiv = :aktiv AND tal.kategorie = :kategorie AND tal.abteilung IS NOT NULL ORDER BY tal.abteilung")
	List<AbteilungEnum> findDistinctAbteilungenByAnlassAndKategorie(@Param("anlassId") UUID anlassId,
			@Param("aktiv") boolean aktiv, @Param("kategorie") KategorieEnum kategorie);

	@Query("SELECT DISTINCT tal.anlage FROM TeilnehmerAnlassLink tal WHERE tal.anlass.id = :anlassId AND tal.aktiv = :aktiv AND tal.kategorie = :kategorie AND tal.abteilung = :abteilung AND tal.anlage IS NOT NULL ORDER BY tal.anlage")
	List<AnlageEnum> findDistinctAnlagenByAnlassAndKategorieAndAbteilung(@Param("anlassId") UUID anlassId,
			@Param("aktiv") boolean aktiv, @Param("kategorie") KategorieEnum kategorie, @Param("abteilung") AbteilungEnum abteilung);
}
