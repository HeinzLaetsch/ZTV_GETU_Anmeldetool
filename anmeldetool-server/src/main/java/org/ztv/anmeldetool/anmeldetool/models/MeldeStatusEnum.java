package org.ztv.anmeldetool.anmeldetool.models;

public enum MeldeStatusEnum {
	STARTET("Startet"), ABGEMELDET("Abgemeldet"), UMMELDUNG("Ummeldung"), NEUMELDUNG("Neumeldung");

	public final String text;

	private MeldeStatusEnum(String text) {
		this.text = text;
	}
}
