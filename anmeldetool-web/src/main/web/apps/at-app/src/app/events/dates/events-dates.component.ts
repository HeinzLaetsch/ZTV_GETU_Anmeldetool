import { Component, EventEmitter, Input, type OnInit, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UntypedFormControl, type UntypedFormGroup } from '@angular/forms';
import { ReactiveFormsModule } from '@angular/forms';
import type { MatDatepickerInputEvent } from '@angular/material/datepicker';
import moment from 'moment';
import { AnzeigeStatusEnum } from 'src/app/core/model/AnzeigeStatusEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'lxt-events-dates',
  templateUrl: './events-dates.component.html',
  styleUrls: ['./events-dates.component.css'],
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MaterialModule],
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
    console.log('Anlass verlaengert: ', this.anlass.erfassenVerlaengert);
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
      return 'div-red';
    }
    return 'div-green';
  }

  getClassForAnzeigeStatusNochNichtOffen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN);
  }
  getClassForAnzeigeStatusErfassenGeschlossen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED);
  }

  getClassForAnzeigeStatusCrossKategorieGeschlossen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED);
  }

  getClassForAnzeigeStatusInKategorieGeschlossen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED);
  }

  getClassForAnzeigeStatusAlleMutationenGeschlossen(): string {
    return this.getClassForAnzeigeStatus(AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED);
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
