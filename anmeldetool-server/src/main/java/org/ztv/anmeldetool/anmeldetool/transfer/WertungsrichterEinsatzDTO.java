package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class WertungsrichterEinsatzDTO {

	private UUID id;

	private UUID personAnlassLinkId;

	private UUID wertungsrichterSlotId;

	private boolean eingesetzt;
}
