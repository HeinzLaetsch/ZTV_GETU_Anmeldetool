package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.Calendar;
import java.util.UUID;

import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterBrevetEnum;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class WertungsrichterDTO {
	private UUID id;
	private UUID personId;
	private WertungsrichterBrevetEnum brevet;
	private boolean gueltig;
	private Calendar letzterFk;
	private boolean aktiv;
}
