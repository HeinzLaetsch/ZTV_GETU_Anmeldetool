package org.ztv.anmeldetool.anmeldetool.models;

import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Entity()
@Table(name = "ROLLE")
@Getter
@Setter
public class Rolle extends Base {

	private String name;

	private String beschreibung;

	private boolean publicAssignable;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "rolle")
	private Set<RollenLink> rollenLink;

	public Rolle() {
		super();
	}

	@Builder
	public Rolle(String name, String beschreibung) {
		super();
		this.name = name;
		this.beschreibung = beschreibung;
	}

	public Rolle(RollenEnum rollenEnum) {
		super();
		this.name = rollenEnum.toString();
		this.beschreibung = rollenEnum.getBeschreibung();
		this.publicAssignable = rollenEnum.isPublicAssignable();
	}
}
