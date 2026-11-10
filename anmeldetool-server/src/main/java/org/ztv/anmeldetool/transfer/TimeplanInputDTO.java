package org.ztv.anmeldetool.transfer;

import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;

/** Maxima for one Kategorie and Turnerinnen/Turner used to calculate a Timeplan proposal. */
public record TimeplanInputDTO(KategorieEnum kategorie, TiTuEnum tiTu, int maxAnlagen, int maxAbteilungen) {
}
