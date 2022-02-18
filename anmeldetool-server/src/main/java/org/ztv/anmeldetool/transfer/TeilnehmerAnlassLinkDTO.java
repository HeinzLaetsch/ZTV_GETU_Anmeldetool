package org.ztv.anmeldetool.transfer;

import java.util.UUID;

import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;

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

	private GeraetEnum startgeraet;

	private boolean startgeraetFix;

}
