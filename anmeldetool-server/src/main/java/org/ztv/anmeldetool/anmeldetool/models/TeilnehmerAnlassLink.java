package org.ztv.anmeldetool.anmeldetool.models;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "teilnehmer_anlass_link")
@Getter
@Setter
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

	private Integer startnummer;

	@Enumerated(EnumType.STRING)
	private AbteilungEnum abteilung;

	private boolean abteilungFix = false;

	@Enumerated(EnumType.STRING)
	private AnlageEnum anlage;

	private boolean anlageFix = false;

	@Enumerated(EnumType.STRING)
	private StartGeraetEnum startgeraet;

	private boolean startgeraetFix = false;
}