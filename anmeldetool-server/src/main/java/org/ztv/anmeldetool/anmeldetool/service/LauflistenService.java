package org.ztv.anmeldetool.anmeldetool.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.LauflistenContainerRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.LauflistenRepository;

import lombok.extern.slf4j.Slf4j;

@Service("lauflistenService")
@Slf4j
public class LauflistenService {

	@Autowired
	LauflistenRepository lauflistenRepo;

	@Autowired
	LauflistenContainerRepository lauflistenContainerRepo;

	@Autowired
	TeilnehmerAnlassLinkService talService;

	@Autowired
	TeilnehmerService teilnehmerService;

	public List<LauflistenContainer> findLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie) {
		List<LauflistenContainer> existierende = lauflistenContainerRepo.findByAnlassAndKategorie(anlass, kategorie);
		return existierende;
	}

	public AnlassLauflisten generateLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie)
			throws ServiceException {
		List<LauflistenContainer> existierende = lauflistenContainerRepo.findByAnlassAndKategorie(anlass, kategorie);
		lauflistenContainerRepo.deleteAll(existierende);
		List<TeilnehmerAnlassLink> tals = talService.findAnlassTeilnahmenByKategorie(anlass, kategorie);
		AnlassLauflisten anlasslaufListen = new AnlassLauflisten();
		for (TeilnehmerAnlassLink tal : tals) {
			anlasslaufListen.createFromTal(tal);
		}
		return anlasslaufListen;
	}
}
