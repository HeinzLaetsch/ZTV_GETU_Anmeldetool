package org.ztv.anmeldetool.anmeldetool.models;

import java.util.HashMap;
import java.util.Map;

public class AnlagenLauflisten {

	private Map<GeraetEnum, LauflistenContainer> startgeraeteLauflisten;

	public AnlagenLauflisten createFromTal(TeilnehmerAnlassLink tal) {
		if (startgeraeteLauflisten == null) {
			startgeraeteLauflisten = new HashMap<GeraetEnum, LauflistenContainer>();
		}
		LauflistenContainer startgeraeteLaufliste;
		if (startgeraeteLauflisten.containsKey(tal.getStartgeraet())) {
			startgeraeteLaufliste = startgeraeteLauflisten.get(tal.getStartgeraet());
		} else {
			startgeraeteLaufliste = new LauflistenContainer();
			startgeraeteLauflisten.put(tal.getStartgeraet(), startgeraeteLaufliste);
		}
		startgeraeteLaufliste.createFromTal(this, tal);

		return this;
	}
}
