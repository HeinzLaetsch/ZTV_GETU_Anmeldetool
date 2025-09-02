package org.ztv.anmeldetool.models;

import java.time.LocalDate;
import java.time.LocalTime;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "WERTUNGSRICHTER_SLOT")
@Getter
@Setter
public class WertungsrichterSlot extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANLASS_ID" + "", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Anlass anlass;

	int reihenfolge;

	WertungsrichterBrevetEnum brevet;

	LocalDate tag;

	LocalTime start_zeit;
	LocalTime end_zeit;

	String beschreibung;

	boolean egalSlot;
}
