import { CommonModule } from '@angular/common';
import { Component, EventEmitter, type OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { select, Store } from '@ngrx/store';
import { type Observable, Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import type { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import type { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmeStatistic } from 'src/app/core/model/ITeilnahmeStatistic';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import { selectAnlassById } from '../core/redux/anlass';
import type { AppState } from '../core/redux/core.state';
import { AnlassService } from '../core/service/anlass/anlass.service';
import { MaterialModule } from '../shared/material-module';
import { SubscriptionHelper } from '../utils/subscription-helper';
import { ContestUpload } from './contest-upload-dialog/contest-upload.component';
import { EinteilungComponent } from './einteilung/einteilung.component';
import { Upload } from './upload-dialog/upload.component';

@Component({
  selector: 'lxt-event-admin',
  templateUrl: './event-admin.component.html',
  styleUrls: ['./event-admin.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule, MaterialModule, EinteilungComponent],
})
export class EventAdminComponent extends SubscriptionHelper implements OnInit {
  anlass$!: Observable<IAnlass>;
  anlass: IAnlass;

  private readonly lauflistenPDF$ = new Subject<void>();

  message: string;
  hasError = false;
  onlyTi = false;
  hideOnlyTi = false;

  abteilungen: AbteilungEnum[];
  selectedAbteilung: AbteilungEnum;

  kategorien: KategorieEnum[];
  selectedKategorie: KategorieEnum;

  anlagen: AnlageEnum[];
  selectedAnlage: AnlageEnum;

  teilnahmeStatistic: ITeilnahmeStatistic;

  refreshEmitter = new EventEmitter<string>();

  loaded$: Subject<boolean>;

  rotieren: boolean;

  constructor(
    public dialog: MatDialog,
    private route: ActivatedRoute,
    public authService: AuthService,
    private store: Store<AppState>,

    private anlassService: AnlassService,
    private ranglistenService: RanglistenService,
  ) {
    super();
    this.rotieren = false;
    this.loaded$ = new Subject();
  }

  ngOnInit(): void {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass$ = this.store.pipe(select(selectAnlassById(anlassId)));
    this.registerSubscription(
      this.anlass$.subscribe((data) => {
        this.anlass = data;
        if (this.anlass.alleAnlass) {
          this.hideOnlyTi = true;
        }
        this.kategorien = this.anlass.getKategorienRaw();
        this.anlassService
          .getTeilnahmeStatistic(this.anlass, undefined, undefined, undefined, undefined, undefined)
          .subscribe((statistic) => {
            this.teilnahmeStatistic = statistic;
            this.loaded$.next(true);
          });
      }),
    );
  }

  get administrator(): boolean {
    return this.authService.isAdministratorSig();
  }

  get sekretariat(): boolean {
    return this.authService.isSekretariat();
  }

  exportMutationen(): void {
    this.anlassService.getMutationenForAnlassCsv(this.anlass);
  }

  exportTeilnehmer(): void {
    this.anlassService.getTeilnehmerForAnlassCsv(this.anlass, this.rotieren);
  }
  importTeilnehmer(): void {
    this.dialog.open(Upload, {
      data: this.anlass,
    });
  }
  importContestTeilnehmer(): void {
    this.dialog.open(ContestUpload, {
      data: this.anlass,
    });
  }

  teilnehmerRotieren(event: boolean): void {
    this.rotieren = event;
  }

  exportBenutzer(): void {
    this.anlassService.getBenutzerForAnlassCsv(this.anlass);
  }

  exportWertungsrichter(): void {
    this.anlassService.getWertungsrichterForAnlassCsv(this.anlass);
  }

  exportAnmeldeKontrolle(): void {
    this.anlassService.getAnmeldeKontrolleCsv(this.anlass);
  }

  getAbteilungenForAnlass(): void {
    this.ranglistenService.getAbteilungenForAnlass(this.anlass, this.selectedKategorie).subscribe((result) => {
      this.abteilungen = result;
    });
  }
  getAnlagenForAnlass(): void {
    this.ranglistenService
      .getAnlagenForAnlass(this.anlass, this.selectedKategorie, this.selectedAbteilung)
      .subscribe((result) => {
        this.anlagen = result;
      });
  }

  changeKategorie(event: KategorieEnum): void {
    console.log('Event: ', event);
    this.selectedKategorie = event;
    this.selectedAbteilung = undefined;
    this.selectedAnlage = undefined;
    this.getAbteilungenForAnlass();
  }
  changeAbteilung(event: AbteilungEnum): void {
    console.log('Event: ', event);
    this.selectedAbteilung = event;
    this.selectedAnlage = undefined;
    this.getAnlagenForAnlass();
  }
  changeAnlage(event: AnlageEnum): void {
    console.log('Event: ', event);
    this.selectedAnlage = event;
    // this.getAnlagenForAnlass();
  }

  get isButtonsDisabled(): boolean {
    if (this.selectedKategorie && this.selectedAbteilung && this.selectedAnlage) {
      return false;
    }
    return true;
  }
  lauflistenLoeschen(): void {
    this.hasError = false;
    this.ranglistenService
      .deleteLauflistenForAnlassAndKategorie(
        this.anlass,
        this.selectedKategorie,
        this.selectedAbteilung,
        this.selectedAnlage,
      )
      .pipe(takeUntil(this.lauflistenPDF$))
      .subscribe((result) => {
        console.error('result: ', result);
        if (!result || result === 'Success') {
          this.message = 'Löschen erfolgreich durchgeführt';
          this.hasError = false;
        } else {
          this.message = 'Löschen fehlgeschlagen';
          this.hasError = true;
        }
        this.lauflistenPDF$.next();
      });
  }

  lauflistenPDF(): void {
    this.hasError = false;
    this.ranglistenService
      .getLauflistenPdf(this.anlass, this.selectedKategorie, this.selectedAbteilung, this.selectedAnlage, this.onlyTi)
      .pipe(takeUntil(this.lauflistenPDF$))
      .subscribe((result) => {
        console.error('result: ', result);
        if (result === 'Success') {
          this.message = 'Listen erfolgreich generiert';
          this.hasError = false;
        } else {
          this.message = 'Listen generieren fehlgeschlagen';
          this.hasError = true;
        }
        this.lauflistenPDF$.next();
      });
  }

  refreshEinteilung(): void {
    this.refreshEmitter.emit(undefined);
  }

  toolSperrenClicked(checked: boolean): void {
    this.anlass = { ...this.anlass, toolSperren: checked } as IAnlass;
    this.anlassService.updateAnlass(this.anlass).subscribe((anlass) => (this.anlass = anlass));
  }
}
