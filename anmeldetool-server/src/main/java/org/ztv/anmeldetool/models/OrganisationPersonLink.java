package org.ztv.anmeldetool.models;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "organisation_person_link")
@Getter
@Setter
@AllArgsConstructor
public class OrganisationPersonLink extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORGANISATION_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Organisation organisation;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PERSON_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Person person;

	// Rolle über Enum
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "link")
	@ToString.Exclude
	private Set<RollenLink> rollenLink;

  @Builder
	public OrganisationPersonLink() {
		this.rollenLink = new HashSet<>();
	}
  public OrganisationPersonLink(Organisation organisation, Person person) {
    this.organisation = organisation;
    this.person = person;
    this.rollenLink = new HashSet<>();
  }
}
