package org.ztv.anmeldetool.anmeldetool.models;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "ANLASS")
@Getter
@Setter
public class Anlass extends Base {

	private String anlassBezeichnung;

	private String ort;

	private String halle;

	private String organisator;

	private LocalDateTime startDate;

	private LocalDateTime endDate;

	// Anmeldung ist eröffnet, es kann alles erfasst werden
	private LocalDateTime anmeldungBeginn;

	// Neu Erfassen nicht mehr erlaubt
	private LocalDateTime erfassenGeschlossen;

	// Cross Kategorie Aenderungen nicht mehr erlaubt
	private LocalDateTime crossKategorieAenderungenGeschlossen;

	// Aenderungen innerhalb Kategorie nicht mehr erlaubt.
	private LocalDateTime aenderungenInKategorieGeschlossen;

	// Kurz vor Wettkampf, keine Mutationen mehr erlaubt
	private LocalDateTime aenderungenNichtMehrErlaubt;

	private boolean published;

	@Enumerated(EnumType.STRING)
	private TiTuEnum tiTu;

	@Enumerated(EnumType.STRING)
	private KategorieEnum tiefsteKategorie;

	@Enumerated(EnumType.STRING)
	private KategorieEnum hoechsteKategorie;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "anlass", cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@ToString.Exclude
	private List<OrganisationAnlassLink> organisationenLinks;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "anlass", cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@ToString.Exclude
	private List<WertungsrichterSlot> wertungsrichterSlots;

	public Anlass() {
		this.organisationenLinks = new ArrayList<OrganisationAnlassLink>();
		this.wertungsrichterSlots = new ArrayList<WertungsrichterSlot>();
	}

	@Builder
	public Anlass(String anlassBezeichnung, String ort, String halle, LocalDateTime startDate, LocalDateTime endDate,
			TiTuEnum tiTu, KategorieEnum tiefsteKategorie, KategorieEnum hoechsteKategorie) {
		super();
		this.anlassBezeichnung = anlassBezeichnung;
		this.ort = ort;
		this.halle = halle;
		this.startDate = startDate;
		this.endDate = endDate;
		this.tiTu = tiTu;
		this.tiefsteKategorie = tiefsteKategorie;
		this.hoechsteKategorie = hoechsteKategorie;
		this.organisationenLinks = new ArrayList<OrganisationAnlassLink>();
		this.wertungsrichterSlots = new ArrayList<WertungsrichterSlot>();
	}

	public void addToOrganisationenLink(OrganisationAnlassLink organisationenLink) {
		if (!this.organisationenLinks.contains(organisationenLink)) {
			this.organisationenLinks.add(organisationenLink);
			organisationenLink.setAnlass(this);
		}
	}
	// Wertungsrichter Info bei WR's
}
