package org.ztv.anmeldetool.models;

public enum WertungsrichterBrevetEnum {
	Brevet_1(1), Brevet_2(2);

	public final int brevet;

  public static WertungsrichterBrevetEnum fromInt(int brevet) {
    return WertungsrichterBrevetEnum.values()[brevet - 1];
  }

	WertungsrichterBrevetEnum(int brevet) {
		this.brevet = brevet;
	}
}
