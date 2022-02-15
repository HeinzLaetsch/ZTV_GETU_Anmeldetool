package org.ztv.anmeldetool.transfer;

import java.util.UUID;

import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TeilnehmerAnlassLinkCsvDTO {
	UUID anlassId;

	UUID teilnehmerId;

	UUID organisationId;

	private int startnummer;

	private String name;

	private String vorname;

	private int jahrgang;

	private String verein;

	private KategorieEnum kategorie;

	private AbteilungEnum abteilung;

	private AnlageEnum anlage;

	private GeraetEnum startgeraet;
}
