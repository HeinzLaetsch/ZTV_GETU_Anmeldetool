package org.ztv.anmeldetool.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AbteilungsLaufliste {

	private Map<AnlageEnum, AnlagenLauflisten> anlagenLauflisten;
	private AnlassLauflisten anlassLauflisten;

	AbteilungsLaufliste(AnlassLauflisten anlassLauflisten) {
		this.anlassLauflisten = anlassLauflisten;
	}

	public List<LauflistenContainer> getLauflistenContainer() {
		List<LauflistenContainer> concated = new ArrayList<>();
		if (anlagenLauflisten == null) {
			return concated;
		}
		for (AnlagenLauflisten liste : anlagenLauflisten.values()) {
			concated.addAll(liste.getLauflistenContainer());
		}
		return concated;
	}

	public int incrementKey() {
		return this.anlassLauflisten.incrementKey();
	}

	public AbteilungsLaufliste createFromTal(TeilnehmerAnlassLink tal, AnlageEnum anlage) {
		if (anlagenLauflisten == null) {
			anlagenLauflisten = new HashMap<AnlageEnum, AnlagenLauflisten>();
		}
		if (anlage.equals(AnlageEnum.UNDEFINED) || anlage.equals(tal.getAnlage())) {
			AnlagenLauflisten anlageLaufliste;
			if (anlagenLauflisten.containsKey(tal.getAnlage())) {
				anlageLaufliste = anlagenLauflisten.get(tal.getAnlage());
			} else {
				anlageLaufliste = new AnlagenLauflisten(this);
				anlagenLauflisten.put(tal.getAnlage(), anlageLaufliste);
			}
			anlageLaufliste.createFromTal(tal);
		}
		return this;
	}
}
