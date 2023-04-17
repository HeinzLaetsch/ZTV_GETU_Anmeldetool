package org.ztv.anmeldetool.transfer;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TeilnehmerCsvContestDTO {

	private String geloescht;

	private String vereinsname;

	private String kategorie;

	private String sparte;

	private String vorname;

	private String nachname;

	private String geschlecht;

	private int geburtsjahr;

	public String cleanName() {
		int start = 0;
		int endKorrektur = 0;
		if (vereinsname.contains("Zürich")) {
			start = "Zürich".length() + 1;
		}
		if (vereinsname.toUpperCase().contains("TV")) {
			endKorrektur = "TV".length() + 1;
		}
		if (vereinsname.contains("TV STV")) {
			endKorrektur = "TV STV".length() + 1;
		}
		if (vereinsname.contains("DTV")) {
			endKorrektur = "DTV".length() + 1;
		}
		if (vereinsname.toUpperCase().contains("DTV STV")) {
			endKorrektur = "DTV STV".length() + 1;
		}
		if (vereinsname.contains("DTV/STV")) {
			endKorrektur = "DTV/STV".length() + 1;
		}
		if (vereinsname.contains("Turnverein")) {
			endKorrektur = "Turnverein".length() + 1;
		}
		if (vereinsname.toUpperCase().contains("DR STV")) {
			endKorrektur = "DR STV".length() + 1;
		}
		if (vereinsname.contains("ZH")) {
			endKorrektur = "ZH".length() + 1;
		}
		if (vereinsname.contains("STV ZH")) {
			endKorrektur = "STV ZH".length() + 1;
		}
		return vereinsname.substring(start, vereinsname.length() - endKorrektur);
	}
}
