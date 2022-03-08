package org.ztv.anmeldetool.models;

public enum TiTuEnum {
	Ti("Turnerin"), Tu("Turner"), Alle("Gemeinsamer Wettkampf");

	private String beschreibung;

	TiTuEnum(String beschreibung) {
		this.beschreibung = beschreibung;
	}

	public String getBeschreibung() {
		return beschreibung;
	}

	public boolean equals(String name) {
		return this.toString().equals(name);
	}

	public boolean isTurner() {
		return TiTuEnum.Alle.equals(this) || TiTuEnum.Tu.equals(this);
	}
}
