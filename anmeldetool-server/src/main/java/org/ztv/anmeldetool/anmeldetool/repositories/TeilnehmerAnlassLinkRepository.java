package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;

@Repository
public interface TeilnehmerAnlassLinkRepository extends JpaRepository<TeilnehmerAnlassLink, UUID> {
	// select 
	// teilnehmer0_.id as id1_8_, teilnehmer0_.aktiv as aktiv2_8_, teilnehmer0_.change_date as change_d3_8_, teilnehmer0_.deleted as deleted4_8_, teilnehmer0_.deletion_date as deletion5_8_, teilnehmer0_.anlass_id as anlass_i7_8_, 
	// teilnehmer0_.kategorie as kategori6_8_, teilnehmer0_.teilnehmer_id as teilnehm8_8_ from teilnehmer_anlass_link teilnehmer0_ 
	// where teilnehmer0_.teilnehmer_id=? and teilnehmer0_.anlass_id=?
	List<TeilnehmerAnlassLink> findByTeilnehmerAndAnlass(Teilnehmer teilnehmer, Anlass anlass);
	List<TeilnehmerAnlassLink> findByAnlass(Anlass anlass);
	List<TeilnehmerAnlassLink> findByAnlassAndOrganisation(Anlass anlass, Organisation organisation);
}
