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
