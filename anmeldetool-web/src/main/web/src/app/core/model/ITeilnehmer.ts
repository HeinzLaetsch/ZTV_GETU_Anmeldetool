import { IAnlassLinks } from "./IAnlassLinks";

export interface ITeilnehmer {
  id: string;
  name: string;
  vorname: string;
  jahrgang: number;
  dirty: boolean;
  teilnahmen?: IAnlassLinks
}
