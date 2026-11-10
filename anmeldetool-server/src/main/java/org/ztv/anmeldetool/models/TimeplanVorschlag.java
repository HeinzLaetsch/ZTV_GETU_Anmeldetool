package org.ztv.anmeldetool.models;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * Persisted Timeplan proposal for one Kategorie and Turnerinnen/Turner of an Anlass: the maxima entered by the user
 * and the calculated number of Gruppen, Anlagen and Abteilungen.
 */
@Entity
@Table(name = "TIMEPLAN_VORSCHLAG")
@NoArgsConstructor
@Getter
@Setter
public class TimeplanVorschlag extends Base {

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "ANLASS_ID", nullable = false)
  @ToString.Exclude
  private Anlass anlass;

  @Enumerated(EnumType.STRING)
  private KategorieEnum kategorie;

  @Enumerated(EnumType.STRING)
  private TiTuEnum tiTu;

  private int maxAnlagen;
  private int maxAbteilungen;

  private int anzahlTeilnehmer;
  private int anzahlGruppen;
  private int anzahlAnlagen;
  private int anzahlAbteilungen;
}
