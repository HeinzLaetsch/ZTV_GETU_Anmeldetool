package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class OrganisationDTO {

	private UUID id;

	private String name;

	private UUID verbandId;

}
