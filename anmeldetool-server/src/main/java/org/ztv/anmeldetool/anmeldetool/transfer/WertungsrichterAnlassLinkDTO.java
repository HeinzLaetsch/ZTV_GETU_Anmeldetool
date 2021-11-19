package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class WertungsrichterAnlassLinkDTO {
	UUID id;

	UUID anlassId;

	UUID wertungsrichterId;

	UUID personId;

	String kommentar;

	private List<WertungsrichterSlotDTO> slots;
}
