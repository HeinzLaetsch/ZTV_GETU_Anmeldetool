package org.ztv.anmeldetool.service;

import java.time.LocalDateTime;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.VereinsStartDTO;

@Service
public class MailerService {

	private String createTitel(String anlassName, String subject, LocalDateTime startDatum, LocalDateTime endDatum) {
		String art = startDatum.isBefore(endDatum)
				? "die "
				: "den ";
		return subject + " für " + art + anlassName;
	}
	public Map<String, Object> getRiegenAufteilungsDaten(Anlass anlass, Map<String, Boolean> aufgeteilt, Organisation organisation,
			String subject) {

		Map<String, Object> templateModel = new HashMap();

		templateModel.put("vereinsname", organisation.getName());

		String titel = createTitel(anlass.getAnlassBezeichnung(), subject, anlass.getStartDate(), anlass.getEndDate());
		templateModel.put("titel", titel );
		templateModel.put("subject", titel);

    templateModel.putAll(aufgeteilt);

		return templateModel;
	}
	public Map<String, Object> getAnmeldeDaten(AnmeldeKontrolleDTO anmeldeKontrolle, Organisation organisation,
			String subject) {

		Map<String, Object> templateModel = new HashMap();
		VereinsStartDTO vereinsStart = null;

		if (anmeldeKontrolle.getVereinsStart() != null && anmeldeKontrolle.getVereinsStart().size() == 1) {
			vereinsStart = anmeldeKontrolle.getVereinsStart().getFirst();
			templateModel.put("startet", "Dein Verein startet");
		} else {
			vereinsStart = new VereinsStartDTO();
			templateModel.put("startet", "Dein Verein startet nicht");
		}
		String anlassName = anmeldeKontrolle.getDetailAnlassName();
    //TODO wird nachher überschrieben
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

		templateModel.put("k5A", vereinsStart.getK5A_Ti());
		templateModel.put("k5B", vereinsStart.getK5B_Ti());
		templateModel.put("k5", vereinsStart.getK5_Tu());

		templateModel.put("k6Ti", vereinsStart.getK6_Ti());
		templateModel.put("k6Tu", vereinsStart.getK6_Tu());

		templateModel.put("kD", vereinsStart.getKD_Ti());
		templateModel.put("kH", vereinsStart.getKH_Tu());

		templateModel.put("k7Ti", vereinsStart.getK7_Ti());
		templateModel.put("k7Tu", vereinsStart.getK7_Tu());

		return templateModel;
	}

	public Map<String, Object> getPublishedDaten(AnmeldeKontrolleDTO anlassKontrolle, String subject,
			Organisation org) {

		Map<String, Object> templateModel = new HashMap();

		String anlassName = anlassKontrolle.getDetailAnlassName();
		templateModel.put("vereinsname", org.getName());

		templateModel.put("titel", subject + " für : " + anlassName);
		templateModel.put("subject", subject + " für : " + anlassName);

		return templateModel;
	}
}
