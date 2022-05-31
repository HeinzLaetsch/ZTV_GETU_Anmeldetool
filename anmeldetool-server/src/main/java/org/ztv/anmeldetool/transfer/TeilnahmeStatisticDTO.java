package org.ztv.anmeldetool.transfer;

import lombok.Getter;

@Getter
public class TeilnahmeStatisticDTO {
	int total;
	int totalStartende;
	int totalZurueckgezogen;
	int startet;
	int neumeldung;
	int abgemeldet_1;
	int abgemeldet_2;
	int abgemeldet_3;
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

	public void incAbgemeldet_1() {
		this.abgemeldet_1++;
		this.totalZurueckgezogen++;
		this.total++;
	}

	public void incAbgemeldet_2() {
		this.abgemeldet_2++;
		this.totalZurueckgezogen++;
		this.total++;
	}

	public void incAbgemeldet_3() {
		this.abgemeldet_2++;
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
