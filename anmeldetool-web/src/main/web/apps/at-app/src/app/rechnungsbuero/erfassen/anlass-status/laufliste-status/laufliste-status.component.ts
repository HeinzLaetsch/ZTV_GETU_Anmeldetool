import { ChangeDetectionStrategy, Component, type EventEmitter, input, type OnInit, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import type { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import type { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';

@Component({
  selector: 'ztv-laufliste-status',
  templateUrl: './laufliste-status.component.html',
  styleUrls: ['./laufliste-status.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule],
})
export class LauflisteStatusComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly kategorie = input.required<KategorieEnum>();
  readonly abteilung = input.required<AbteilungEnum>();
  readonly anlage = input.required<AnlageEnum>();
  readonly laufliste = input.required<ILaufliste>();
  readonly erfasstChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly checkedChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly lauflisteSelectedEvent = output<ILaufliste>();
  readonly lauflisteErfasstEvent = output<ILaufliste>();
  readonly lauflisteCheckedEvent = output<ILaufliste>();

  ngOnInit(): void {
    this.erfasstChangedEmitter().subscribe((laufliste) => {
      if (laufliste.id === this.laufliste().id) {
        console.log('LauflisteStatusComponent : Laufliste changed: ', laufliste);
        this.laufliste().erfasst = laufliste.erfasst;
        this.lauflisteErfasstEvent.emit(this.laufliste());
      }
    });
    this.checkedChangedEmitter().subscribe((laufliste) => {
      if (laufliste.id === this.laufliste().id) {
        console.log('LauflisteStatusComponent : Laufliste changed: ', laufliste);
        this.laufliste().checked = laufliste.checked;
        this.lauflisteCheckedEvent.emit(this.laufliste());
      }
    });
  }

  clicked(_event: Event): void {
    this.lauflisteSelectedEvent.emit(this.laufliste());
  }
}
