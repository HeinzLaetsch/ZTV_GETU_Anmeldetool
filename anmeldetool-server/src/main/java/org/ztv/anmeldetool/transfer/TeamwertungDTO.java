package org.ztv.anmeldetool.transfer;

import java.math.BigDecimal;

import lombok.Data;

@Data
public class TeamwertungDTO {
	private BigDecimal gesamtPunktzahl;
	private int rang;
	private String verein;
	private int anzahlResultate;

	@Override
	public int hashCode() {
		return verein.hashCode();
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null)
			return false;
		if (this.getClass() != o.getClass())
			return false;
		TeamwertungDTO teamwertung = (TeamwertungDTO) o;
		return verein.equals(teamwertung.verein);
	}
}
