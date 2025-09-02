package org.ztv.anmeldetool.models;

import java.util.Calendar;

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Entity()
@Table(name = "Wertungsrichter")
@Getter
@Setter
public class Wertungsrichter extends Base {

	@OneToOne()
	@JoinColumn(name = "person_id", referencedColumnName = "id")
	Person person;

	private WertungsrichterBrevetEnum brevet;

	private boolean gueltig;

	@Temporal(TemporalType.DATE)
	private Calendar letzterFk;

	public Wertungsrichter() {
	}

	@Builder
	public Wertungsrichter(Person person, WertungsrichterBrevetEnum brevet, Calendar letzterFk) {
		this.person = person;
		this.brevet = brevet;
		this.letzterFk = letzterFk;
	}
}
