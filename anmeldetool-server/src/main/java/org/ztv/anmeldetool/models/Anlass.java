package org.ztv.anmeldetool.models;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import org.ztv.anmeldetool.util.KategorienSponsorenAttributeConverter;

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

	// TODO replace private String organisator;
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORGANISATOR_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Organisation organisator;

	private String ranglistenFooter;

	private String iban;

	private String zuGunsten;

	private String bank;

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

	private boolean publishedSent;

	private boolean reminderMeldeschlussSent;

	private boolean smQuali;

	private boolean ausserkantonal;

	/*
	 * @Column(name = "sieger_total_k5") private float siegerTotalK5;
	 * 
	 * @Column(name = "sieger_total_k6") private float siegerTotalK6;
	 * 
	 * @Column(name = "sieger_total_kh") private float siegerTotalKH;
	 * 
	 * @Column(name = "sieger_total_k7") private float siegerTotalK7;
	 */
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

	private boolean startgeraetFix = false;
	private boolean abteilungFix = false;
	private boolean anlageFix = false;
	private boolean toolSperren = false;

	@Convert(converter = KategorienSponsorenAttributeConverter.class)
	@Column(name = "KATEGORIEN_SPONSOREN", length = 1000)
	private KategorienSponsoren kategorieSponsoren;

	@OneToMany(fetch = FetchType.EAGER, mappedBy = "anlass")
	@ToString.Exclude
	private List<RanglisteConfiguration> ranglisteConfigurationen;

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
