import { ChangeDetectionStrategy, Component, DestroyRef, inject, input, type OnInit, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import {
  type ITimeplanVorschlag,
  TIMEPLAN_MAX_ABTEILUNGEN,
  TIMEPLAN_MAX_ANLAGEN,
  type TimeplanGeraet,
  type TimeplanTiTu,
} from 'src/app/core/model/ITimeplanVorschlag';
import { AnlassService } from 'src/app/core/service/anlass/anlass.service';
import { MaterialModule } from 'src/app/shared/material-module';

const GERAET_LABELS: Record<TimeplanGeraet, string> = {
  BODEN: 'Boden',
  RECK: 'Reck',
  SPRUNG: 'Sprung',
  SCHAUKELRINGE: 'Schaukelringe',
  BARREN: 'Barren',
};

const TITU_LABELS: Record<TimeplanTiTu, string> = {
  Ti: 'Turnerinnen',
  Tu: 'Turner',
};

@Component({
  selector: 'ztv-timeplan',
  templateUrl: './timeplan.component.html',
  styleUrls: ['./timeplan.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [FormsModule, MaterialModule],
})
export class TimeplanComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();

  readonly maxAnlagen = TIMEPLAN_MAX_ANLAGEN;
  readonly maxAbteilungen = TIMEPLAN_MAX_ABTEILUNGEN;

  readonly vorschlaege = signal<ITimeplanVorschlag[]>([]);
  readonly loading = signal(true);
  readonly saving = signal(false);
  readonly error = signal('');

  private readonly anlassService = inject(AnlassService);
  private readonly destroyRef = inject(DestroyRef);

  ngOnInit(): void {
    this.anlassService
      .getTimeplan(this.anlass().id)
      .pipe(
        finalize(() => this.loading.set(false)),
        takeUntilDestroyed(this.destroyRef),
      )
      .subscribe({
        next: (vorschlaege) => this.vorschlaege.set(vorschlaege),
        error: () => this.error.set('Timeplan konnte nicht geladen werden.'),
      });
  }

  updateMaxAnlagen(vorschlag: ITimeplanVorschlag, value: number): void {
    this.update(vorschlag, { maxAnlagen: value });
  }

  updateMaxAbteilungen(vorschlag: ITimeplanVorschlag, value: number): void {
    this.update(vorschlag, { maxAbteilungen: value });
  }

  isValid(): boolean {
    return this.vorschlaege().every(
      (v) =>
        Number.isInteger(v.maxAnlagen) &&
        v.maxAnlagen >= 1 &&
        v.maxAnlagen <= this.maxAnlagen &&
        Number.isInteger(v.maxAbteilungen) &&
        v.maxAbteilungen >= 1 &&
        v.maxAbteilungen <= this.maxAbteilungen,
    );
  }

  berechnen(): void {
    if (!this.isValid()) {
      return;
    }
    this.saving.set(true);
    this.error.set('');
    const inputs = this.vorschlaege().map(({ kategorie, tiTu, maxAnlagen, maxAbteilungen }) => ({
      kategorie,
      tiTu,
      maxAnlagen,
      maxAbteilungen,
    }));
    this.anlassService
      .saveTimeplan(this.anlass().id, inputs)
      .pipe(
        finalize(() => this.saving.set(false)),
        takeUntilDestroyed(this.destroyRef),
      )
      .subscribe({
        next: (vorschlaege) => this.vorschlaege.set(vorschlaege),
        error: () => this.error.set('Timeplan konnte nicht berechnet werden.'),
      });
  }

  tiTuLabel(tiTu: TimeplanTiTu): string {
    return TITU_LABELS[tiTu];
  }

  geraeteLabel(geraete: TimeplanGeraet[]): string {
    return geraete.map((geraet) => GERAET_LABELS[geraet]).join(', ');
  }

  gruppenGroesse(vorschlag: ITimeplanVorschlag): string {
    return vorschlag.gruppenGroesseMin === vorschlag.gruppenGroesseMax
      ? `${vorschlag.gruppenGroesseMax}`
      : `${vorschlag.gruppenGroesseMin}–${vorschlag.gruppenGroesseMax}`;
  }

  isVeraltet(vorschlag: ITimeplanVorschlag): boolean {
    return vorschlag.gespeichert && vorschlag.anzahlTeilnehmer !== vorschlag.aktuelleTeilnehmer;
  }

  private update(vorschlag: ITimeplanVorschlag, changes: Partial<ITimeplanVorschlag>): void {
    this.vorschlaege.update((vorschlaege) => vorschlaege.map((v) => (v === vorschlag ? { ...v, ...changes } : v)));
  }
}
