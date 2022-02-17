package org.ztv.anmeldetool.transfer;

import java.util.UUID;

import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;

import lombok.Data;

@Data
public class RanglisteConfigurationDTO {
	private UUID id;

	private UUID anlassId;

	private KategorieEnum kategorie;

	private TiTuEnum tiTu;

	private int maxAuszeichnungen;
}
