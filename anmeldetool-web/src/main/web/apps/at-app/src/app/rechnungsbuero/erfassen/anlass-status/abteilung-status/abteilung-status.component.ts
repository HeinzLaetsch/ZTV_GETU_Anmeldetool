import {
  ChangeDetectionStrategy,
  Component,
  type EventEmitter,
  inject,
  input,
  type OnInit,
  output,
  ViewEncapsulation,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import type { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import type { ChangeEvent } from 'src/app/rechnungsbuero/model/change-event';
import { MaterialModule } from 'src/app/shared/material-module';
import { AnlageStatusComponent } from '../anlage-status/anlage-status.component';

@Component({
  selector: 'ztv-abteilung-status',
  templateUrl: './abteilung-status.component.html',
  styleUrls: ['./abteilung-status.component.scss'],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, MaterialModule, AnlageStatusComponent],
})
export class AbteilungStatusComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly kategorie = input.required<KategorieEnum>();
  readonly abteilung = input.required<AbteilungEnum>();
  readonly erfasstChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly checkedChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly erfasstEvent = output<ChangeEvent<AbteilungEnum>>();
  readonly checkedEvent = output<ChangeEvent<AbteilungEnum>>();
  readonly lauflisteSelectedEvent = output<ILaufliste>();

  erfasst: boolean;
  erfasstAnlagen: boolean[];
  checked: boolean;
  checkedAnlagen: boolean[];

  anlagen: AnlageEnum[];
  private readonly ranglistenService = inject(RanglistenService);

  constructor() {
    this.erfasstAnlagen = new Array(Object.keys(AnlageEnum).length);
    this.checkedAnlagen = new Array(Object.keys(AnlageEnum).length);
  }

  ngOnInit(): void {
    this.ranglistenService
      .getAnlagenForAnlass(this.anlass(), this.kategorie(), this.abteilung())
      .subscribe((anlagen) => {
        this.anlagen = anlagen;
      });
    this.erfasstChangedEmitter().subscribe((_laufliste) => {
      // console.log("AbteilungStatusComponent: Laufliste changed: ", laufliste);
    });
  }
  erfasstChanged(changeEvent: ChangeEvent<AnlageEnum>): void {
    this.erfasstAnlagen[this.getIndex(changeEvent.topic)] = changeEvent.status;
    const nichtAlle = this.erfasstAnlagen.filter((erfasst) => {
      if (erfasst === false) {
        return true;
      }
      return false;
    });
    this.erfasst = nichtAlle.length === 0;
    const eventData: ChangeEvent<AbteilungEnum> = {
      status: this.erfasst,
      topic: this.abteilung(),
    };
    this.erfasstEvent.emit(eventData);
  }
  checkedChanged(changeEvent: ChangeEvent<AnlageEnum>): void {
    this.checkedAnlagen[this.getIndex(changeEvent.topic)] = changeEvent.status;
    const nichtAlle = this.checkedAnlagen.filter((checked) => {
      if (checked === false) {
        return true;
      }
      return false;
    });
    this.checked = nichtAlle.length === 0;
    const eventData: ChangeEvent<AbteilungEnum> = {
      status: this.checked,
      topic: this.abteilung(),
    };
    this.checkedEvent.emit(eventData);
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }

  private getIndex(anlage: AnlageEnum): number {
    const index = Object.keys(AnlageEnum).indexOf(anlage);
    return index;
  }
}
