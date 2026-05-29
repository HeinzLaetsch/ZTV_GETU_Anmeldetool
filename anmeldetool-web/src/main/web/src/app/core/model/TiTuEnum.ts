export enum TiTuEnum {
  Ti = 'Turnerin',
  Tu = 'Turner',
  Alle = 'Gemeinsamer Anlass',
}

export const TiTuValues = Object.values(TiTuEnum);

export const parseTiTuEnum = (value?: string): TiTuEnum | undefined => {
  if (!value) {
    return undefined;
  }

  if (value in TiTuEnum) {
    return TiTuEnum[value as keyof typeof TiTuEnum];
  }

  return TiTuValues.find((tiTu) => tiTu === value);
};

export const isTiTuEnumEqual = (a?: string, b?: string): boolean => parseTiTuEnum(a) === parseTiTuEnum(b);
