import { IWertungsrichterSlot } from "./IWertungsrichterSlot";
import { KategorieEnum } from "./KategorieEnum";
import { TiTuEnum } from "./TiTuEnum";

export interface IAnlass {
  id: string;
  anlassBezeichnung: string;
  ort: string;
  halle: string;
  startDatum: Date;
  endDatum: Date;
  tiTu: TiTuEnum;
  tiefsteKategorie: KategorieEnum;
  hoechsteKategorie: KategorieEnum;
  wertungsrichterSlots?: IWertungsrichterSlot[];
}
