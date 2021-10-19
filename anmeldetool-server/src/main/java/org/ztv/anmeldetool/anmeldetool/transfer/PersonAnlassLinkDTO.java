package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Value;

@Value
@AllArgsConstructor
public class PersonAnlassLinkDTO {
	
	UUID anlassId;
	
	UUID personId;
	
	boolean dirty;
}
