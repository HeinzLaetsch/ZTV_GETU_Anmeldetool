package org.ztv.anmeldetool.service;

import java.util.List;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;

import lombok.extern.slf4j.Slf4j;

@SpringBootTest
@ActiveProfiles("eclipse")
@Disabled
@Slf4j
public class RanglistenServiceTests {

	@Autowired
	RanglistenService ranglistenService;

	@Autowired
	AnlassService anlassService;

	@Test
	public void testCreateRanglisteK5() throws Exception {
		Anlass anlass = anlassService.getAnlaesse(true).get(0);

		List<TeilnehmerAnlassLink> tals = ranglistenService.getTeilnehmerSorted(anlass, KategorieEnum.K5, TiTuEnum.Tu);
		int maxAuszeichnung = ranglistenService.calcMaxAuszeichnungen(tals, 0);

		tals = ranglistenService.createRangliste(tals, maxAuszeichnung);
		tals.forEach(tal -> {
			log.info(String.format("%d %s %s %.2f", tal.getNotenblatt().getRang(), tal.getTeilnehmer().getName(),
					tal.getTeilnehmer().getVorname(), tal.getNotenblatt().getGesamtPunktzahl()));
		});
	}

	@Test
	public void testCreateRanglisteK6() throws Exception {
		Anlass anlass = anlassService.getAnlaesse(true).get(0);
		List<TeilnehmerAnlassLink> tals = ranglistenService.getTeilnehmerSorted(anlass, KategorieEnum.K6, TiTuEnum.Tu);
		int maxAuszeichnung = ranglistenService.calcMaxAuszeichnungen(tals, 0);

		tals = ranglistenService.createRangliste(tals, maxAuszeichnung);
		tals.forEach(tal -> {
			log.info(String.format("%d %s %s %.2f", tal.getNotenblatt().getRang(), tal.getTeilnehmer().getName(),
					tal.getTeilnehmer().getVorname(), tal.getNotenblatt().getGesamtPunktzahl()));
		});
	}

	private float runden(float wert) {
		double scale = Math.pow(10, 2);
		return (float) ((float) Math.round((wert + 0.001) * scale) / scale); // c
	}
}
