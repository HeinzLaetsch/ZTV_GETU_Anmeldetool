package org.ztv.anmeldetool.models;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import org.hibernate.annotations.SQLDelete;

import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "TEILNEHMER")
@SQLDelete(sql = "UPDATE teilnehmer SET deleted = true WHERE id=?")
// @Where(clause = "deleted=false") // Deleted Teilnehmer nicht mehr zugreifbar, Alternative mit Filter
@Getter
@Setter
@EqualsAndHashCode
public class Teilnehmer extends Base {

	private String name;

	private String vorname;

	private String stvNummer;

	private int jahrgang;

	@Enumerated(EnumType.STRING)
	private TiTuEnum tiTu;

	private boolean dirty;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORGANISATION_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Organisation organisation;

	public Teilnehmer() {
	}

	@Builder
	public Teilnehmer(String name, String vorname, int jahrgang, String stvNummer, TiTuEnum tiTu, boolean dirty,
			Organisation organisation) {
		super();
		this.name = name;
		this.vorname = vorname;
		this.jahrgang = jahrgang;
		this.stvNummer = stvNummer;
		this.tiTu = tiTu;
		this.organisation = organisation;
		this.dirty = dirty;
	}
}
