package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class OrganisationAnlassLinkDTO {

	UUID anlassId;
	
	UUID organisationsId;
	
	boolean started;
}
