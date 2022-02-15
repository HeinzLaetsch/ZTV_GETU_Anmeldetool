package org.ztv.anmeldetool.models;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "PERSON")
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
	public Person(String benutzername, String name, String vorname, String handy, String email, String password) {
		super();
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
