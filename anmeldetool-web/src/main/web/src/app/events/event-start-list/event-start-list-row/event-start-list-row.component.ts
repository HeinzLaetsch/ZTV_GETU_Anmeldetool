import { Component, Input, OnInit } from "@angular/core";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { AuthService } from "src/app/core/service/auth/auth.service";

@Component({
  selector: "app-event-start-list-row",
  templateUrl: "./event-start-list-row.component.html",
  styleUrls: ["./event-start-list-row.component.css"],
})
export class EventStartListRowComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  teilnehmer: ITeilnehmer;

  constructor(public authService: AuthService) {}

  ngOnInit() {
    // console.log("Anlass: ", this.anlass);
  }

  get administrator(): boolean {
    return this.authService.isAdministrator();
  }

  get showDetail(): boolean {
    this.anlass.abteilungFix;

    if (
      this.anlass.anzeigeStatus.hasStatus(
        AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED
      ) ||
      this.administrator
    ) {
      return true;
    } else {
      return false;
    }
  }

  get abteilung(): string {
    if (this.teilnehmer.teilnahmen.anlassLinks[0].abteilung?.endsWith("1")) {
      return "1";
    }
    if (this.teilnehmer.teilnahmen.anlassLinks[0].abteilung?.endsWith("2")) {
      return "2";
    }
    if (this.teilnehmer.teilnahmen.anlassLinks[0].abteilung?.endsWith("3")) {
      return "3";
    }
    if (this.teilnehmer.teilnahmen.anlassLinks[0].abteilung?.endsWith("4")) {
      return "4";
    }
    return "-";
  }
  get anlage(): string {
    if (this.teilnehmer.teilnahmen.anlassLinks[0].anlage?.endsWith("1")) {
      return "1";
    }
    if (this.teilnehmer.teilnahmen.anlassLinks[0].anlage?.endsWith("2")) {
      return "2";
    }
    if (this.teilnehmer.teilnahmen.anlassLinks[0].anlage?.endsWith("3")) {
      return "3";
    }
    if (this.teilnehmer.teilnahmen.anlassLinks[0].anlage?.endsWith("4")) {
      return "4";
    }
    return "-";
  }
}
