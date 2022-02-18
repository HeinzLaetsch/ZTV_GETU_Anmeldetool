import { KategorieEnum } from "./KategorieEnum";
import { TiTuEnum } from "./TiTuEnum";

export interface IRanglistenConfiguration {
  id: string;
  anlassId: string;
  kategorie: KategorieEnum;
  tiTu: TiTuEnum;
  maxAuszeichnungen: number;
}
