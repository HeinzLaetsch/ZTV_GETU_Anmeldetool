package org.ztv.anmeldetool.anmeldetool.transfer;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterBrevetEnum;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class WertungsrichterSlotDTO {
	UUID id;

	int reihenfolge;

	WertungsrichterBrevetEnum brevet;

	LocalDate tag;

	LocalTime start_zeit;
	LocalTime end_zeit;

	String beschreibung;

}
