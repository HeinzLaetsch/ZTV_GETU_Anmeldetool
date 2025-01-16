package org.ztv.anmeldetool.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.VereinsStartDTO;

@Service
public class MailerService {

	@Autowired
	AnlassService anlassSrv;

	public Map<String, Object> getAnmeldeDaten(AnmeldeKontrolleDTO anmeldeKontrolle, Organisation organisation,
			String subject) {

		// AnmeldeKontrolleDTO anmeldeKontrolle =
		// anlassSrv.getAnmeldeKontrolle(anlass.getId(), organisation.getId());

		Map<String, Object> templateModel = new HashMap();
		VereinsStartDTO vereinsStart = null;

		if (anmeldeKontrolle.getVereinsStart() != null && anmeldeKontrolle.getVereinsStart().size() == 1) {
			vereinsStart = anmeldeKontrolle.getVereinsStart().get(0);
			templateModel.put("startet", "Dein Verein startet");
		} else {
			vereinsStart = new VereinsStartDTO();
			templateModel.put("startet", "Dein Verein startet nicht");
		}
		String anlassName = anmeldeKontrolle.getDetailAnlassName();
		String art = anmeldeKontrolle.getAnlass().getStartDatum().equals(anmeldeKontrolle.getAnlass().getEndDatum())
				? "den "
				: "die ";
		art = " : ";
		templateModel.put("vereinsname", organisation.getName());

		templateModel.put("titel", subject + " für " + art + anlassName);
		templateModel.put("subject", subject + " für " + art + anlassName);

		templateModel.put("anzahlBr1", vereinsStart.getBr1());
		templateModel.put("anzahlBr2", vereinsStart.getBr2());

		templateModel.put("totalStarts", vereinsStart.getTotal());
		templateModel.put("totalBr1", vereinsStart.getTotal_br1());
		templateModel.put("totalBr2", vereinsStart.getTotal_br2());

		templateModel.put("k1Ti", vereinsStart.getK1_Ti());
		templateModel.put("k1Tu", vereinsStart.getK1_Tu());

		templateModel.put("k2Ti", vereinsStart.getK2_Ti());
		templateModel.put("k2Tu", vereinsStart.getK2_Tu());

		templateModel.put("k3Ti", vereinsStart.getK3_Ti());
		templateModel.put("k3Tu", vereinsStart.getK3_Tu());

		templateModel.put("k4Ti", vereinsStart.getK4_Ti());
		templateModel.put("k4Tu", vereinsStart.getK4_Tu());

		templateModel.put("k5A", vereinsStart.getK5A());
		templateModel.put("k5B", vereinsStart.getK5B());
		templateModel.put("k5", vereinsStart.getK5());

		templateModel.put("k6Ti", vereinsStart.getK6_Ti());
		templateModel.put("k6Tu", vereinsStart.getK6_Tu());

		templateModel.put("kD", vereinsStart.getKD());
		templateModel.put("kH", vereinsStart.getKH());

		templateModel.put("k7Ti", vereinsStart.getK7_Ti());
		templateModel.put("k7Tu", vereinsStart.getK7_Tu());

		return templateModel;
	}

	public Map<String, Object> getPublishedDaten(AnmeldeKontrolleDTO anlassKontrolle, String subject,
			Organisation org) {

		// AnmeldeKontrolleDTO anmeldeKontrolle =
		// anlassSrv.getAnmeldeKontrolle(anlass.getId(), organisation.getId());

		Map<String, Object> templateModel = new HashMap();

		String anlassName = anlassKontrolle.getDetailAnlassName();
		templateModel.put("vereinsname", org.getName());

		templateModel.put("titel", subject + " für : " + anlassName);
		templateModel.put("subject", subject + " für : " + anlassName);

		return templateModel;
	}

}
