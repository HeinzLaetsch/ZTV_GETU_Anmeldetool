import { IMeldeStatusStati } from './IMeldeStatusStati';
import { KategorieEnum } from './KategorieEnum';

export type IKategorieStati = {
  kategorie: KategorieEnum;
  meldeStati: IMeldeStatusStati[];
};
