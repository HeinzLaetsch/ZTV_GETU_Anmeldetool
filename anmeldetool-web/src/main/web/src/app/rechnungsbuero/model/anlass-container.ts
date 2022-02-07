import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { KategorienContainer } from "./kategorien-container";

export class AnlassContainer {
  private kategorien_: KategorieEnum[];
  private kategorienContainer: KategorienContainer[];
  constructor(kategorien: KategorieEnum[]) {
    this.kategorienContainer = new Array();
    this.kategorien_ = kategorien;
    kategorien.forEach(kategorie => {
      const container = new KategorienContainer(kategorie);
      this.kategorienContainer.push(container);
    });
  }

  getkategorien(): KategorieEnum[] {
    return this.kategorien_;
  }

  getKategorienContainer(kategorie: KategorieEnum) {
    const index = this.kategorien_.indexOf(kategorie);
    return this.kategorienContainer[index];
  }
}
