package org.ztv.anmeldetool.transfer;

import java.time.LocalDate;
import java.time.LocalTime;

import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;

import com.opencsv.bean.CsvBindByName;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WertungsrichterEinsatzCsvDTO {

	@CsvBindByName(column = "Eingesetzt")
	private boolean eingesetzt;

	@CsvBindByName(column = "Brevet")
	private WertungsrichterBrevetEnum brevet;

	@CsvBindByName(column = "Einsatztag")
	private LocalDate tag;

	@CsvBindByName(column = "Beginn")
	private LocalTime start_zeit;

	@CsvBindByName(column = "Ende")
	private LocalTime end_zeit;

	@CsvBindByName(column = "Beschreibung")
	String beschreibung;
}
