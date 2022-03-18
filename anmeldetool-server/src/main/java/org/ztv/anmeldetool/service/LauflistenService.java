package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.models.Einzelnote;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Laufliste;
import org.ztv.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.repositories.EinzelnotenRepository;
import org.ztv.anmeldetool.repositories.LauflistenContainerRepository;
import org.ztv.anmeldetool.repositories.LauflistenRepository;
import org.ztv.anmeldetool.repositories.NotenblaetterRepository;

import lombok.extern.slf4j.Slf4j;

@Service("lauflistenService")
@Slf4j
public class LauflistenService {

	@Autowired
	LauflistenRepository lauflistenRepo;

	@Autowired
	LauflistenContainerRepository lauflistenContainerRepo;

	@Autowired
	NotenblaetterRepository notenblaetterRepo;

	@Autowired
	EinzelnotenRepository einzelnotenRepo;

	@Autowired
	TeilnehmerAnlassLinkService talService;

	@Autowired
	TeilnehmerService teilnehmerService;

	public Optional<Laufliste> findLauflisteById(UUID id) {
		return this.lauflistenRepo.findById(id);
	}

	public Optional<Einzelnote> findEinzelnoteById(UUID id) {
		return this.einzelnotenRepo.findById(id);
	}

	public Notenblatt saveNotenblatt(Notenblatt notenblatt) {
		return notenblaetterRepo.save(notenblatt);
	}

	public Einzelnote saveEinzelnote(Einzelnote einzelnote) {
		return einzelnotenRepo.save(einzelnote);
	}

	public List<Einzelnote> saveAllEinzelnoten(List<Einzelnote> einzelnoten) {
		return einzelnotenRepo.saveAll(einzelnoten);
	}

	public Laufliste saveLaufliste(Laufliste laufliste) {
		return lauflistenRepo.save(laufliste);
	}

	public List<Laufliste> saveAllLauflisten(List<Laufliste> lauflisten) {
		return lauflistenRepo.saveAll(lauflisten);
	}

	public LauflistenContainer saveLaufliste(LauflistenContainer lauflistenContainer) {
		return lauflistenContainerRepo.save(lauflistenContainer);
	}

	public List<LauflistenContainer> findLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie,
			AbteilungEnum abteilung, AnlageEnum anlage) {
		List<LauflistenContainer> existierende = lauflistenContainerRepo
				.findByAnlassAndKategorieOrderByStartgeraetAsc(anlass, kategorie);
		log.debug("Found {} Lauflisten for Anlass {} , Kategorie {} , Abteilung {} , Anlage {}", existierende.size(),
				anlass.getAnlassBezeichnung(), kategorie.toString(), abteilung.toString(), anlage.toString());
		existierende = existierende.stream().filter(container -> {
			if (container.getTeilnehmerAnlassLinks() != null && container.getTeilnehmerAnlassLinks().size() > 0
					&& container.getTeilnehmerAnlassLinks().get(0).getAbteilung() != null) {
				if (abteilung.equals(AbteilungEnum.UNDEFINED)
						|| container.getTeilnehmerAnlassLinks().get(0).getAbteilung().equals(abteilung)) {
					if (anlage.equals(AnlageEnum.UNDEFINED)
							|| container.getTeilnehmerAnlassLinks().get(0).getAnlage().equals(anlage)) {
						return true;
					}
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
						&& (abteilung.equals(AbteilungEnum.UNDEFINED) || tal.getAbteilung().equals(abteilung))
						&& (anlage.equals(AnlageEnum.UNDEFINED) || tal.getAnlage().equals(anlage))
						&& tal.getMeldeStatus() != MeldeStatusEnum.ABGEMELDET
						&& tal.getMeldeStatus() != MeldeStatusEnum.UMMELDUNG) {
					tal = this.createNotenblatt(tal);
					anlasslaufListen.createFromTal(anlass.getTiTu(), tal, abteilung, anlage);
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

	public List<LauflistenContainer> getLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie,
			AbteilungEnum abteilung, AnlageEnum anlage) {
		List<LauflistenContainer> existierende = findLauflistenForAnlassAndKategorie(anlass, kategorie, abteilung,
				anlage);
		return existierende;
	}

	public int deleteLauflistenForAnlassAndKategorie(Anlass anlass, KategorieEnum kategorie, AbteilungEnum abteilung,
			AnlageEnum anlage) throws ServiceException {
		List<LauflistenContainer> existierende = findLauflistenForAnlassAndKategorie(anlass, kategorie, abteilung,
				anlage);
		List<Notenblatt> notenblaetter = new ArrayList<Notenblatt>();
		existierende.forEach(container -> {
			container.getTeilnehmerAnlassLinks().forEach(tal -> {
				if (abteilung.equals(AbteilungEnum.UNDEFINED) || tal.getAbteilung().equals(abteilung)) {
					tal.setLauflistenContainer(null);
					talService.save(tal);
					notenblaetter.add(tal.getNotenblatt());
					tal.setNotenblatt(null);
				}
			});
		});
		notenblaetterRepo.deleteAll(notenblaetter);
		lauflistenContainerRepo.deleteAll(existierende);
		return existierende.size();
	}

	private TeilnehmerAnlassLink createNotenblatt(TeilnehmerAnlassLink tal) {
		Notenblatt notenblatt = new Notenblatt();
		List<Einzelnote> einzelnoten = new ArrayList<Einzelnote>();
		notenblatt.setEinzelnoten(einzelnoten);
		notenblatt.setTal(tal);
		tal.setNotenblatt(notenblatt);
		GeraetEnum[] values = GeraetEnum.values();
		for (GeraetEnum value : values) {
			if (GeraetEnum.UNDEFINED.equals(value)) {
				continue;
			}
			Einzelnote einzelnote = new Einzelnote();
			einzelnote.setNotenblatt(notenblatt);
			einzelnote.setGeraet(value);
			einzelnoten.add(einzelnote);
		}
		return tal;
	}

	public Optional<Laufliste> findLauflistenForAnlassAndSearch(Anlass anlass, String search) {
		List<Laufliste> lauflisten = lauflistenRepo.findByKey(search);
		return lauflisten.stream().filter(liste -> {
			return liste.getLauflistenContainer().getAnlass().equals(anlass);
		}).findFirst();
	}

	private void persistLauflisten(AnlassLauflisten anlassLaufListen) {
		List<LauflistenContainer> concated = anlassLaufListen.getLauflistenContainer();
		log.debug("Anzahl Elements {}", concated.size());
		lauflistenContainerRepo.saveAll(concated);
	}
}
