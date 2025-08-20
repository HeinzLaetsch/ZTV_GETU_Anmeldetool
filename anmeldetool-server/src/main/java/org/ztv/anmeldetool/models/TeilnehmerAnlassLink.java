package org.ztv.anmeldetool.models;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.AccessLevel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "teilnehmer_anlass_link")
@Getter
@Setter
@EqualsAndHashCode
public class TeilnehmerAnlassLink extends Base {

	@Enumerated(EnumType.STRING)
	private KategorieEnum kategorie;

	@Enumerated(EnumType.STRING)
	private MeldeStatusEnum meldeStatus;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TEILNEHMER_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Teilnehmer teilnehmer;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANLASS_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Anlass anlass;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORGANISATION_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Organisation organisation;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@JoinColumn(name = "LAUFLISTEN_CONTAINER_ID", nullable = true, insertable = true, updatable = true)
	@ToString.Exclude
	private LauflistenContainer lauflistenContainer;

	@OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@JoinColumn(name = "notenblatt_id", referencedColumnName = "id", nullable = true, insertable = true, updatable = true)
	@ToString.Exclude
	@Getter(value = AccessLevel.NONE)
	private Notenblatt notenblatt;

	public Notenblatt getNotenblatt() {
		/*
		 * if (this.notenblatt == null) { return new Notenblatt(); }
		 */
		return notenblatt;
	}

	private Integer startnummer;

	@Enumerated(EnumType.STRING)
	private AbteilungEnum abteilung;

	@Enumerated(EnumType.STRING)
	private AnlageEnum anlage;

	@Enumerated(EnumType.STRING)
	private GeraetEnum startgeraet;

	public static int compareByTiTuThenVereinThenName(TeilnehmerAnlassLink tal1, TeilnehmerAnlassLink tal2) {
		if (tal1.getTeilnehmer().getTiTu().equals(tal2.getTeilnehmer().getTiTu())) {
			if (tal1.getOrganisation().getName().equals(tal2.getOrganisation().getName())) {
				if (tal1.getTeilnehmer().getName().equals(tal2.getTeilnehmer().getName())) {
					return tal1.getTeilnehmer().getVorname().compareTo(tal2.getTeilnehmer().getVorname());
				} else {
					return tal1.getTeilnehmer().getName().compareTo(tal2.getTeilnehmer().getName());
				}
			}
			return tal1.getOrganisation().getName().compareTo(tal2.getOrganisation().getName());
		} else {
			return tal1.getTeilnehmer().getTiTu().compareTo(tal2.getTeilnehmer().getTiTu());
		}
	}
}