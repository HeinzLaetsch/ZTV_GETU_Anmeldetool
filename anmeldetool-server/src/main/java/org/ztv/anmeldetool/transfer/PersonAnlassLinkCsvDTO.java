package org.ztv.anmeldetool.transfer;

import java.util.List;

import org.ztv.anmeldetool.util.WertungsrichterToCsv;

import com.opencsv.bean.CsvBindAndSplitByName;
import com.opencsv.bean.CsvBindByName;
import com.opencsv.bean.CsvIgnore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PersonAnlassLinkCsvDTO {

	public static final String[] FIELDS_ORDER = { "NAME", "VORNAME", "HANDY", "EMAIL", "VEREIN", "KOMMENTAR",
			"WRMELDUNGEN" };

	// @CsvBindByName(column = "Benutzername", required = true)
	@CsvIgnore
	private String benutzername;

	@CsvBindByName(column = "Name", required = true)
	private String name;

	@CsvBindByName(column = "Vorname", required = true)
	private String vorname;
	@CsvBindByName(column = "Handy", required = true)
	private String handy;
	@CsvBindByName(column = "EMail", required = true)
	private String email;

	@CsvBindByName(column = "Verein", required = true)
	private String verein;

	@CsvBindByName(column = "Kommentar", required = false)
	private String kommentar;

	@CsvBindByName(column = "WRMeldungen")
	@CsvBindAndSplitByName(elementType = WertungsrichterEinsatzCsvDTO.class, splitOn = ";+", writeDelimiter = ";", converter = WertungsrichterToCsv.class)
	private List<WertungsrichterEinsatzCsvDTO> wrMeldungen;
}
