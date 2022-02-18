package org.ztv.anmeldetool.transfer;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class OrganisationAnlassLinkDTO {

	UUID anlassId;

	UUID organisationsId;

	boolean startet;

	private LocalDateTime verlaengerungsDate;

}
