package org.ztv.anmeldetool.anmeldetool.transfer;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
// import lombok.Value;

@Setter
@Getter
@Builder
public class RolleDTO {
	String id;
	
	String name;
	
	String beschreibung;
	
	boolean aktiv;
}
