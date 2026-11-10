package org.ztv.anmeldetool.transfer;

import java.util.List;

import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;

/**
 * Timeplan proposal for one Kategorie and Turnerinnen/Turner.
 *
 * @param maxAnlagen          maximum number of Anlagen that may be used (input)
 * @param maxAbteilungen      maximum number of Abteilungen that may be used (input)
 * @param anzahlTeilnehmer    Teilnehmer count the proposal was calculated with
 * @param aktuelleTeilnehmer  current Teilnehmer count; differs from {@code anzahlTeilnehmer} if the proposal is stale
 * @param gruppenProAnlage    maximum number of Gruppen per Anlage and Abteilung (at most one per Gerät)
 * @param gespeichert         whether the proposal is persisted
 */
public record TimeplanVorschlagDTO(KategorieEnum kategorie, TiTuEnum tiTu, int maxAnlagen, int maxAbteilungen,
    int anzahlTeilnehmer, int aktuelleTeilnehmer, int anzahlGruppen, int gruppenGroesseMin, int gruppenGroesseMax,
    int anzahlAnlagen, int anzahlAbteilungen, int gruppenProAnlage, List<GeraetEnum> geraete, boolean gespeichert) {
}
