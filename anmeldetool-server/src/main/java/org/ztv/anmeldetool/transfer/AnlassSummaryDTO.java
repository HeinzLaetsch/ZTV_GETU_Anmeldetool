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

	private int startendeK1;
	private int startendeK2;
	private int startendeK3;
	private int startendeK4;
	private int startendeK5;
	private int startendeK5A;
	private int startendeK5B;
	private int startendeK6;
	private int startendeK7;
	private int startendeKD;
	private int startendeKH;

	private int startendeBr2;

	private int gemeldeteBr1;

	private int gemeldeteBr2;

	private boolean br1Ok;

	private boolean br2Ok;

}
