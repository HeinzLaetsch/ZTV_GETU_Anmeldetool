package org.ztv.anmeldetool.transfer;

import lombok.Data;

@Data
public class RanglistenEntryDTO {
	private float gesamtPunktzahl;
	private float noteReck;
	private float noteBoden;
	private float noteSchaukelringe;
	private float noteSprung1;
	private float noteSprung2;
	private float noteZaehlbar;
	private float noteBarren;
	private int rang;
	private boolean auszeichnung;
	private String name;
	private String vorname;
	private int jahrgang;
	private String verein;

}
