import { IWertungsrichterEinsatz } from './IWertungsrichterEinsatz';

export type IPersonAnlassLink = {
  id: string;
  anlassId?: string;
  personId?: string;
  dirty: boolean;
  einsaetze?: IWertungsrichterEinsatz[];
  kommentar: string;
};
