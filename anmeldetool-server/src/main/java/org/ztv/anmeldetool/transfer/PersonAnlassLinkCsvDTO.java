package org.ztv.anmeldetool.transfer;

import java.util.List;

import org.ztv.anmeldetool.util.WertungsrichterToCsv;

import com.opencsv.bean.CsvBindAndSplitByName;
import com.opencsv.bean.CsvBindByName;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PersonAnlassLinkCsvDTO {

	@CsvBindByName
	private String benutzername;

	@CsvBindByName
	private String name;

	@CsvBindByName
	private String vorname;
	@CsvBindByName
	private String handy;
	@CsvBindByName
	private String email;

	@CsvBindByName
	private String verein;

	@CsvBindByName
	private String kommentar;

	@CsvBindByName(column = "WR Meldungen")
	@CsvBindAndSplitByName(elementType = WertungsrichterEinsatzCsvDTO.class, splitOn = ";+", writeDelimiter = ";", converter = WertungsrichterToCsv.class)
	private List<WertungsrichterEinsatzCsvDTO> wrMeldungen;
}
