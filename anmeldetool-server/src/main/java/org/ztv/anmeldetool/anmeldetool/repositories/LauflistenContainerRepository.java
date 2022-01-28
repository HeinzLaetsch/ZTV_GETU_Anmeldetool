package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.LauflistenContainer;

@Repository
public interface LauflistenContainerRepository extends JpaRepository<LauflistenContainer, UUID> {

	List<LauflistenContainer> findByAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie);
}
