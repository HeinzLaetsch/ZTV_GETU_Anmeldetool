import { IAnlassLink } from "./IAnlassLink";

export interface ITeilnehmer {
  id: string;
  name: string;
  vorname: string;
  jahrgang: number;
  dirty: boolean;
  teilnahmen?: IAnlassLink[]
}
