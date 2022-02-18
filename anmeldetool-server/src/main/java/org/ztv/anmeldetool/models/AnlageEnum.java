package org.ztv.anmeldetool.models;

public enum AnlageEnum {
	ANLAGE_1, ANLAGE_2, ANLAGE_3, ANLAGE_4, UNDEFINED;

	/*
	 * @JsonCreator public static AnlageEnum decode(final String code) { return
	 * Stream.of(AnlageEnum.values()).filter(targetEnum ->
	 * targetEnum.code.equals(code)).findFirst() .orElse(null); }
	 */
}
