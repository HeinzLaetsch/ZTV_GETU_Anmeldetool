import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { UntypedFormControl, UntypedFormGroup } from "@angular/forms";
import { MatDatepickerInputEvent } from "@angular/material/datepicker";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";

@Component({
  selector: "app-events-dates",
  templateUrl: "./events-dates.component.html",
  styleUrls: ["./events-dates.component.css"],
})
export class EventsDatesComponent implements OnInit {
  @Input() anlass: IAnlass;
  @Input() viewOnly: boolean;

  @Output()
  verlaengertChange: EventEmitter<Date>;

  verlaengerungGroup: UntypedFormGroup;
  verlaengerungControl: UntypedFormControl;

  constructor() {
    // this.verlaengerungGroup = new FormGroup({
    this.verlaengerungControl = new UntypedFormControl();
    // });
    this.verlaengertChange = new EventEmitter<Date>();
  }

  ngOnInit() {
    console.log("Anlass verlaengert: ", this.anlass.erfassenVerlaengert);
    this.verlaengerungControl.setValue(this.anlass.erfassenVerlaengert);
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
    return this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.VERLAENGERT);
  }

  addVerlaengerung(type: string, event: MatDatepickerInputEvent<Date>): void {
    this.verlaengertChange.next(event.value);
  }
}
