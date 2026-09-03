import type { IAnlass } from './IAnlass';
import { isTiTuEnumEqual, TiTuEnum } from './TiTuEnum';

export enum KategorieEnum {
  KEINE_TEILNAHME = 'keine Teilnahme',
  KEIN_START = 'kein Start',
  K1 = 'K1',
  K2 = 'K2',
  K3 = 'K3',
  K4 = 'K4',
  K5 = 'K5',
  K5A = 'K5A',
  K5B = 'K5B',
  K6 = 'K6',
  KD = 'KD',
  KH = 'KH',
  K7 = 'K7',
}

const KATEGORIE_VALUES: KategorieEnum[] = [
  KategorieEnum.KEINE_TEILNAHME,
  KategorieEnum.KEIN_START,
  KategorieEnum.K1,
  KategorieEnum.K2,
  KategorieEnum.K3,
  KategorieEnum.K4,
  KategorieEnum.K5,
  KategorieEnum.K5A,
  KategorieEnum.K5B,
  KategorieEnum.K6,
  KategorieEnum.KD,
  KategorieEnum.KH,
  KategorieEnum.K7,
];

const BREVET1_KATEGORIEN = new Set<KategorieEnum>([
  KategorieEnum.K1,
  KategorieEnum.K2,
  KategorieEnum.K3,
  KategorieEnum.K4,
]);

const TI_EXCLUDED_KATEGORIEN = new Set<KategorieEnum>([KategorieEnum.K5, KategorieEnum.KH]);
const TU_EXCLUDED_KATEGORIEN = new Set<KategorieEnum>([KategorieEnum.K5A, KategorieEnum.K5B, KategorieEnum.KD]);

const parseKategorieValue = (value?: string | KategorieEnum): KategorieEnum | undefined => {
  if (!value) {
    return undefined;
  }

  if (KATEGORIE_VALUES.includes(value as KategorieEnum)) {
    return value as KategorieEnum;
  }

  if (value in KategorieEnum) {
    return KategorieEnum[value as keyof typeof KategorieEnum];
  }

  return undefined;
};

export namespace KategorieEnumFunction {
  export function toString(kategorie: KategorieEnum): string {
    return kategorie;
  }

  export function values(): string[] {
    return [...KATEGORIE_VALUES];
  }

  export function keys(): (keyof typeof KategorieEnum)[] {
    return Object.keys(KategorieEnum) as (keyof typeof KategorieEnum)[];
  }

  export function parse(kategorie: string): KategorieEnum {
    return parseKategorieValue(kategorie) ?? (kategorie as KategorieEnum);
  }

  export function equals(kategorie1?: string | KategorieEnum, kategorie2?: string | KategorieEnum): boolean {
    const left = parseKategorieValue(kategorie1);
    const right = parseKategorieValue(kategorie2);

    if (left !== undefined && right !== undefined) {
      return left === right;
    }

    return kategorie1 === kategorie2;
  }

  export function valuesAndGreater(start?: string | KategorieEnum, titu?: TiTuEnum, anlass?: IAnlass): KategorieEnum[] {
    const startKategorie = parseKategorieValue(start) ?? KategorieEnum.K1;
    const startIndex = KATEGORIE_VALUES.indexOf(startKategorie);
    const sliced = startIndex >= 0 ? KATEGORIE_VALUES.slice(startIndex) : [...KATEGORIE_VALUES];

    return sliced.filter((kategorie) => {
      if (anlass) {
        const startBr1 = isBrevet1(anlass.tiefsteKategorie) && (isBrevet1(kategorie) || isBrevet2(kategorie));
        const startBr2 = isBrevet2(anlass.tiefsteKategorie) && isBrevet2(kategorie);
        const endBr1 = isBrevet1(anlass.hoechsteKategorie) && isBrevet1(kategorie);
        const endBr2 = isBrevet2(anlass.hoechsteKategorie) && (isBrevet1(kategorie) || isBrevet2(kategorie));

        if (!((startBr1 && (endBr1 || endBr2)) || (startBr2 && endBr2))) {
          return false;
        }
      }

      if (isTiTuEnumEqual(TiTuEnum.Ti, titu)) {
        return !TI_EXCLUDED_KATEGORIEN.has(kategorie);
      }

      return !TU_EXCLUDED_KATEGORIEN.has(kategorie);
    });
  }

  export function isBrevet1(kategorie: KategorieEnum): boolean {
    return BREVET1_KATEGORIEN.has(kategorie);
  }

  export function isBrevet2(kategorie: KategorieEnum): boolean {
    return !isBrevet1(kategorie) && !equals(KategorieEnum.KEIN_START, kategorie);
  }
}
