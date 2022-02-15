package org.ztv.anmeldetool.service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.NotenblaetterRepository;

import lombok.extern.slf4j.Slf4j;

@Service("ranglistenService")
@Slf4j
public class RanglistenService {

	@Autowired
	TeilnehmerAnlassLinkService talService;

	@Autowired
	NotenblaetterRepository notenblaetterRepo;

	public List<TeilnehmerAnlassLink> createRangliste(Anlass anlass, KategorieEnum kategorie, TiTuEnum titu,
			int maxAuszeichung) throws ServiceException {
		List<TeilnehmerAnlassLink> tals = talService.findWettkampfTeilnahmenByKategorie(anlass, kategorie);
		if (maxAuszeichung == 0) {
			maxAuszeichung = (int) Math.ceil(tals.size() * 0.4);
		}
		tals = tals.stream().sorted(
				Comparator.comparing(tal -> tal.getNotenblatt().getGesamtPunktzahl(), Comparator.reverseOrder()))
				.collect(Collectors.toList());
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
