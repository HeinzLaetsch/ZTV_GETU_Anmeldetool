import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { AnlagenContainer } from "./anlagen-container";

export class AbteilungenContainer {
  private abteilung: AbteilungEnum;
  private anlagen_: AnlageEnum[];
  private anlagenContainer: AnlagenContainer[];
  constructor(abteilung: AbteilungEnum) {
    this.anlagenContainer = new Array();
  }

  getAnlagen(): AnlageEnum[] {
    return this.anlagen_;
  }

  getAnlagenContainer(anlage: AnlageEnum) {
    const index = this.anlagen_.indexOf(anlage);
    return this.anlagenContainer[index];
  }
}
