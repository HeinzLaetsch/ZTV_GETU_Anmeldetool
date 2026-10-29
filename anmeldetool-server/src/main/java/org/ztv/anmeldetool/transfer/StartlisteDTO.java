package org.ztv.anmeldetool.transfer;

import java.util.List;

import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;

public record StartlisteDTO(String anlassBezeichnung, String ort, List<Section> sections) {

  public record Section(KategorieEnum kategorie, TiTuEnum tiTu, List<Abteilung> abteilungen) {
  }

  /** {@code abteilung} is {@code null} when participants are not yet assigned to an Abteilung. */
  public record Abteilung(AbteilungEnum abteilung, List<VereinStarter> vereine) {
  }

  public record VereinStarter(String verein, long anzahl) {
  }
}
