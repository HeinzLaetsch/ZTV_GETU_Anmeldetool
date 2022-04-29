package org.ztv.anmeldetool.transfer;

import java.util.UUID;

import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.TiTuEnum;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class TeilnehmerStartDTO implements Comparable<TeilnehmerStartDTO> {
	private UUID id;
	private String name;
	private String vorname;
	private TiTuEnum tiTu;
	private String verein;
	private KategorieEnum kategorie;
	private AbteilungEnum abteilung;
	private AnlageEnum anlage;
	private GeraetEnum startgeraet;
	private MeldeStatusEnum meldeStatus;

	@Override
	public int compareTo(TeilnehmerStartDTO arg0) {
		if (this.verein.compareTo(arg0.getVerein()) == 0) {
			return this.name.compareTo(arg0.getName());
		}
		return this.verein.compareTo(arg0.getVerein());
	}

	@Override
	public boolean equals(Object arg0) {
		return ((TeilnehmerStartDTO) arg0).getId().equals(getId());
	}
}
