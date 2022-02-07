import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";

export class AnlagenContainer {
  private anlage: AnlageEnum;
  private lauflisten_: ILaufliste[];
  constructor(lauflisten: ILaufliste[]) {
    this.lauflisten_ = lauflisten;
  }

  getLauflisten(): ILaufliste[] {
    return this.lauflisten_;
  }
}
