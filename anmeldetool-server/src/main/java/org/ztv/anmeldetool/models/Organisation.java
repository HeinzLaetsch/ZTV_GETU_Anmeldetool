package org.ztv.anmeldetool.models;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "ORGANISATION")
@Getter
@Setter
public class Organisation extends Base {

	private String name;

	private String bezeichnung;

	@Transient
	private String cleanName = null;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "VERBAND_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Verband verband;

	// Personen sind über Linkliste mit Rolle zugeordnet
	// n:m Relation
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "organisation", cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@ToString.Exclude
	private final Set<OrganisationPersonLink> personenLinks;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "organisator", cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@ToString.Exclude
	private List<Anlass> organisierteAnlaesse;

	public Organisation() {
		this.personenLinks = new HashSet<OrganisationPersonLink>();
	}

	@Builder
	public Organisation(String name, Verband verband) {
		super(true);
		this.name = name;
		this.verband = verband;
		this.personenLinks = new HashSet<OrganisationPersonLink>();
	}

	public void addToPersonenLink(OrganisationPersonLink personenLink) {
		if (!this.personenLinks.contains(personenLink)) {
			this.personenLinks.add(personenLink);
			personenLink.setOrganisation(this);
		}
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		}

		if ((obj == null) /* || (obj.getClass() != this.getClass()) */) {
			return false;
		}

		Organisation org = (Organisation) obj;
		if (org.getName().equals(name)) {
			return true;
		}
		return false;
	}

	public int compareTo(Organisation o1) {
		return this.name.compareTo(o1.getName());
	}

	public String cleanName() {
		return cleanName(true);
	}

	public String cleanName(boolean korrigiereEnde) {
		if (!korrigiereEnde && cleanName != null) {
			return cleanName;
		}
		int start = 0;
		int endKorrektur = 0;
		if (name.contains("GR")) {
			start = "GR".length() + 1;
		}
		if (name.contains("GETU")) {
			start = "GETU".length() + 1;
		}
		if (name.contains("Getu")) {
			start = "Getu".length() + 1;
		}
		if (!name.toUpperCase().contains("ZTV") && name.toUpperCase().contains("TV")) {
			start = "TV".length() + 1;
		}
		if (name.contains("Getu TV")) {
			start = "Getu TV".length() + 1;
		}
		// Bindestrich durch +1 removed
		if (name.toUpperCase().contains("TV ZH")) {
			start = "TV ZH".length() + 1;
		}
		if (name.contains("TV Zürich")) {
			start = "TV Zürich".length() + 1;
		}
		if (name.toUpperCase().contains("TG")) {
			start = "TG".length() + 1;
		}
		if (name.contains("Geräteriege")) {
			start = "Geräteriege".length() + 1;
		}
		if (name.contains("Geräteturnen")) {
			start = "Geräteturnen".length() + 1;
		}
		if (name.contains("Turnverein")) {
			start = "Turnverein".length() + 1;
		}
		if (name.toUpperCase().contains("DTV")) {
			start = "DTV".length() + 1;
		}
		if (name.contains("Turnsport")) {
			start = "Turnsport".length() + 1;
		}
		if (name.toUpperCase().contains("TSV")) {
			start = "TSV".length() + 1;
		}
		if (name.toUpperCase().contains("SATUS")) {
			start = "SATUS".length() + 1;
		}
		if (korrigiereEnde) {
			if (name.contains("Mädchen")) {
				endKorrektur = "Mädchen".length() + 1;
			}
			if (name.contains("GeTu")) {
				endKorrektur = "GeTu".length() + 1;
			}
			if (name.contains("OTVG")) {
				endKorrektur = "OTVG".length() + 1;
			}
			if (name.endsWith("ZH")) {
				endKorrektur = "ZH".length() + 1;
			}
		}
		cleanName = name.substring(start, name.length() - endKorrektur);

		// System.out.println("Name: " + name + " Clean: " + cleanName);
		return cleanName;
	}
}
