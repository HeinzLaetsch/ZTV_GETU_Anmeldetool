import { IWertungsrichterEinsatz } from "./IWertungsrichterEinsatz";

export interface IPersonAnlassLink {
  id: string;
  anlassId?: string;
  personId?: string;
  dirty: boolean;
  einsaetze?: IWertungsrichterEinsatz[];
  kommentar: string;
}
