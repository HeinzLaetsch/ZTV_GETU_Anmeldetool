package org.ztv.anmeldetool.transfer;

import lombok.Getter;

@Getter
public class TeilnahmeStatisticDTO {
	int total;
	int totalStartende;
	int totalZurueckgezogen;
	int startet;
	int neumeldung;
	int abgemeldet;
	int ummeldung;
	int verletzt;
	int nichtGestartet;

	public void incUmmeldung() {
		this.ummeldung++;
		this.totalZurueckgezogen++;
		this.total++;
	}

	public void incVerletzt() {
		this.verletzt++;
		this.totalZurueckgezogen++;
		this.total++;
	}

	public void incNichtGestartet() {
		this.nichtGestartet++;
		this.totalZurueckgezogen++;
		this.total++;
	}

	public void incAbgemeldet() {
		this.abgemeldet++;
		this.totalZurueckgezogen++;
		this.total++;
	}

	public void incStartet() {
		this.startet++;
		this.totalStartende++;
		this.total++;
	}

	public void incNeumeldung() {
		this.neumeldung++;
		this.totalStartende++;
		this.total++;
	}
}
