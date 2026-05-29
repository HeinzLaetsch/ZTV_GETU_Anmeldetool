import { Component, EventEmitter, Input, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { GeraeteEnum } from 'src/app/core/model/GeraeteEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { ILauflistenEintrag } from 'src/app/core/model/ILauflistenEintrag';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import { MaterialModule } from 'src/app/shared/material-module';
import { AnlassStatusComponent } from './anlass-status/anlass-status.component';
import { ErfassenHeaderComponent } from './header/erfassen-header.component';
import { ErfassenRowComponent } from './row/erfassen-row.component';

@Component({
  selector: 'lxt-erfassen',
  templateUrl: './erfassen.component.html',
  styleUrls: ['./erfassen.component.css'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MaterialModule,
    AnlassStatusComponent,
    ErfassenHeaderComponent,
    ErfassenRowComponent,
  ],
})
export class ErfassenComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  modeErfassen;

  checkedChangedEmitter = new EventEmitter<ILaufliste>();

  erfasstChangedEmitter = new EventEmitter<ILaufliste>();

  laufliste: ILaufliste;

  sortedEintraege: ILauflistenEintrag[];

  search: string;

  constructor(
    private authService: AuthService,
    private ranglistenService: RanglistenService,
  ) {
    this.sortedEintraege = [];
  }

  ngOnInit() {
    // const organisatorId: string = this.route.snapshot.params.id;
    // this.anlass = this.anlassService.getAnlassByOrganisatorId(organisatorId);
    /*
    this.routeSubject = this.route.params.subscribe((param) => {
      if (param.function === "erfassen") {
        if (!this.modeErfassen) {
          this.searchLaufliste();
        }
        this.modeErfassen = true;
      } else {
        if (this.modeErfassen) {
          this.searchLaufliste();
        }
        this.modeErfassen = false;
      }
    });
    */
  }

  get sprung(): boolean {
    if (this.laufliste?.geraet === GeraeteEnum.SPRUNG.toString().toUpperCase()) {
      return true;
    }
    return false;
  }
  get title(): string {
    if (this.modeErfassen) {
      return 'Noten erfassen';
    }
    return 'Note überprüfen';
  }

  searchLaufliste() {
    console.log('Suche: ', this.search);
    this.ranglistenService.searchLauflisteByKey(this.anlass, this.search).subscribe((laufliste) => {
      if (laufliste) {
        this.sortedEintraege = this.getSortedEintraege(laufliste);
        this.laufliste = laufliste;
      }
    });
  }
  getSortedEintraege(laufliste: ILaufliste): ILauflistenEintrag[] {
    return laufliste.eintraege.sort((a, b) => {
      if (a.startOrder < b.startOrder) {
        return -1;
      }
      if (a.startOrder > b.startOrder) {
        return 1;
      }
      return 0;
    });
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.search = laufliste.laufliste;
    this.searchLaufliste();
  }

  private updateLaufliste(): void {
    this.ranglistenService.updateLaufliste(this.anlass, this.laufliste).subscribe((laufliste) => {
      this.laufliste.erfasst = laufliste.erfasst;
      this.laufliste.checked = laufliste.checked;

      if (this.modeErfassen) {
        this.erfasstChangedEmitter.emit(laufliste);
      } else {
        if (!laufliste.checked && !laufliste.erfasst) {
          this.erfasstChangedEmitter.emit(laufliste);
        }
        this.checkedChangedEmitter.emit(laufliste);
      }
    });
  }
  private checkErfassen(): void {
    // toBeUpdated.erfasst = entry.erfasst;
    const notErfasst = this.laufliste.eintraege.filter((eintrag) => {
      return !eintrag.erfasst && !eintrag.deleted;
    });
    if (notErfasst.length === 0) {
      this.laufliste.erfasst = true;
      this.updateLaufliste();
    } else {
      // TODO handle rollback
      const old = this.laufliste.erfasst;
      this.laufliste.erfasst = false;
      if (old) {
        this.updateLaufliste();
      }
    }
  }
  private checkChecked(): void {
    const notChecked = this.laufliste.eintraege.filter((eintrag) => {
      return !eintrag.checked && !eintrag.deleted;
    });
    if (notChecked.length === 0) {
      this.laufliste.checked = true;
      this.updateLaufliste();
    } else {
      const old = this.laufliste.checked;
      this.laufliste.checked = false;
      if (old) {
        this.updateLaufliste();
      }
    }
  }
  entryChanged(entry: ILauflistenEintrag) {
    const toBeUpdated = this.laufliste.eintraege.filter((eintrag) => {
      return eintrag.tal_id === entry.tal_id;
    })[0];
    if (this.modeErfassen) {
      toBeUpdated.erfasst = entry.erfasst;
      toBeUpdated.deleted = entry.deleted;
      this.checkErfassen();
    } else {
      toBeUpdated.checked = entry.checked;
      this.checkChecked();
      if (!entry.checked && !entry.erfasst) {
        toBeUpdated.erfasst = entry.erfasst;
        this.checkErfassen();
      }
    }
  }
}
