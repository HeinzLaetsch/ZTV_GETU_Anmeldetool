package org.ztv.anmeldetool.transfer;

import com.opencsv.bean.CsvBindByName;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BenutzerDTO {

	public static final String[] FIELDS_ORDER = { "NAME", "VORNAME", "HANDY", "EMAIL", "VEREIN", "VERANTWORTLICHER",
			"ANMELDER", "BENUTZERNAME" };

	@CsvBindByName(column = "Benutzername", required = true)
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

	@CsvBindByName(column = "Verantwortlicher", required = true)
	private boolean isVerantwortlicher;

	@CsvBindByName(column = "Anmelder", required = true)
	private boolean isAnmelder;
}
