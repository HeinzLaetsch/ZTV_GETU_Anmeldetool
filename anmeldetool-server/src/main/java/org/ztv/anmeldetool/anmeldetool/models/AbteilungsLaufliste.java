package org.ztv.anmeldetool.anmeldetool.models;

import java.util.HashMap;
import java.util.Map;

public class AbteilungsLaufliste {

	Map<AnlageEnum, AnlagenLauflisten> anlagenLauflisten;

	public AbteilungsLaufliste createFromTal(TeilnehmerAnlassLink tal) {
		if (anlagenLauflisten == null) {
			anlagenLauflisten = new HashMap<AnlageEnum, AnlagenLauflisten>();
		}
		AnlagenLauflisten anlageLaufliste;
		if (anlagenLauflisten.containsKey(tal.getAnlage())) {
			anlageLaufliste = anlagenLauflisten.get(tal.getAnlage());
		} else {
			anlageLaufliste = new AnlagenLauflisten();
			anlagenLauflisten.put(tal.getAnlage(), anlageLaufliste);
		}
		anlageLaufliste.createFromTal(tal);
		return this;
	}
}
