export interface IWertungsrichter {
  id: string;
  personId?: string;
  brevet: number;
  gueltig: boolean;
  letzterFK: Date;
  aktiv: boolean;
}
