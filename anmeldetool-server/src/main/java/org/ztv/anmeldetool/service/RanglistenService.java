package org.ztv.anmeldetool.service;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.NotenblaetterRepository;
import org.ztv.anmeldetool.repositories.RanglisteConfigurationRepository;

import lombok.extern.slf4j.Slf4j;

@Service("ranglistenService")
@Slf4j
public class RanglistenService {

	@Autowired
	TeilnehmerAnlassLinkService talService;

	@Autowired
	NotenblaetterRepository notenblaetterRepo;

	@Autowired
	RanglisteConfigurationRepository ranglisteConfigurationRepo;

	public RanglisteConfiguration saveRanglisteConfiguration(RanglisteConfiguration rc) {
		Optional<RanglisteConfiguration> entityOpt = ranglisteConfigurationRepo.findById(rc.getId());
		if (entityOpt.isPresent()) {
			entityOpt.get().setMaxAuszeichnungen(rc.getMaxAuszeichnungen());
			return ranglisteConfigurationRepo.save(entityOpt.get());
		}
		return ranglisteConfigurationRepo.save(rc);
	}

	public RanglisteConfiguration getRanglisteConfiguration(Anlass anlass, KategorieEnum kategorie, TiTuEnum tiTu) {
		Optional<RanglisteConfiguration> ranglistenConfigOpt = anlass.getRanglisteConfigurationen().stream()
				.filter(conf -> {
					return conf.getKategorie().equals(kategorie) && conf.getTiTu().equals(tiTu);
				}).findFirst();
		RanglisteConfiguration ranglistenConfig = null;
		if (ranglistenConfigOpt.isEmpty()) {
			ranglistenConfig = new RanglisteConfiguration(anlass, kategorie, tiTu, 0);
		} else {
			ranglistenConfig = ranglistenConfigOpt.get();
		}
		return ranglistenConfig;
	}

	public int calcMaxAuszeichnungen(List<TeilnehmerAnlassLink> tals, int maxAuszeichung) throws ServiceException {
		if (maxAuszeichung == 0) {
			maxAuszeichung = (int) Math.ceil(tals.size() * 0.4);
		}
		return maxAuszeichung;
	}

	public List<TeilnehmerAnlassLink> getTeilnehmerSorted(Anlass anlass, KategorieEnum kategorie, TiTuEnum titu)
			throws ServiceException {
		List<TeilnehmerAnlassLink> tals = talService.findWettkampfTeilnahmenByKategorie(anlass, kategorie);
		tals = tals.stream().sorted(
				Comparator.comparing(tal -> tal.getNotenblatt().getGesamtPunktzahl(), Comparator.reverseOrder()))
				.collect(Collectors.toList());
		return tals;
	}

	public List<TeilnehmerAnlassLink> createRangliste(List<TeilnehmerAnlassLink> tals, int maxAuszeichung)
			throws ServiceException {

		int rang = 0;
		int pos = 0;
		float last = 0.0f;
		for (TeilnehmerAnlassLink tal : tals) {
			pos++;
			float actual = tal.getNotenblatt().getGesamtPunktzahl();
			if (last != actual) {
				rang = pos;
				last = actual;
			}
			tal.getNotenblatt().setRang(rang);
			if (rang <= maxAuszeichung) {
				tal.getNotenblatt().setAuszeichnung(true);
			} else {
				tal.getNotenblatt().setAuszeichnung(false);
			}
		}
		;
		return tals;
	}
}
