package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Value;

@Value
@AllArgsConstructor
public class WertungsrichterAnlassLinkDTO {
	UUID id;
	
	UUID anlassId;
	
	UUID personId;
	
	UUID wertungsrichterId;
	
	boolean dirty;
}
