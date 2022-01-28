package org.ztv.anmeldetool.anmeldetool.models;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "LAUFLISTEN_CONTAINER")
@Getter
@Setter
public class LauflistenContainer extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANLASS_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Anlass anlass;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "lauflistenContainer")
	@ToString.Exclude
	private List<TeilnehmerAnlassLink> teilnehmerAnlassLinks;

	@Transient
	private AnlagenLauflisten anlagenLauflisten;

	@Enumerated(EnumType.STRING)
	private KategorieEnum kategorie;

	private boolean erfasst;

	private boolean checked;

	private int key;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "lauflistenContainer", cascade = { CascadeType.ALL })
	@ToString.Exclude
	private List<Laufliste> geraeteLauflisten;

	public LauflistenContainer createFromTal(AnlagenLauflisten anlagenLauflisten, TeilnehmerAnlassLink tal) {
		this.anlagenLauflisten = anlagenLauflisten;
		if (geraeteLauflisten == null) {
			geraeteLauflisten = new ArrayList<Laufliste>();
			// geraeteLauflisten.clear();
			GeraetEnum[] values = GeraetEnum.values();
			Map<GeraetEnum, Laufliste> hashListen = new HashMap<GeraetEnum, Laufliste>();
			for (GeraetEnum value : values) {
				Laufliste laufliste;
				if (!hashListen.containsKey(value)) {
					laufliste = new Laufliste();
					laufliste.setAktiv(true);
					laufliste.setChecked(false);
					laufliste.setErfasst(false);
					laufliste.setGeraet(value);
					laufliste.setId(UUID.randomUUID());
					laufliste.setLauflistenContainer(this);
					laufliste.setChangeDate(Calendar.getInstance());
					laufliste.setKey(getKey(laufliste.hashCode()));
					geraeteLauflisten.add(laufliste);
				}
			}
		}
		if (teilnehmerAnlassLinks == null) {
			teilnehmerAnlassLinks = new ArrayList<TeilnehmerAnlassLink>();
		}
		teilnehmerAnlassLinks.add(tal);
		return this;
	}

	private String getKey(int hashCode) {
		// max int 2147483647
		int quersumme = 0;
		for (int stelle = 1; stelle <= 10; stelle++) {
			int rest = hashCode % 10;
			quersumme += rest;
			hashCode /= 10;
		}
		return String.format("%d", quersumme);
	}
}
