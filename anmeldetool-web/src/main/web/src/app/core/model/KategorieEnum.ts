export namespace KategorieEnumFunction {
  export function toString(kategorie: KategorieEnum): string {
    return KategorieEnum[kategorie];
  }

  export function values(): any[] {
    return Object.values(KategorieEnum);
  }

  export function keys(): any[] {
    return Object.keys(KategorieEnum);
  }

  export function parse(kategorie: string): KategorieEnum {
    return KategorieEnum[kategorie];
  }

  export function equals(
    kategorie1: KategorieEnum,
    kategorie2: KategorieEnum
  ): boolean {
    let kategorie1String = KategorieEnum[kategorie1];
    if (kategorie1String === undefined) {
      kategorie1String = kategorie1;
    }
    let kategorie2String = KategorieEnum[kategorie2];
    if (kategorie2String === undefined) {
      kategorie2String = kategorie2;
    }
    return kategorie1String === kategorie2String;
  }

  export function valuesAndGreater(start: string): any[] {
    if (start === undefined || start === null) {
      start = "K1";
    }
    const startindex = Object.values(KategorieEnum).findIndex((element) =>
      equals(element, parse(start))
    );
    return Object.values(KategorieEnum).slice(startindex);
  }

  export function isBrevet1(kategorie: KategorieEnum): boolean {
    return (
      KategorieEnumFunction.equals(KategorieEnum.K1, kategorie) ||
      KategorieEnumFunction.equals(KategorieEnum.K2, kategorie) ||
      KategorieEnumFunction.equals(KategorieEnum.K3, kategorie) ||
      KategorieEnumFunction.equals(KategorieEnum.K4, kategorie)
    );
  }

  export function isBrevet2(kategorie: KategorieEnum): boolean {
    return (
      !KategorieEnumFunction.equals(KategorieEnum.K1, kategorie) &&
      !KategorieEnumFunction.equals(KategorieEnum.K2, kategorie) &&
      !KategorieEnumFunction.equals(KategorieEnum.K3, kategorie) &&
      !KategorieEnumFunction.equals(KategorieEnum.K4, kategorie) &&
      !KategorieEnumFunction.equals(KategorieEnum.KEINE_TEILNAHME, kategorie)
    );
  }
}

export enum KategorieEnum {
  KEINE_TEILNAHME = "keine Teilnahme",
  K1 = "K1",
  K2 = "K2",
  K3 = "K3",
  K4 = "K4",
  K5 = "K5",
  K5A = "K5A",
  K5B = "K5B",
  K6 = "K6",
  KD = "KD",
  KH = "KH",
  K7 = "K7",
}
