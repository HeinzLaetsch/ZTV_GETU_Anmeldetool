import { KategorieEnum } from './KategorieEnum';
import { TiTuEnum } from './TiTuEnum';

export type IRanglistenConfiguration = {
  id: string;
  anlassId: string;
  kategorie: KategorieEnum;
  tiTu: TiTuEnum;
  maxAuszeichnungen: number;
}
