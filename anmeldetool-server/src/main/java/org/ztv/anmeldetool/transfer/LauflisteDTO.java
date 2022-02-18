package org.ztv.anmeldetool.transfer;

import java.util.List;
import java.util.UUID;

import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.GeraetEnum;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class LauflisteDTO {
	private UUID id;

	private String laufliste;

	private GeraetEnum geraet;

	private AbteilungEnum abteilung;

	private AnlageEnum anlage;

	private int abloesung;

	private boolean erfasst;

	private boolean checked;

	private List<LauflistenEintragDTO> eintraege;
}
