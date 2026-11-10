import type { KategorieEnum } from './KategorieEnum';

export type TimeplanTiTu = 'Ti' | 'Tu';
export type TimeplanGeraet = 'BODEN' | 'RECK' | 'SPRUNG' | 'SCHAUKELRINGE' | 'BARREN';

export interface ITimeplanInput {
  kategorie: KategorieEnum;
  tiTu: TimeplanTiTu;
  maxAnlagen: number;
  maxAbteilungen: number;
}

export interface ITimeplanVorschlag extends ITimeplanInput {
  anzahlTeilnehmer: number;
  aktuelleTeilnehmer: number;
  anzahlGruppen: number;
  gruppenGroesseMin: number;
  gruppenGroesseMax: number;
  anzahlAnlagen: number;
  anzahlAbteilungen: number;
  gruppenProAnlage: number;
  geraete: TimeplanGeraet[];
  gespeichert: boolean;
}

export const TIMEPLAN_MAX_ANLAGEN = 6;
export const TIMEPLAN_MAX_ABTEILUNGEN = 8;
