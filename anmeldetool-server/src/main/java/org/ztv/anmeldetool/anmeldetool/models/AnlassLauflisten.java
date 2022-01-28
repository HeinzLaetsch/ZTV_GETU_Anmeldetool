package org.ztv.anmeldetool.anmeldetool.models;

import java.util.HashMap;
import java.util.Map;

public class AnlassLauflisten {

	Map<AbteilungEnum, AbteilungsLaufliste> abteilungsLauflisten;

	public AnlassLauflisten createFromTal(TeilnehmerAnlassLink tal) {
		if (abteilungsLauflisten == null) {
			abteilungsLauflisten = new HashMap<AbteilungEnum, AbteilungsLaufliste>();
		}
		AbteilungsLaufliste abteilungsLaufliste;
		if (abteilungsLauflisten.containsKey(tal.getAbteilung())) {
			abteilungsLaufliste = abteilungsLauflisten.get(tal.getAbteilung());
		} else {
			abteilungsLaufliste = new AbteilungsLaufliste();
			abteilungsLauflisten.put(tal.getAbteilung(), abteilungsLaufliste);
		}
		abteilungsLaufliste.createFromTal(tal);

		return this;
	}
}
