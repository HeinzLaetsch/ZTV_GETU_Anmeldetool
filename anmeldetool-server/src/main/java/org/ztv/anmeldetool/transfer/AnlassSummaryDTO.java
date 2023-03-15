package org.ztv.anmeldetool.transfer;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class AnlassSummaryDTO {

	private UUID anlassId;

	private UUID organisationsId;

	private boolean startet;

	private LocalDateTime verlaengerungsDate;

	private int startendeBr1;

	private int startendeBr2;

	private int gemeldeteBr1;

	private int gemeldeteBr2;

	private boolean br1Ok;

	private boolean br2Ok;

}
