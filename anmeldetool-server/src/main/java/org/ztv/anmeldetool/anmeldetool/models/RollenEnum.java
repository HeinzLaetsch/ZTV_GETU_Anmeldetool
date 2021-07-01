package org.ztv.anmeldetool.anmeldetool.models;

public enum RollenEnum {
	BENUTZER("Basis Rolle"),
	ADMINISTRATOR("Administrator"),
	VEREINSVERANTWORTLICHER("Kann den Verein verwalten"),
	ANMELDER("Darf Wettkämpfe anmelden"),
	WERTUNGSRICHTER("Wertungsrichter");
	
	private String beschreibung;
	RollenEnum(String beschreibung) {
		this.beschreibung = beschreibung;
	}
	
	public String getBeschreibung() {
		return beschreibung;
	}
	
	public boolean equals(String name) {
		return this.toString().equals(name);
	}
}
