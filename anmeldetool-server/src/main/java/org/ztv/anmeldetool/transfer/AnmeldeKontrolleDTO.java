package org.ztv.anmeldetool.transfer;

import java.util.List;

import lombok.Value;

@Value
public class AnmeldeKontrolleDTO {

	AnlassDTO anlass;

	List<VereinsStartDTO> vereinsStart;

}
