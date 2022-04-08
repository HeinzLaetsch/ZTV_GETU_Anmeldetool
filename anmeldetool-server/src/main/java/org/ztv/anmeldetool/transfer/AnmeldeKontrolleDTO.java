package org.ztv.anmeldetool.transfer;

import java.util.List;

import lombok.Value;

@Value
public class AnmeldeKontrolleDTO {

	AnlassDTO anlass;

	List<VereinsStartDTO> vereinsStart;

	OrganisationDTO organisator;

	public String getDetailAnlassName() {
		StringBuilder sb = new StringBuilder();
		sb.append(anlass.getAnlassBezeichnung().replace("%", ""));
		sb.append(" in ");
		sb.append(anlass.getOrt());
		return sb.toString();
	}

}
