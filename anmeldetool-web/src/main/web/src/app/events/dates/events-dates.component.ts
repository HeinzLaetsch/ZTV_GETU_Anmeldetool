import { Component, Input } from "@angular/core";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";

@Component({
  selector: "app-events-dates",
  templateUrl: "./events-dates.component.html",
  styleUrls: ["./events-dates.component.css"],
})
export class EventsDatesComponent {
  @Input() anlass: IAnlass;

  getClassForAnzeigeStatus(anzeigeStatus: AnzeigeStatusEnum): string {
    if (this.anlass.anzeigeStatus.hasStatus(anzeigeStatus)) {
      return "div-red";
    }
    return "div-green";
  }

  getClassForAnzeigeStatusNochNichtOffen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN);
  }
  getClassForAnzeigeStatusErfassenGeschlossen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED);
  }

  getClassForAnzeigeStatusCrossKategorieGeschlossen(): string {
    return this.getClassForAnzeigeStatus(
      AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED
    );
  }

  getClassForAnzeigeStatusInKategorieGeschlossen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED);
  }

  getClassForAnzeigeStatusAlleMutationenGeschlossen(): string {
    return this.getClassForAnzeigeStatus(
      AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED
    );
  }

  getClassForAnzeigeStatusGeschlossen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.CLOSED);
  }
}
