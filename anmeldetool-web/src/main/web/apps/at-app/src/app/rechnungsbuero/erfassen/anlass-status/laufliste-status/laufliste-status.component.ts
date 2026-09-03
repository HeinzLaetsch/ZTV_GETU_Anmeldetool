import { Component, EventEmitter, Input, type OnInit, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import type { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import type { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';

@Component({
  selector: 'lxt-laufliste-status',
  templateUrl: './laufliste-status.component.html',
  styleUrls: ['./laufliste-status.component.css'],
  standalone: true,
  imports: [CommonModule],
})
export class LauflisteStatusComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  abteilung: AbteilungEnum;
  @Input()
  anlage: AnlageEnum;
  @Input()
  laufliste: ILaufliste;
  @Input()
  erfasstChangedEmitter: EventEmitter<ILaufliste>;
  @Input()
  checkedChangedEmitter: EventEmitter<ILaufliste>;
  @Output()
  lauflisteSelectedEvent = new EventEmitter<ILaufliste>();
  @Output()
  lauflisteErfasstEvent = new EventEmitter<ILaufliste>();

  @Output()
  lauflisteCheckedEvent = new EventEmitter<ILaufliste>();

  ngOnInit() {
    this.erfasstChangedEmitter.subscribe((laufliste) => {
      if (laufliste.id === this.laufliste.id) {
        console.log('LauflisteStatusComponent : Laufliste changed: ', laufliste);
        this.laufliste.erfasst = laufliste.erfasst;
        this.lauflisteErfasstEvent.emit(this.laufliste);
      }
    });
    this.checkedChangedEmitter.subscribe((laufliste) => {
      if (laufliste.id === this.laufliste.id) {
        console.log('LauflisteStatusComponent : Laufliste changed: ', laufliste);
        this.laufliste.checked = laufliste.checked;
        this.lauflisteCheckedEvent.emit(this.laufliste);
      }
    });
  }

  clicked(event: any) {
    this.lauflisteSelectedEvent.emit(this.laufliste);
  }
}
