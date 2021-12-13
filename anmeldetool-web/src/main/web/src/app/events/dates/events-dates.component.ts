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
}
