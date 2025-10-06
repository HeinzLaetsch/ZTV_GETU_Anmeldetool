package org.ztv.anmeldetool.models;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "person")
@Getter
@Setter
public class Person extends Base {

	private String benutzername;

	private String name;

	private String vorname;

	private String handy;

	private String email;

	private String password;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "person")
	@ToString.Exclude
	private Set<OrganisationPersonLink> organisationenLinks;

	@OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@JoinColumn(name = "wertungsrichter_id", referencedColumnName = "id")
	private Wertungsrichter wertungsrichter;

	public Person() {
		this.organisationenLinks = new HashSet<OrganisationPersonLink>();
	}

	@Builder
	public Person(UUID id, String benutzername, String name, String vorname, String handy, String email,
			String password) {
		super(id);
		this.benutzername = benutzername;
		this.name = name;
		this.vorname = vorname;
		this.handy = handy;
		this.email = email;
		this.password = password;
		this.organisationenLinks = new HashSet<OrganisationPersonLink>();
	}

	public void addToOrganisationenLink(OrganisationPersonLink organisationenLink) {
		if (!this.organisationenLinks.contains(organisationenLink)) {
			this.organisationenLinks.add(organisationenLink);
			organisationenLink.setPerson(this);
		}
	}
	// Wertungsrichter Info bei WR's
}
