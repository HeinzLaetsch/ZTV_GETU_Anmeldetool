package org.ztv.anmeldetool.models;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

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

	private LocalDate letzterFk;

	public Wertungsrichter() {
	}

	@Builder
	public Wertungsrichter(Person person, WertungsrichterBrevetEnum brevet, LocalDate letzterFk) {
		this.person = person;
		this.brevet = brevet;
		this.letzterFk = letzterFk;
	}
}
