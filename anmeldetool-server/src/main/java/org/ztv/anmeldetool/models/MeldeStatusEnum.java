package org.ztv.anmeldetool.models;

public enum MeldeStatusEnum {
	KEINE_TEILNAHME("Keine Teilnahme"), STARTET("Startet"), STARTET_VERLAENGERT("Startet_Verlaengert"),
	ABGEMELDET("Abgemeldet"), ABGEMELDET_1("Abgemeldet_1"), ABGEMELDET_2("Abgemeldet_2"), ABGEMELDET_3("Abgemeldet_3"),
	ABGEMELDET_4("Abgemeldet_4"), UMMELDUNG("Ummeldung"), NEUMELDUNG("Neumeldung"), VERLETZT("Verletzt"),
	NICHTGESTARTET("Nicht gestartet");

	public final String text;

	private MeldeStatusEnum(String text) {
		this.text = text;
	}

	public boolean startetVorMeldeschluss() {
		return this.equals(MeldeStatusEnum.STARTET) || this.equals(MeldeStatusEnum.NEUMELDUNG)
				|| this.equals(MeldeStatusEnum.ABGEMELDET_2) || this.equals(MeldeStatusEnum.ABGEMELDET_3)
				|| this.equals(MeldeStatusEnum.VERLETZT) || this.equals(MeldeStatusEnum.NICHTGESTARTET);
	}

	public boolean vorWettkampfAbgemeldet() {
		return this.equals(MeldeStatusEnum.ABGEMELDET_2);
	}

	public boolean amWettkampfAbgemeldet() {
		return this.equals(MeldeStatusEnum.ABGEMELDET_3) || this.equals(MeldeStatusEnum.VERLETZT)
				|| this.equals(MeldeStatusEnum.NICHTGESTARTET);
	}

	public static MeldeStatusEnum fromText(String text) {
		for (MeldeStatusEnum mse : MeldeStatusEnum.values()) {
			if (mse.text.equalsIgnoreCase(text)) {
				return mse;
			}
		}
		return MeldeStatusEnum.KEINE_TEILNAHME;
	}
}
