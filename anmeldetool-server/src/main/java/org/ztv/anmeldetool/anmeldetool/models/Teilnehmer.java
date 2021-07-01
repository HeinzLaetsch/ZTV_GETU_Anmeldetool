package org.ztv.anmeldetool.anmeldetool.models;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "TEILNEHMER")
@Getter
@Setter
public class Teilnehmer extends Base {

	private String name;

	private String vorname;

	private int jahrgang;

	private TiTuEnum tiTu;
	
	private boolean dirty;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="ORGANISATION_ID", nullable=false, insertable=true, updatable=true)
    @ToString.Exclude
	private Organisation organisation;

	public Teilnehmer() {
	}


	@Builder
	public Teilnehmer(String name, String vorname, int jahrgang, TiTuEnum tiTu, boolean dirty, Organisation organisation) {
		super();
		this.name = name;
		this.vorname = vorname;
		this.jahrgang = jahrgang;
		this.tiTu = tiTu;
		this.organisation = organisation;
		this.dirty = dirty;
	}
}
