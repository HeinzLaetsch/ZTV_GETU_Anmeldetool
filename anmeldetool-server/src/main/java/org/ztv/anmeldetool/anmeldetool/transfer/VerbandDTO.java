package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class VerbandDTO {

	UUID id;
	
	String verband;
	
	String verband_long;
}
