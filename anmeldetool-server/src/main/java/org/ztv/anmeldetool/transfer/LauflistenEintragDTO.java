package org.ztv.anmeldetool.transfer;

import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class LauflistenEintragDTO {
	UUID id;
	UUID laufliste_id;
	int startnummer;
	int startOrder;
	String verein;
	String name;
	String vorname;
	float note_1;
	float note_2;
	UUID tal_id;
	boolean checked;
	boolean erfasst;
	boolean deleted;
}
