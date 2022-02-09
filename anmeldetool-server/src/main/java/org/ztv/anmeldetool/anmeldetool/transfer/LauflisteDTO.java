package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.List;
import java.util.UUID;

import org.ztv.anmeldetool.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.anmeldetool.models.GeraetEnum;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class LauflisteDTO {
	UUID id;

	String laufliste;

	GeraetEnum geraet;

	AbteilungEnum abteilung;

	AnlageEnum anlage;

	private boolean erfasst;

	private boolean checked;

	List<LauflistenEintragDTO> eintraege;
}
