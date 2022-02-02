package org.ztv.anmeldetool.anmeldetool.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.anmeldetool.models.MeldeStatusEnum;
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

	public List<LauflistenContainer> findLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie,
			AbteilungEnum abteilung, AnlageEnum anlage) {
		List<LauflistenContainer> existierende = lauflistenContainerRepo
				.findByAnlassAndKategorieOrderByStartgeraetAsc(anlass, kategorie);
		existierende = existierende.stream().filter(container -> {
			if (container.getTeilnehmerAnlassLinks() != null && container.getTeilnehmerAnlassLinks().size() > 0
					&& container.getTeilnehmerAnlassLinks().get(0).getAbteilung() != null) {
				if (abteilung.equals(AbteilungEnum.UNDEFINED)
						|| container.getTeilnehmerAnlassLinks().get(0).getAbteilung().equals(abteilung)) {
					return true;
				}
			}
			return false;
		}).collect(Collectors.toList());
		return existierende;
	}

	public AnlassLauflisten generateLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie,
			AbteilungEnum abteilung, AnlageEnum anlage) throws ServiceException {

		List<LauflistenContainer> existierende = findLauflistenForAnlassAndKategorie(anlass, kategorie, abteilung,
				anlage);
		if (existierende.size() > 0) {
			throw new ServiceException(LauflistenService.class,
					String.format("Es existieren schon Lauflisten für Anlass {} und Kategorie {}",
							anlass.getAnlassBezeichnung(), kategorie));
		}
		try {
			List<TeilnehmerAnlassLink> tals = talService.findAnlassTeilnahmenByKategorie(anlass, kategorie);
			AnlassLauflisten anlasslaufListen = new AnlassLauflisten();
			for (TeilnehmerAnlassLink tal : tals) {
				if (tal.getAbteilung() != null && tal.getAnlage() != null && tal.getStartgeraet() != null
						&& tal.getMeldeStatus() != MeldeStatusEnum.ABGEMELDET
						&& tal.getMeldeStatus() != MeldeStatusEnum.UMMELDUNG) {
					anlasslaufListen.createFromTal(tal, abteilung, anlage);
				}
			}
			persistLauflisten(anlasslaufListen);
			return anlasslaufListen;
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(LauflistenService.class,
					String.format("Fehler beim generieren von Lauflisten für Anlass {} und Kategorie {}, {}",
							anlass.getAnlassBezeichnung(), kategorie, ex.getMessage()));
		}
	}

	public int deleteLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie, AbteilungEnum abteilung,
			AnlageEnum anlage) throws ServiceException {
		List<LauflistenContainer> existierende = findLauflistenForAnlassAndKategorie(anlass, kategorie, abteilung,
				anlage);
		existierende.forEach(container -> {
			container.getTeilnehmerAnlassLinks().forEach(tal -> {
				if (abteilung.equals(AbteilungEnum.UNDEFINED) || tal.getAbteilung().equals(abteilung)) {
					tal.setLauflistenContainer(null);
					talService.save(tal);
				}
			});
		});
		lauflistenContainerRepo.deleteAll(existierende);
		return existierende.size();
	}

	private void persistLauflisten(AnlassLauflisten anlassLaufListen) {
		List<LauflistenContainer> concated = anlassLaufListen.getLauflistenContainer();
		log.debug("Anzahl Elements {}", concated.size());
		/*
		 * concated.forEach(container -> {
		 * container.getTeilnehmerAnlassLinks().forEach(tal -> {
		 * tal.setLauflistenContainer(container); talService.save(tal); }); });
		 */
		lauflistenContainerRepo.saveAll(concated);
	}
}
