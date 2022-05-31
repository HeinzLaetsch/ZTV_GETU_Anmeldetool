package org.ztv.anmeldetool.models;

public enum MeldeStatusEnum {
	STARTET("Startet"), ABGEMELDET_1("Abgemeldet_1"), ABGEMELDET_2("Abgemeldet_2"), ABGEMELDET_3("Abgemeldet_3"),
	UMMELDUNG("Ummeldung"), NEUMELDUNG("Neumeldung"), VERLETZT("Verletzt"), NICHTGESTARTET("Nicht gestartet");

	public final String text;

	private MeldeStatusEnum(String text) {
		this.text = text;
	}
}
