package org.ztv.anmeldetool.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "person_anlass_link")
@Getter
@Setter
public class PersonAnlassLink extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PERSON_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Person person;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANLASS_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Anlass anlass;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORGANISATION_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Organisation organisation;

	private String kommentar;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "personAnlassLink", cascade = { CascadeType.PERSIST,
			CascadeType.MERGE })
	@ToString.Exclude
	private List<WertungsrichterEinsatz> einsaetze;
}