package org.ztv.anmeldetool.anmeldetool.models;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

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

	public int compareTo(Organisation o1) {
		return this.name.compareTo(o1.getName());
	}
}
