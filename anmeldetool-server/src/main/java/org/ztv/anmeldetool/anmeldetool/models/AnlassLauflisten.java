package org.ztv.anmeldetool.anmeldetool.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AnlassLauflisten {

	Map<AbteilungEnum, AbteilungsLaufliste> abteilungsLauflisten;

	private int key = 1;

	public int incrementKey() {
		return key++;
	}

	public AnlassLauflisten createFromTal(TeilnehmerAnlassLink tal) {
		if (abteilungsLauflisten == null) {
			abteilungsLauflisten = new HashMap<AbteilungEnum, AbteilungsLaufliste>();
		}
		AbteilungsLaufliste abteilungsLaufliste;
		if (abteilungsLauflisten.containsKey(tal.getAbteilung())) {
			abteilungsLaufliste = abteilungsLauflisten.get(tal.getAbteilung());
		} else {
			abteilungsLaufliste = new AbteilungsLaufliste(this);
			abteilungsLauflisten.put(tal.getAbteilung(), abteilungsLaufliste);
		}
		abteilungsLaufliste.createFromTal(tal);

		return this;
	}

	public List<LauflistenContainer> getLauflistenContainer() {
		List<LauflistenContainer> concated = new ArrayList<>();
		if (abteilungsLauflisten == null) {
			return concated;
		}
		for (AbteilungsLaufliste liste : abteilungsLauflisten.values()) {
			concated.addAll(liste.getLauflistenContainer());
		}
		return concated;
	}
}
