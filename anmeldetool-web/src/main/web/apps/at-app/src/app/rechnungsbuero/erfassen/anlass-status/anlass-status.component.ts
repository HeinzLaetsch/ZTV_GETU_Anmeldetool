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
import type { IUser } from 'src/app/core/model/IUser';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { MaterialModule } from 'src/app/shared/material-module';
import { KategorieStatusComponent } from './kategorie-status/kategorie-status.component';

@Component({
  selector: 'ztv-anlass-status',
  templateUrl: './anlass-status.component.html',
  styleUrls: ['./anlass-status.component.scss'],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, MaterialModule, KategorieStatusComponent],
})
export class AnlassStatusComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly erfasstChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly checkedChangedEmitter = input.required<EventEmitter<ILaufliste>>();
  readonly lauflisteSelectedEvent = output<ILaufliste>();

  currentUser: IUser;
  panelOpenState = false;

  kategorien: KategorieEnum[];
  abteilungen: AbteilungEnum[][];
  anlagen: AnlageEnum;

  private readonly authService = inject(AuthService);

  constructor() {
    this.abteilungen = [];
  }

  ngOnInit(): void {
    this.currentUser = this.authService.currentUser;
    this.kategorien = this.anlass().getKategorienRaw().slice(1);
    this.erfasstChangedEmitter().subscribe((_laufliste) => {
      // console.log("AnlassStatusComponent : Laufliste changed: ", laufliste);
    });
  }

  getKategorien(): KategorieEnum[] {
    return this.kategorien;
  }

  /*
  getAbteilungen(kategorie: KategorieEnum): AbteilungEnum[] {
    const index = this.kategorien.indexOf(kategorie);
    if (this.abteilungen[index]) {
      return this.abteilungen[index];
    }
    return [];
  }
*/
  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }
}
