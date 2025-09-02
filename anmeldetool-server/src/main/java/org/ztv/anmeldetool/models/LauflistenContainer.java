package org.ztv.anmeldetool.models;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import org.ztv.anmeldetool.repositories.LauflistenRepository;

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
		// this.teilnehmerAnlassLinks.sort(TeilnehmerAnlassLink::compareByTiTuThenVereinThenName);
		Collections.sort(this.teilnehmerAnlassLinks,
				Collections.reverseOrder(TeilnehmerAnlassLink::compareByTiTuThenVereinThenName));
		return this.teilnehmerAnlassLinks;
	}

	public int getStartgeraetOrd() {
		return this.startgeraet.ordinal();
	}

	public int incrementKey() {
		key = this.anlagenLauflisten.incrementKey();
		return key;
	}

	public LauflistenContainer createFromTal(LauflistenRepository lauflistenRepo, TiTuEnum titu,
			TeilnehmerAnlassLink tal) {
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
				if (TiTuEnum.Ti.equals(titu) && GeraetEnum.BARREN.equals(value)) {
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
					laufliste.setKey(getKey(lauflistenRepo));
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

	private String getKey(LauflistenRepository lauflistenRepo) {
		Long sequence = lauflistenRepo.getNextSequence();
		incrementKey();
		String key = "%05d".formatted(sequence);
		return key;
	}
}
