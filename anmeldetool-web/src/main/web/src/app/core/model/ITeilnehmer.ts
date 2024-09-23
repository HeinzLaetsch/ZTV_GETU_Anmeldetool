import { IAnlassLinks } from "./IAnlassLinks";
import { TiTuEnum } from "./TiTuEnum";

export interface ITeilnehmer {
  id?: string;
  name?: string;
  vorname?: string;
  jahrgang?: number;
  stvNummer?: string;
  tiTu?: TiTuEnum;
  dirty?: boolean;
  teilnahmen?: IAnlassLinks;
  onlyCreated?: boolean;
  letzteKategorie?: string;
}

export function hashCode(str: string): number {
  var h: number = 0;
  for (var i = 0; i < str.length; i++) {
    h = 31 * h + str.charCodeAt(i);
  }
  return h;
}
