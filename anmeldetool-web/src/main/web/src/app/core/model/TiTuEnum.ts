export enum TiTuEnum {
  Ti = "Turnerin",
  Tu = "Turner",
  Alle = "Gemeinsamer Anlass",
}

export function getTiTuEnum(value: string): TiTuEnum {
  const values = Object.entries(TiTuEnum);
  const ret = values.filter((val) => {
    const asString: string = val[1];
    return asString === value;
  });
  return TiTuEnum[ret[0][0]] as TiTuEnum;
}
