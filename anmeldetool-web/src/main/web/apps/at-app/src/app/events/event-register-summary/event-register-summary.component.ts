import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, computed, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { select, Store } from '@ngrx/store';
import { filter, map, switchMap } from 'rxjs';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import type { AnzeigeStatusEnum } from 'src/app/core/model/AnzeigeStatusEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';
import type { IUser } from 'src/app/core/model/IUser';
import { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { TiTuEnum } from 'src/app/core/model/TiTuEnum';
import { WertungsrichterStatusEnum } from 'src/app/core/model/WertungsrichterStatusEnum';
import { selectAnlassById } from 'src/app/core/redux/anlass';
import type { AppState } from 'src/app/core/redux/core.state';
import { selectVereinById } from 'src/app/core/redux/verein';
import { AnlassService } from 'src/app/core/service/anlass/anlass.service';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { WertungsrichterService } from 'src/app/core/service/wertungsrichter.service';
import type { IVerein } from 'src/app/verein/verein';

const EMPTY_ANLASS: IAnlass = {
  id: '',
  anzeigeStatus: { hasStatus: () => false },
  ausserkantonal: false,
  bank: '',
  endDatum: '',
  erfassenGeschlossen: '',
  getCleaned: () => '',
  halle: '',
  hoechsteKategorie: KategorieEnum.K1,
  iban: '',
  ort: '',
  startDatum: '',
  tiefsteKategorie: KategorieEnum.K1,
  tiTu: '' as TiTuEnum,
  zuGunsten: '',
} as unknown as IAnlass;

const EMPTY_SUMMARY: IAnlassSummary = {
  startet: false,
  startendeBr1: 0,
  startendeBr2: 0,
  startendeK1: 0,
  startendeK2: 0,
  startendeK3: 0,
  startendeK4: 0,
  startendeK5: 0,
  startendeK5A: 0,
  startendeK5B: 0,
  startendeK6: 0,
  startendeKD: 0,
  startendeKH: 0,
  startendeK7: 0,
} as unknown as IAnlassSummary;

const EMPTY_VEREIN: IVerein = {
  name: '',
} as unknown as IVerein;

@Component({
  selector: 'lxt-event-register-summary',
  templateUrl: './event-register-summary.component.html',
  styleUrls: ['./event-register-summary.component.css'],
  standalone: true,
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class EventRegisterSummaryComponent {
  private readonly authService = inject(AuthService);
  private readonly store = inject<Store<AppState>>(Store);
  private readonly anlassService = inject(AnlassService);
  private readonly wertungsrichterService = inject(WertungsrichterService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly angWindow = inject(Window);

  private readonly anlassIdSig = toSignal(this.route.paramMap.pipe(map((params) => params.get('id') ?? '')), {
    initialValue: '',
  });

  private readonly anlassSig = toSignal(
    toObservable(this.anlassIdSig).pipe(switchMap((anlassId) => this.store.pipe(select(selectAnlassById(anlassId))))),
    {
      initialValue: undefined as IAnlass | undefined,
    },
  );

  private readonly anlassSummarySig = toSignal(
    toObservable(this.anlassSig).pipe(
      filter((anlass): anlass is IAnlass => Boolean(anlass)),
      switchMap((anlass) => this.anlassService.getAnlassOrganisationSummary(anlass, this.authService.currentVerein)),
    ),
    {
      initialValue: undefined as IAnlassSummary | undefined,
    },
  );

  private readonly organisatorSig = toSignal(
    toObservable(this.anlassSig).pipe(
      filter((anlass): anlass is IAnlass => Boolean(anlass)),
      switchMap((anlass) => this.store.pipe(select(selectVereinById(anlass.organisatorId)))),
    ),
    {
      initialValue: undefined as IVerein | undefined,
    },
  );

  private readonly assignedWr1sSig = toSignal(
    toObservable(this.anlassSig).pipe(
      filter((anlass): anlass is IAnlass => Boolean(anlass)),
      switchMap((anlass) => this.wertungsrichterService.getEingeteilteWertungsrichter(anlass, 1)),
    ),
    {
      initialValue: [] as IUser[],
    },
  );

  private readonly assignedWr2sSig = toSignal(
    toObservable(this.anlassSig).pipe(
      filter((anlass): anlass is IAnlass => Boolean(anlass)),
      switchMap((anlass) => this.wertungsrichterService.getEingeteilteWertungsrichter(anlass, 2)),
    ),
    {
      initialValue: [] as IUser[],
    },
  );

  readonly titelSig = computed(() => {
    const anlass = this.anlassSig();
    const verein = this.authService.currentVerein;

    if (!anlass || !verein) {
      return '';
    }

    return `${anlass.getCleaned()} - ${verein.name}`;
  });

  readonly vereinStartedSig = computed(() => this.anlassSummarySig()?.startet ?? false);

  readonly totalTeilnehmerSig = computed(
    () => (this.anlassSummarySig()?.startendeBr1 ?? 0) + (this.anlassSummarySig()?.startendeBr2 ?? 0),
  );

  readonly hasTeilnehmerSig = computed(() => this.totalTeilnehmerSig() > 0);

  readonly statusWertungsrichterSig = computed(() =>
    this.wertungsrichterService.getStatusWertungsrichter(
      this.anlassSummarySig() ?? EMPTY_SUMMARY,
      this.assignedWr1sSig(),
      this.assignedWr2sSig(),
    ),
  );

  readonly isWertungsrichterOkSig = computed(() => {
    if (!this.hasTeilnehmerSig()) {
      return true;
    }

    const status = this.statusWertungsrichterSig();
    return status === WertungsrichterStatusEnum.OK || status === WertungsrichterStatusEnum.KEINEPFLICHT;
  });

  readonly brevet1AnlassSig = computed(() => (this.anlassSig() ?? EMPTY_ANLASS).tiefsteKategorie < KategorieEnum.K5);
  readonly brevet2AnlassSig = computed(() => (this.anlassSig() ?? EMPTY_ANLASS).hoechsteKategorie > KategorieEnum.K4);
  readonly tuAnlassSig = computed(() => {
    const tiTus = Object.keys(TiTuEnum);
    const tiTu = (this.anlassSig() ?? EMPTY_ANLASS).tiTu;

    return tiTus.indexOf(tiTu) === 1 || tiTus.indexOf(tiTu) === 2;
  });
  readonly tiAnlassSig = computed(() => {
    const tiTus = Object.keys(TiTuEnum);
    const tiTu = (this.anlassSig() ?? EMPTY_ANLASS).tiTu;

    return tiTus.indexOf(tiTu) === 0 || tiTus.indexOf(tiTu) === 2;
  });

  get anlass(): IAnlass {
    return this.anlassSig() ?? EMPTY_ANLASS;
  }

  get anlassSummary(): IAnlassSummary {
    return this.anlassSummarySig() ?? EMPTY_SUMMARY;
  }

  get organisator(): IVerein {
    return this.organisatorSig() ?? EMPTY_VEREIN;
  }

  get assignedWr1s(): IUser[] {
    return this.assignedWr1sSig();
  }

  get assignedWr2s(): IUser[] {
    return this.assignedWr2sSig();
  }

  print(): void {
    this.angWindow.print();
  }

  printWRs(): void {
    this.anlassService.getVereinWertungsrichterKontrollePdf(this.anlass, this.authService.currentVerein).subscribe();
  }

  get titel(): string {
    return this.titelSig();
  }

  get vereinStarted(): boolean {
    return this.vereinStartedSig();
  }

  getTeilnahmenForKategorieK1(): number {
    return this.anlassSummary.startendeK1;
  }

  getTeilnahmenForKategorieK2(): number {
    return this.anlassSummary.startendeK2;
  }

  getTeilnahmenForKategorieK3(): number {
    return this.anlassSummary.startendeK3;
  }

  getTeilnahmenForKategorieK4(): number {
    return this.anlassSummary.startendeK4;
  }

  getTeilnahmenForKategorieK5(): number {
    return this.anlassSummary.startendeK5;
  }

  getTeilnahmenForKategorieK5A(): number {
    return this.anlassSummary.startendeK5A;
  }

  getTeilnahmenForKategorieK5B(): number {
    return this.anlassSummary.startendeK5B;
  }

  getTeilnahmenForKategorieK6(): number {
    return this.anlassSummary.startendeK6;
  }

  getTeilnahmenForKategorieKD(): number {
    return this.anlassSummary.startendeKD;
  }

  getTeilnahmenForKategorieKH(): number {
    return this.anlassSummary.startendeKH;
  }

  getTeilnahmenForKategorieK7(): number {
    return this.anlassSummary.startendeK7;
  }

  get brevet1Anlass(): boolean {
    return this.brevet1AnlassSig();
  }

  get brevet2Anlass(): boolean {
    return this.brevet2AnlassSig();
  }

  get tuAnlass(): boolean {
    return this.tuAnlassSig();
  }

  get tiAnlass(): boolean {
    return this.tiAnlassSig();
  }

  isEnabled(): boolean {
    return true;
  }

  getClassForAnzeigeStatus(anzeigeStatus: AnzeigeStatusEnum): string {
    if (this.anlass.anzeigeStatus.hasStatus(anzeigeStatus)) {
      return 'div-red';
    }

    return 'div-green';
  }

  getStartedClass(): { redNoMargin?: boolean; greenNoMargin?: boolean } {
    if (!this.vereinStarted) {
      return { redNoMargin: true };
    }

    return { greenNoMargin: true };
  }

  get totalTeilnehmer(): number {
    return this.totalTeilnehmerSig();
  }

  get hasTeilnehmer(): boolean {
    return this.hasTeilnehmerSig();
  }

  getTeilnehmerClass(): { redNoMargin?: boolean; greenNoMargin?: boolean } {
    if (this.hasTeilnehmer) {
      return { greenNoMargin: true };
    }

    return { redNoMargin: true };
  }

  getWertungsrichterClass(): { redNoMargin?: boolean; greenNoMargin?: boolean } {
    if (this.hasTeilnehmer) {
      return { greenNoMargin: true };
    }

    return { redNoMargin: true };
  }

  handleClickMe(_event: PointerEvent): void {
    this.router.navigate(['/anlass/', this.anlass.id]);
  }

  vereinStartedClicked(event: PointerEvent): void {
    console.log(event);
  }

  get isWertungsrichterOk(): boolean {
    return this.isWertungsrichterOkSig();
  }

  get statusWertungsrichter(): WertungsrichterStatusEnum {
    return this.statusWertungsrichterSig();
  }
}
