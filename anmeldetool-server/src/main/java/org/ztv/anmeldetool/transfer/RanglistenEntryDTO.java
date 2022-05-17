package org.ztv.anmeldetool.transfer;

import com.opencsv.bean.CsvBindByName;

import lombok.Data;

@Data
public class RanglistenEntryDTO {
	public static final String[] FIELDS_ORDER = { "RANG", "NAME", "VORNAME", "JAHRGANG", "VEREIN", "RECK", "BODEN",
			"RING", "SPRUNG1", "SPRUNG2", "SPRUNG", "BARREN", "TOTAL" };

	@CsvBindByName(column = "Total")
	private float gesamtPunktzahl;
	@CsvBindByName(column = "Reck")
	private float noteReck;
	private int rangReck;
	@CsvBindByName(column = "Boden")
	private float noteBoden;
	private int rangBoden;
	@CsvBindByName(column = "Ring")
	private float noteSchaukelringe;
	private int rangSchaukelringe;
	@CsvBindByName(column = "Sprung1")
	private float noteSprung1;
	@CsvBindByName(column = "Sprung2")
	private float noteSprung2;
	@CsvBindByName(column = "SPRUNG")
	private float noteZaehlbar;
	private int rangSprung;
	@CsvBindByName(column = "Barren")
	private float noteBarren;
	private int rangBarren;
	@CsvBindByName(column = "Rang")
	private int rang;
	private boolean auszeichnung;
	@CsvBindByName(column = "Name")
	private String name;
	@CsvBindByName(column = "Vorname")
	private String vorname;
	@CsvBindByName(column = "Jahrgang")
	private int jahrgang;
	@CsvBindByName(column = "Verein")
	private String verein;

}
