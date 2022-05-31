package org.ztv.anmeldetool.models;

public enum RollenEnum {
	BENUTZER("Basis Rolle", false, true), ADMINISTRATOR("Administrator", false),
	VEREINSVERANTWORTLICHER("Kann den Verein verwalten"), ANMELDER("Darf Wettkämpfe anmelden"),
	WERTUNGSRICHTER("Wertungsrichter"), RECHNUNGSBUERO("Rechnungsbüro", false), SEKRETARIAT("Sekretariat", false);

	private boolean publicAssignable;

	private boolean aktiv;

	private String beschreibung;

	RollenEnum(String beschreibung) {
		this.beschreibung = beschreibung;
		this.aktiv = false;
		this.publicAssignable = true;
	}

	RollenEnum(String beschreibung, boolean publicAssignable) {
		this.beschreibung = beschreibung;
		this.aktiv = false;
		this.publicAssignable = publicAssignable;
	}

	RollenEnum(String beschreibung, boolean publicAssignable, boolean aktiv) {
		this.beschreibung = beschreibung;
		this.aktiv = aktiv;
		this.publicAssignable = publicAssignable;
	}

	public boolean isPublicAssignable() {
		return publicAssignable;
	}

	public boolean isAktiv() {
		return aktiv;
	}

	public String getBeschreibung() {
		return beschreibung;
	}

	public boolean equals(String name) {
		return this.toString().equals(name);
	}
}
