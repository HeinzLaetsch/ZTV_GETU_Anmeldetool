package org.ztv.anmeldetool.models;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class AnlassLauflisten {

	Map<AbteilungEnum, AbteilungsLaufliste> abteilungsLauflisten;

	private int key = 1;

	public int incrementKey() {
		return key++;
	}

	public AnlassLauflisten createFromTal(TiTuEnum titu, TeilnehmerAnlassLink tal, AbteilungEnum abteilung,
			AnlageEnum anlage) {
		if (abteilungsLauflisten == null) {
			abteilungsLauflisten = new HashMap<AbteilungEnum, AbteilungsLaufliste>();
		}
		AbteilungsLaufliste abteilungsLaufliste;
		if (abteilung.equals(AbteilungEnum.UNDEFINED) || abteilung.equals(tal.getAbteilung())) {
			if (abteilungsLauflisten.containsKey(tal.getAbteilung())) {
				abteilungsLaufliste = abteilungsLauflisten.get(tal.getAbteilung());
			} else {
				abteilungsLaufliste = new AbteilungsLaufliste(this);
				abteilungsLauflisten.put(tal.getAbteilung(), abteilungsLaufliste);
			}
			abteilungsLaufliste.createFromTal(titu, tal, anlage);
		}

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
		return concated.stream().sorted(Comparator.comparingInt(LauflistenContainer::getStartgeraetOrd))
				.collect(Collectors.toList());
	}
}
