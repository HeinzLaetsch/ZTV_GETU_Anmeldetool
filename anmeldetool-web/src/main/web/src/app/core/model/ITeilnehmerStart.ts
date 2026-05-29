import { MeldeStatusEnum } from './MeldeStatusEnum';
import { TiTuEnum } from './TiTuEnum';

export type ITeilnehmerStart = {
  id: string;
  name: string;
  vorname: string;
  tiTu: TiTuEnum;
  verein: string;
  kategorie: string;
  abteilung: string;
  anlage: string;
  startgeraet: string;
  meldeStatus: string;
  laufliste: boolean;
}
