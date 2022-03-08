package org.ztv.anmeldetool.transfer;

import lombok.Data;

@Data
public class RanglistenEntryDTO {
	private float gesamtPunktzahl;
	private float noteReck;
	private int rangReck;
	private float noteBoden;
	private int rangBoden;
	private float noteSchaukelringe;
	private int rangSchaukelringe;
	private float noteSprung1;
	private float noteSprung2;
	private float noteZaehlbar;
	private int rangSprung;
	private float noteBarren;
	private int rangBarren;
	private int rang;
	private boolean auszeichnung;
	private String name;
	private String vorname;
	private int jahrgang;
	private String verein;

}
