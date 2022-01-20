package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import org.ztv.anmeldetool.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.StartGeraetEnum;

import lombok.AllArgsConstructor;
import lombok.Value;

@Value
@AllArgsConstructor
public class TeilnehmerAnlassLinkDTO {
	UUID anlassId;

	UUID teilnehmerId;

	UUID organisationId;

	KategorieEnum kategorie;

	boolean dirty;

	private int startnummer;

	private AbteilungEnum abteilung;

	private AnlageEnum anlage;

	private StartGeraetEnum startgeraet;
}
