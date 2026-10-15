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
import { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import type { ChangeEvent } from 'src/app/rechnungsbuero/model/change-event';
import { MaterialModule } from 'src/app/shared/material-module';
import { AbteilungStatusComponent } from '../abteilung-status/abteilung-status.component';

@Component({
  selector: 'ztv-kategorie-status',
  templateUrl: './kategorie-status.component.html',
  styleUrls: ['./kategorie-status.component.scss'],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, MaterialModule, AbteilungStatusComponent],
})
export class KategorieStatusComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly kategorie = input.required<KategorieEnum>();
  readonly erfasstChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly checkedChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly lauflisteSelectedEvent = output<ILaufliste>();

  abteilungen: AbteilungEnum[];

  erfasst = false;
  erfasstAbteilungen: boolean[];
  checked = false;
  checkedAbteilungen: boolean[];

  private readonly ranglistenService = inject(RanglistenService);

  constructor() {
    this.erfasstAbteilungen = new Array(Object.keys(AbteilungEnum).length);
    this.checkedAbteilungen = new Array(Object.keys(AbteilungEnum).length);
  }

  ngOnInit(): void {
    this.ranglistenService.getAbteilungenForAnlass(this.anlass(), this.kategorie()).subscribe((abteilungen) => {
      this.abteilungen = abteilungen;
    });
    this.erfasstChangedEmitter().subscribe((_laufliste) => {
      // console.log("KategorieStatusComponent: Laufliste changed: ", laufliste);
    });
  }

  erfasstChanged(changeEvent: ChangeEvent<AbteilungEnum>): void {
    this.erfasstAbteilungen[this.getIndex(changeEvent.topic)] = changeEvent.status;
    const nichtAlle = this.erfasstAbteilungen.filter((erfasst) => {
      if (erfasst === false) {
        return true;
      }
      return false;
    });
    this.erfasst = nichtAlle.length === 0;
  }
  checkedChanged(changeEvent: ChangeEvent<AbteilungEnum>): void {
    this.checkedAbteilungen[this.getIndex(changeEvent.topic)] = changeEvent.status;
    const nichtAlle = this.checkedAbteilungen.filter((checked) => {
      if (checked === false) {
        return true;
      }
      return false;
    });
    this.checked = nichtAlle.length === 0;
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }

  private getIndex(abteilung: AbteilungEnum): number {
    const index = Object.keys(AbteilungEnum).indexOf(abteilung);
    return index;
  }
}
