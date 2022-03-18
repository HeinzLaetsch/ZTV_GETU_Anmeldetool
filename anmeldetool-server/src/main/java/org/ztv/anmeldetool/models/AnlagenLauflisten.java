package org.ztv.anmeldetool.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.Getter;

@Getter
public class AnlagenLauflisten {

	private Map<GeraetEnum, LauflistenContainer> startgeraeteLauflisten;

	private AbteilungsLaufliste abteilungsLaufliste;

	AnlagenLauflisten(AbteilungsLaufliste abteilungsLaufliste) {
		this.abteilungsLaufliste = abteilungsLaufliste;
	}

	public List<LauflistenContainer> getLauflistenContainer() {
		if (startgeraeteLauflisten == null) {
			return new ArrayList<>();
		}
		return new ArrayList<>(startgeraeteLauflisten.values());
	}

	public int incrementKey() {
		return this.abteilungsLaufliste.incrementKey();
	}

	public AnlagenLauflisten createFromTal(TiTuEnum titu, TeilnehmerAnlassLink tal) {
		if (startgeraeteLauflisten == null) {
			startgeraeteLauflisten = new HashMap<GeraetEnum, LauflistenContainer>();
		}
		LauflistenContainer startgeraeteLaufliste;
		if (startgeraeteLauflisten.containsKey(tal.getStartgeraet())) {
			startgeraeteLaufliste = startgeraeteLauflisten.get(tal.getStartgeraet());
		} else {
			startgeraeteLaufliste = new LauflistenContainer(this);
			startgeraeteLauflisten.put(tal.getStartgeraet(), startgeraeteLaufliste);
			startgeraeteLaufliste.setStartgeraet(tal.getStartgeraet());
		}
		startgeraeteLaufliste.createFromTal(titu, tal);

		return this;
	}
}
