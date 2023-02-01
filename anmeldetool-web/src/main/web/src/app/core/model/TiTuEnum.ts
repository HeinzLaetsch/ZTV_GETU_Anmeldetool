import { compileDeclareClassMetadata } from "@angular/compiler";
export enum TiTuEnum {
  Ti = "Turnerin",
  Tu = "Turner",
  Alle = "Gemeinsamer Anlass",
}

export namespace TiTuEnum {
  export function toString(tiTu: TiTuEnum): string {
    return TiTuEnum[tiTu];
  }

  export function parse(tiTu: string): TiTuEnum {
    return TiTuEnum[tiTu];
  }

  export function equals(tiTu1: TiTuEnum, tiTu2: TiTuEnum): boolean {
    let tiTu1String = TiTuEnum[tiTu1];
    if (tiTu1String === undefined) {
      tiTu1String = tiTu1;
    }
    let tiTu2String = TiTuEnum[tiTu2];
    if (tiTu2String === undefined) {
      tiTu2String = tiTu2;
    }
    return tiTu1String === tiTu2String;
  }
}
