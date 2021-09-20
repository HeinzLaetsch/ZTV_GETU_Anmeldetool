import { IAnlassLinks } from "./IAnlassLinks";
import { TiTuEnum } from "./TiTuEnum";

export interface ITeilnehmer {
  id: string;
  name: string;
  vorname: string;
  jahrgang: number;
  tiTu: TiTuEnum;
  dirty: boolean;
  teilnahmen?: IAnlassLinks
}
