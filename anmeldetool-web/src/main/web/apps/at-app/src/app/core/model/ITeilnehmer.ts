import { IAnlassLinks } from './IAnlassLinks';
import { KategorieEnum } from './KategorieEnum';
import { TiTuEnum } from './TiTuEnum';

export type ITeilnehmer = {
  id?: string;
  name?: string;
  vorname?: string;
  jahrgang?: number;
  stvNummer?: string;
  tiTu?: keyof typeof TiTuEnum;
  dirty?: boolean;
  teilnahmen?: IAnlassLinks;
  onlyCreated?: boolean;
  letzteKategorie?: keyof typeof KategorieEnum;
};

export function hashCode(str: string): number {
  let h = 0;
  for (let i = 0; i < str.length; i++) {
    h = 31 * h + str.charCodeAt(i);
  }
  return h;
}
