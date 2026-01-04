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

  //ToDo wieso String und nicht MeldeStatusEnum?
	private String meldeStatus;

  //ignored fields for partial updates
	private boolean dirty;

	private int startnummer;

	private AbteilungEnum abteilung;

  // Ignored fields for partial updates
	private boolean abteilungFix;

	private AnlageEnum anlage;

	// Ignored fields for partial updates
  private boolean anlageFix;

	private GeraetEnum startgeraet;

	// Ignored fields for partial updates
  private boolean startgeraetFix;
// fehlt TiTuEnum tiTu;
}
