package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class LauflistenEintragDTO {
	UUID id;
	UUID laufliste_id;
	int startnummer;
	String verein;
	String name;
	String vorname;
	float note_1;
	float note_2;
	UUID tal_id;
	boolean checked;
	boolean error;
}
