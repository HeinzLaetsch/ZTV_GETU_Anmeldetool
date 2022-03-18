package org.ztv.anmeldetool.models;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

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

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "LAUFLISTEN_CONTAINER")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class LauflistenContainer extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANLASS_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Anlass anlass;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "lauflistenContainer", cascade = { CascadeType.PERSIST,
			CascadeType.MERGE })
	@ToString.Exclude
	private List<TeilnehmerAnlassLink> teilnehmerAnlassLinks;

	@Transient
	private AnlagenLauflisten anlagenLauflisten;

	@Enumerated(EnumType.STRING)
	private KategorieEnum kategorie;

	@Enumerated(EnumType.ORDINAL)
	private GeraetEnum startgeraet;

	private boolean erfasst;

	private boolean checked;

	private int key;

	@OneToMany(fetch = FetchType.EAGER, mappedBy = "lauflistenContainer", cascade = { CascadeType.ALL })
	@ToString.Exclude
	private List<Laufliste> geraeteLauflisten;

	LauflistenContainer(AnlagenLauflisten anlagenLauflisten) {
		this.anlagenLauflisten = anlagenLauflisten;
	}

	public List<TeilnehmerAnlassLink> getTeilnehmerAnlassLinksOrdered() {
		return this.teilnehmerAnlassLinks.stream()
				.sorted(Comparator.comparing(TeilnehmerAnlassLink::getOrganisation, (o1, o2) -> {
					return o2.compareTo(o1);
				})).collect(Collectors.toList());
	}

	public int getStartgeraetOrd() {
		return this.startgeraet.ordinal();
	}

	public int incrementKey() {
		key = this.anlagenLauflisten.incrementKey();
		return key;
	}

	public LauflistenContainer createFromTal(TiTuEnum titu, TeilnehmerAnlassLink tal) {
		if (geraeteLauflisten == null) {
			geraeteLauflisten = new ArrayList<Laufliste>();
			this.anlass = tal.getAnlass();
			this.kategorie = tal.getKategorie();
			// geraeteLauflisten.clear();
			GeraetEnum[] values = GeraetEnum.values();
			Map<GeraetEnum, Laufliste> hashListen = new HashMap<GeraetEnum, Laufliste>();
			for (GeraetEnum value : values) {
				if (GeraetEnum.UNDEFINED.equals(value)) {
					continue;
				}
				if (TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu()) && GeraetEnum.BARREN.equals(value)) {
					continue;
				}
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
		tal.setLauflistenContainer(this);
		updateEinzelnoten(tal);
		return this;
	}

	private void updateEinzelnoten(TeilnehmerAnlassLink tal) {
		List<Einzelnote> einzelnoten = tal.getNotenblatt().getEinzelnoten();
		this.getGeraeteLauflisten().stream().forEach(laufliste -> {
			if (laufliste.getEinzelnoten() == null) {
				laufliste.setEinzelnoten(new ArrayList<Einzelnote>());
			}
			einzelnoten.stream().forEach(einzelnote -> {
				if (laufliste.getGeraet().equals(einzelnote.getGeraet())) {
					laufliste.getEinzelnoten().add(einzelnote);
					einzelnote.setLaufliste(laufliste);
				}
			});
		});
	}

	private String getKey(int hashCode) {
		// max int 2147483647
		hashCode = Math.abs(hashCode);
		int quersumme = 0;
		for (int stelle = 1; stelle <= 10; stelle++) {
			int rest = hashCode % 10;
			quersumme += rest;
			hashCode /= 10;
		}
		String key = String.format("%03d", incrementKey()) + String.format("%d", quersumme);
		if (key.length() > 5) {
			System.out.println("Help: " + key);
		}
		return key;
	}
}
