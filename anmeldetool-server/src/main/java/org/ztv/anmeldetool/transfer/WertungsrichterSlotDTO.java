package org.ztv.anmeldetool.transfer;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class WertungsrichterSlotDTO {
	UUID id;

	int reihenfolge;

	int brevet;

	LocalDate tag;

	LocalTime start_zeit;
	LocalTime end_zeit;

	String beschreibung;

	boolean egalSlot;

	@Builder
	private static WertungsrichterSlotDTO create(
			UUID id,
			int reihenfolge,
			int brevet,
			LocalDate tag,
			LocalTime start_zeit,
			LocalTime end_zeit,
			String beschreibung,
			boolean egalSlot) {
		WertungsrichterSlotDTO dto = new WertungsrichterSlotDTO();
		dto.id = id;
		dto.reihenfolge = reihenfolge;
		dto.brevet = brevet;
		dto.tag = tag;
		dto.start_zeit = start_zeit;
		dto.end_zeit = end_zeit;
		dto.beschreibung = beschreibung;
		dto.egalSlot = egalSlot;
		return dto;
	}
}
