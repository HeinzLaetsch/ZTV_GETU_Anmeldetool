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
import type { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import type { ChangeEvent } from 'src/app/rechnungsbuero/model/change-event';
import { MaterialModule } from 'src/app/shared/material-module';
import { LauflisteStatusComponent } from '../laufliste-status/laufliste-status.component';

@Component({
  selector: 'ztv-anlage-status',
  templateUrl: './anlage-status.component.html',
  styleUrls: ['./anlage-status.component.scss'],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, MaterialModule, LauflisteStatusComponent],
})
export class AnlageStatusComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly kategorie = input.required<KategorieEnum>();
  readonly abteilung = input.required<AbteilungEnum>();
  readonly anlage = input.required<AnlageEnum>();
  readonly erfasstChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly checkedChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly erfasstEvent = output<ChangeEvent<AnlageEnum>>();
  readonly checkedEvent = output<ChangeEvent<AnlageEnum>>();
  readonly lauflisteSelectedEvent = output<ILaufliste>();

  lauflisten: ILaufliste[];

  erfasst = true;

  checked = true;

  private readonly ranglistenService = inject(RanglistenService);

  ngOnInit(): void {
    this.ranglistenService
      .getLauflisten(this.anlass(), this.kategorie(), this.abteilung(), this.anlage())
      .subscribe((lauflisten) => {
        this.lauflisten = lauflisten.sort((a, b) => {
          if (a.abloesung < b.abloesung) {
            return -1;
          }
          if (a.abloesung > b.abloesung) {
            return 1;
          }
          return 0;
        });
        this.erfasstChanged();
        this.checkedChanged();
      });
    this.erfasstChangedEmitter().subscribe((_laufliste) => {
      // console.log("AnlageStatusComponent: Laufliste changed: ", laufliste);
    });
  }

  lauflisteErfasstChanged(erfasstLaufliste: ILaufliste): void {
    this.lauflisten.forEach((laufliste) => {
      if (laufliste.id === erfasstLaufliste.id) {
        laufliste.erfasst = erfasstLaufliste.erfasst;
      }
    });
    this.erfasstChanged();
  }

  lauflisteCheckedChanged(changedLaufliste: ILaufliste): void {
    this.lauflisten.forEach((laufliste) => {
      if (laufliste.id === changedLaufliste.id) {
        laufliste.checked = changedLaufliste.checked;
      }
    });
    this.checkedChanged();
  }

  erfasstChanged(): void {
    /*
    const nichtAlle = this.erfasstLauflisten.filter((erfasst) => {
      if (erfasst === false) {
        return true;
      }
      return false;
    });*/
    const nichtAlle = this.lauflisten.filter((laufliste) => {
      return !laufliste.erfasst;
    });
    this.erfasst = nichtAlle.length === 0;
    const eventData: ChangeEvent<AnlageEnum> = {
      status: this.erfasst,
      topic: this.anlage(),
    };
    this.erfasstEvent.emit(eventData);
  }

  checkedChanged(): void {
    /*const nichtAlle = this.checkedLauflisten.filter((checked) => {
      if (checked === false) {
        return true;
      }
      return false;
    });*/
    const nichtAlle = this.lauflisten.filter((laufliste) => {
      return !laufliste.checked;
    });

    this.checked = nichtAlle.length === 0;
    const eventData: ChangeEvent<AnlageEnum> = {
      status: this.checked,
      topic: this.anlage(),
    };
    this.checkedEvent.emit(eventData);
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }
}
