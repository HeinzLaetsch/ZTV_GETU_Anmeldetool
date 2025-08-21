import { IMeldeStatusStati } from "./IMeldeStatusStati";
import { KategorieEnum } from "./KategorieEnum";

export interface IKategorieStati {
  kategorie: KategorieEnum;
  meldeStati: IMeldeStatusStati[];
}
