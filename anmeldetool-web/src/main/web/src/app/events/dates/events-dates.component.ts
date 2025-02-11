import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { UntypedFormControl, UntypedFormGroup } from "@angular/forms";
import { MatDatepickerInputEvent } from "@angular/material/datepicker";
import * as moment from "moment";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";

@Component({
  selector: "app-events-dates",
  templateUrl: "./events-dates.component.html",
  styleUrls: ["./events-dates.component.css"],
})
export class EventsDatesComponent implements OnInit {
  @Input() anlass: IAnlass;
  @Input() anlassSummary: IAnlassSummary;
  @Input() viewOnly: boolean;

  @Output()
  verlaengertChanged: EventEmitter<Date>;

  verlaengerungGroup: UntypedFormGroup;
  verlaengerungControl: UntypedFormControl;

  constructor() {
    // this.verlaengerungGroup = new FormGroup({
    this.verlaengerungControl = new UntypedFormControl();
    // });
    this.verlaengertChanged = new EventEmitter<Date>();
  }

  ngOnInit() {
    console.log("Anlass verlaengert: ", this.anlass.erfassenVerlaengert);
    //this.verlaengerungControl.setValue(this.anlass.erfassenVerlaengert);
    this.verlaengerungControl.setValue(this.anlassSummary.verlaengerungsDate);
  }
  /*
  ngOnChanges(changes: SimpleChanges): void {
    if (changes.anlass) {
      console.error("anlass: ", this.anlass);
      this.verlaengerungGroup.controls.verlaengerungControl.setValue(
        this.anlass.erfassenVerlaengert
      );
    }
  }*/

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

  getClassForAnzeigeStatusVerlaengert(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.VERLAENGERT);
  }
  hasStatusVerlaengert(): boolean {
    const asMoment = moment(this.anlassSummary.verlaengerungsDate);
    return asMoment.isSameOrAfter(moment.now());
    //return this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.VERLAENGERT);
  }

  addVerlaengerung(type: string, event: MatDatepickerInputEvent<Date>): void {
    this.verlaengertChanged.next(event.value);
  }
}
