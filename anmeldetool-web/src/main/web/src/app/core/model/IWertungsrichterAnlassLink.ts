import { IWertungsrichterEinsatz } from "./IWertungsrichterEinsatz";

export interface IWertungsrichterAnlassLink {
  id: string;
  anlassId: string;
  personId: string;
  wertungsrichterId: string;
  einsaetze?: IWertungsrichterEinsatz[];
  kommentar: string;
}
