import { CommonModule } from '@angular/common';
import { Component, type OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import type { MatSelectChange } from '@angular/material/select';
import { MatSelectModule } from '@angular/material/select';
import { MatSliderModule } from '@angular/material/slider';
import { ActivatedRoute } from '@angular/router';
import { select, Store } from '@ngrx/store';
import type { Observable } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ILauflistenStatus } from 'src/app/core/model/ILauflistenStatus';
import type { IRanglistenConfiguration } from 'src/app/core/model/IRanglistenConfiguration';
import type { IRanglistenEntry } from 'src/app/core/model/IRanglistenEntry';
import type { IUser } from 'src/app/core/model/IUser';
import { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { TiTuEnum } from 'src/app/core/model/TiTuEnum';
import { selectAnlassById } from 'src/app/core/redux/anlass';
import type { AppState } from 'src/app/core/redux/core.state';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import { RanglistenEntryComponent } from './entry/ranglisten-entry.component';
import { RanglistenHeaderComponent } from './header/ranglisten-header.component';

@Component({
  selector: 'ztv-ranglisten',
  templateUrl: './ranglisten.component.html',
  styleUrls: ['./ranglisten.component.scss'],
  imports: [
    CommonModule,
    FormsModule,
    MatButtonModule,
    MatFormFieldModule,
    MatSelectModule,
    MatSliderModule,
    RanglistenHeaderComponent,
    RanglistenEntryComponent,
  ],
})
export class RanglistenComponent extends SubscriptionHelper implements OnInit {
  currentUser: IUser;
  anlass: IAnlass;
  anlass$: Observable<IAnlass>;

  tiTu: TiTuEnum;
  kategorie: KategorieEnum;
  ranglistenEntries: IRanglistenEntry[];
  highlighted = false;
  config: IRanglistenConfiguration;
  lauflistenStatus: ILauflistenStatus;
  git;
  constructor(
    private authService: AuthService,
    private store: Store<AppState>,
    // private anlassService: CachingAnlassService,
    private ranglistenService: RanglistenService,
    private route: ActivatedRoute,
  ) {
    super();
    this.tiTu = TiTuEnum.Tu;
    this.kategorie = KategorieEnum.K1;
  }

  ngOnInit(): void {
    this.currentUser = this.authService.currentUser;
    //const organisatorId: string = this.route.snapshot.params.id;
    const anlassId: string = this.route.snapshot.params.id;
    this.anlass$ = this.store.pipe(select(selectAnlassById(anlassId)));
    this.registerSubscription(
      this.anlass$.subscribe((anlass) => {
        this.anlass = anlass;
        this.tiTu = this.anlass.tiTu;
        this.getConfig();
        this.getRanglistenState();
      }),
    );
    // this.anlass = this.anlassService.getAnlassByOrganisatorId(organisatorId);
    // this.getRangliste();
  }

  // In Store moven und im Tab Header anzeigen geht nicht Kategorie
  getRanglistenState(): void {
    this.ranglistenService.getRanglistenState(this.anlass, this.getFilter(), this.kategorie).subscribe((result) => {
      this.lauflistenStatus = result;
    });
  }
  get filterOk(): boolean {
    return !!this.kategorie;
  }
  get anzahl(): number {
    if (this.ranglistenEntries) {
      return this.ranglistenEntries.length;
    }
    return 0;
  }
  get label(): string {
    if (!this.ranglistenEntries) {
      return '? / ?%';
    }
    const labelAsString =
      'Rang ' + this.maxAuszeichnungen + ' / ' + (this.maxAuszeichnungen / this.ranglistenEntries.length) * 100 + ' %';
    return labelAsString;
  }
  get maxAuszeichnungen(): number {
    if (this.config) {
      return this.config.maxAuszeichnungen;
    }
    return 0;
  }
  set maxAuszeichnungen(maxAuszeichnungen: number) {
    if (this.config) {
      this.config.maxAuszeichnungen = maxAuszeichnungen;
    }
  }
  sliderChanged(value: Event): void {
    console.log('Slider: ', value);
    this.getRangliste();
  }
  private getFilter(): string {
    let filter: string;
    if (this.isAlle()) {
      filter = 'Ti';
      if (TiTuEnum.Tu === this.tiTu) {
        filter = 'Tu';
      }
    } else {
      if (this.anlass.tiAnlass) {
        filter = 'Ti';
      } else {
        filter = 'Tu';
      }
    }
    return filter;
  }
  getTeamwertung(): void {
    this.ranglistenService.getTeamwertung(this.anlass, this.getFilter(), this.kategorie);
  }

  getRanglistePdfPerVerein(): void {
    this.ranglistenService.getRanglistePdfPerVerein(this.anlass, this.getFilter(), this.kategorie);
  }

  getRanglistePdf(): void {
    this.ranglistenService.getRanglistePdf(this.anlass, this.getFilter(), this.kategorie, this.maxAuszeichnungen);
  }

  getRanglisteCsv(): void {
    this.ranglistenService.getRanglisteCsv(this.anlass, this.getFilter(), this.kategorie, this.maxAuszeichnungen);
  }

  getRangliste(): void {
    this.ranglistenService
      .getRangliste(this.anlass, this.getFilter(), this.kategorie, this.maxAuszeichnungen)
      .subscribe((result) => {
        this.ranglistenEntries = result;
        if (result) {
          this.ranglistenEntries.sort((a, b) => {
            if (a.rang < b.rang) {
              return -1;
            }
            if (a.rang > b.rang) {
              return 1;
            }
            // Da noch Namen vergleichen ?
            return 0;
          });
        }
      });
  }

  getConfig(): void {
    this.ranglistenService
      .getRanglisteConfiguration(this.anlass, this.getFilter(), this.kategorie)
      .subscribe((result) => {
        this.config = result;
        this.getRangliste();
      });
  }
  getKategorienRaw(anlass: IAnlass): KategorieEnum[] {
    return anlass.getKategorienRaw().slice(1);
  }

  kategorieSelected(kategorie: MatSelectChange): void {
    this.kategorie = kategorie.value;
    //     this.getRangliste();
    this.getConfig();
    this.getRanglistenState();
  }

  tiTuSelected(tiTu: MatSelectChange): void {
    this.tiTu = TiTuEnum[tiTu.value];
    this.getConfig();
    this.getRanglistenState();
  }

  isAlle(): boolean {
    return this.anlass.alleAnlass;
  }
}
