package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Value;

@Value
@AllArgsConstructor
public class TeilnehmerAnlassLinkDTO {
	UUID anlassId;
	
	UUID teilnehmerId;
	
	String kategorie;
	
	boolean dirty;
}
