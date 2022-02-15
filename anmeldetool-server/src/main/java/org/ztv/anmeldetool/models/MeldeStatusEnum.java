package org.ztv.anmeldetool.models;

public enum MeldeStatusEnum {
	STARTET("Startet"), ABGEMELDET("Abgemeldet"), UMMELDUNG("Ummeldung"), NEUMELDUNG("Neumeldung"),
	VERLETZT("Verletzt"), NICHTGESTARTET("Nicht gestartet");

	public final String text;

	private MeldeStatusEnum(String text) {
		this.text = text;
	}
}
