package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.LauflistenContainer;

@Repository
public interface LauflistenContainerRepository extends JpaRepository<LauflistenContainer, UUID> {

	List<LauflistenContainer> findByAnlassAndKategorieOrderByStartgeraetAsc(Anlass anlass, KategorieEnum kategorie);
}
