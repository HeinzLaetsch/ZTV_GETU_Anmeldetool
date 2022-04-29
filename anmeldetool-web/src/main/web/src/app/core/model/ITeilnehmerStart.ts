import { MeldeStatusEnum } from "./MeldeStatusEnum";
import { TiTuEnum } from "./TiTuEnum";

export interface ITeilnehmerStart {
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
}
