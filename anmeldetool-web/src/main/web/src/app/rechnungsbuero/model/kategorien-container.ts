import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { AbteilungenContainer } from "./abteilungen-container";

export class KategorienContainer {
  private kategorie: KategorieEnum;
  private abteilungen_: AbteilungEnum[];
  private abteilungenContainer: AbteilungenContainer[];
  constructor(kategorie: KategorieEnum) {
    this.abteilungenContainer = new Array();
  }

  getAbteilungen(): AbteilungEnum[] {
    return this.abteilungen_;
  }

  getAbteilungenContainer(abteilung: AbteilungEnum) {
    const index = this.abteilungen_.indexOf(abteilung);
    return this.abteilungenContainer[abteilung];
  }
}
