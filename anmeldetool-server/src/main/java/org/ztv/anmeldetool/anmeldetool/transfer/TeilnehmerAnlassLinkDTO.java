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
	private UUID anlassId;

	private UUID teilnehmerId;

	private UUID organisationId;

	private KategorieEnum kategorie;

	private String meldeStatus;

	private boolean dirty;

	private int startnummer;

	private AbteilungEnum abteilung;

	private boolean abteilungFix;

	private AnlageEnum anlage;

	private boolean anlageFix;

	private StartGeraetEnum startgeraet;

	private boolean startgeraetFix;

}
