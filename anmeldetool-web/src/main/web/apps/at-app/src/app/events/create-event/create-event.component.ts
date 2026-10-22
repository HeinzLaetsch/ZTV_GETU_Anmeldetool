import { formatDate } from '@angular/common';
import { ChangeDetectionStrategy, Component, computed, DestroyRef, inject, signal } from '@angular/core';
import { takeUntilDestroyed, toSignal } from '@angular/core/rxjs-interop';
import {
  type AbstractControl,
  FormBuilder,
  type FormControl,
  type FormGroup,
  ReactiveFormsModule,
  type ValidationErrors,
  Validators,
} from '@angular/forms';
import { DateAdapter, MAT_DATE_LOCALE } from '@angular/material/core';
import type { MatAutocompleteSelectedEvent } from '@angular/material/autocomplete';
import { Router, RouterLink } from '@angular/router';
import { Store } from '@ngrx/store';
import { finalize } from 'rxjs';
import { KategorieEnum } from '../../core/model/KategorieEnum';
import { AnlassActions } from '../../core/redux/anlass/anlass.actions';
import { selectVereineSorted } from '../../core/redux/verein';
import { AnlassService, type CreateAnlass } from '../../core/service/anlass/anlass.service';
import { AuthService } from '../../core/service/auth/auth.service';
import { MaterialModule } from '../../shared/material-module';
import { EventDateAdapter } from './event-date-adapter';
import type { IVerein } from '../../verein/verein';

const DATE_FIELDS = [
  { name: 'startDatum', label: 'Beginn des Anlasses' },
  { name: 'endDatum', label: 'Ende des Anlasses' },
  { name: 'anmeldungBeginn', label: 'Anmeldebeginn' },
  { name: 'erfassenGeschlossen', label: 'Anmeldeschluss' },
  { name: 'crossKategorieAenderungenGeschlossen', label: 'Kategorienwechsel bis' },
  { name: 'aenderungenInKategorieGeschlossen', label: 'Änderungen innerhalb der Kategorie bis' },
  { name: 'aenderungenNichtMehrErlaubt', label: 'Letzte Änderungen bis' },
] as const;

type WertungsrichterSlotForm = FormGroup<{
  brevet: FormControl<number>;
  tag: FormControl<Date | null>;
  startzeit: FormControl<string>;
  endzeit: FormControl<string>;
  beschreibung: FormControl<string>;
}>;

function validateSlotTimes(control: AbstractControl): ValidationErrors | null {
  const start: unknown = control.get('startzeit')?.value;
  const end: unknown = control.get('endzeit')?.value;
  return typeof start === 'string' && typeof end === 'string' && start && end && end <= start
    ? { timeOrder: true }
    : null;
}

const DATE_VALIDATION_ORDER = [
  'anmeldungBeginn',
  'erfassenGeschlossen',
  'crossKategorieAenderungenGeschlossen',
  'aenderungenInKategorieGeschlossen',
  'aenderungenNichtMehrErlaubt',
  'startDatum',
  'endDatum',
] as const;

function validateAnlass(control: AbstractControl): ValidationErrors | null {
  let previousDate = '';
  for (const field of DATE_VALIDATION_ORDER) {
    const value: unknown = control.get(field)?.value;
    if (value instanceof Date && !Number.isNaN(value.getTime())) {
      const date = formatDate(value, 'yyyy-MM-dd', 'en-US');
      if (previousDate && date < previousDate) {
        return { dateOrder: true };
      }
      previousDate = date;
    }
  }
  const categories = Object.values(KategorieEnum);
  const lowest: KategorieEnum = control.get('tiefsteKategorie')?.value;
  const highest: KategorieEnum = control.get('hoechsteKategorie')?.value;
  return categories.indexOf(lowest) > categories.indexOf(highest) ? { categoryOrder: true } : null;
}

function toMidnightDateTime(value: Date | null): string {
  return value ? formatDate(value, "yyyy-MM-dd'T'00:00:00", 'en-US') : '';
}

@Component({
  selector: 'ztv-create-event',
  templateUrl: './create-event.component.html',
  styleUrls: ['./create-event.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [ReactiveFormsModule, RouterLink, MaterialModule],
  providers: [
    { provide: DateAdapter, useClass: EventDateAdapter },
    { provide: MAT_DATE_LOCALE, useValue: 'de-CH' },
  ],
})
export class CreateEventComponent {
  private readonly formBuilder = inject(FormBuilder).nonNullable;
  private readonly anlassService = inject(AnlassService);
  private readonly authService = inject(AuthService);
  private readonly store = inject(Store);
  private readonly router = inject(Router);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly vereine = this.store.selectSignal(selectVereineSorted());
  protected readonly organisatorSearch = this.formBuilder.control<IVerein | string>(
    this.authService.currentVerein ?? '',
    [
      Validators.required,
      (control: AbstractControl): ValidationErrors | null =>
        typeof control.value === 'string' ? { selectionRequired: true } : null,
    ],
  );
  private readonly organisatorSearchValue = toSignal(this.organisatorSearch.valueChanges, {
    initialValue: this.organisatorSearch.value,
  });
  protected readonly filteredOrganisatoren = computed(() => {
    const value = this.organisatorSearchValue();
    const search = typeof value === 'string' ? value.trim().toLocaleLowerCase() : '';
    return this.vereine().filter((verein) => verein.name.toLocaleLowerCase().includes(search));
  });
  protected readonly dateFields = DATE_FIELDS;
  protected readonly kategorien: KategorieEnum[] = Object.values(KategorieEnum).filter(
    (category) => category !== KategorieEnum.KEINE_TEILNAHME && category !== KategorieEnum.KEIN_START,
  );
  protected readonly isSaving = signal(false);
  protected readonly errorMessage = signal('');
  protected readonly form = this.formBuilder.group(
    {
      anlassBezeichnung: ['', [Validators.required, Validators.pattern(/\S/)]],
      ort: ['', [Validators.required, Validators.pattern(/\S/)]],
      halle: ['', [Validators.required, Validators.pattern(/\S/)]],
      organisatorId: [this.authService.currentVerein?.id ?? '', Validators.required],
      tiTu: this.formBuilder.control<CreateAnlass['tiTu']>('Alle', Validators.required),
      tiefsteKategorie: [KategorieEnum.K1, Validators.required],
      hoechsteKategorie: [KategorieEnum.K7, Validators.required],
      startDatum: this.formBuilder.control<Date | null>(null, Validators.required),
      endDatum: this.formBuilder.control<Date | null>(null, Validators.required),
      anmeldungBeginn: this.formBuilder.control<Date | null>(null, Validators.required),
      erfassenGeschlossen: this.formBuilder.control<Date | null>(null, Validators.required),
      crossKategorieAenderungenGeschlossen: this.formBuilder.control<Date | null>(
        { value: null, disabled: true },
        Validators.required,
      ),
      aenderungenInKategorieGeschlossen: this.formBuilder.control<Date | null>(
        { value: null, disabled: true },
        Validators.required,
      ),
      aenderungenNichtMehrErlaubt: this.formBuilder.control<Date | null>(null, Validators.required),
      wertungsrichterSlots: this.formBuilder.array([this.createSlotForm()], Validators.required),
    },
    { validators: validateAnlass },
  );

  private readonly lowestCategory = toSignal(this.form.controls.tiefsteKategorie.valueChanges, {
    initialValue: this.form.controls.tiefsteKategorie.value,
  });
  private readonly highestCategory = toSignal(this.form.controls.hoechsteKategorie.valueChanges, {
    initialValue: this.form.controls.hoechsteKategorie.value,
  });
  protected readonly tiefsteKategorien = computed(() =>
    this.kategorien.slice(0, this.kategorien.indexOf(this.highestCategory()) + 1),
  );
  protected readonly hoechsteKategorien = computed(() =>
    this.kategorien.slice(this.kategorien.indexOf(this.lowestCategory())),
  );

  constructor() {
    this.form.controls.erfassenGeschlossen.valueChanges
      .pipe(takeUntilDestroyed())
      .subscribe((value) => this.form.controls.crossKategorieAenderungenGeschlossen.setValue(value));
    this.form.controls.aenderungenNichtMehrErlaubt.valueChanges
      .pipe(takeUntilDestroyed())
      .subscribe((value) => this.form.controls.aenderungenInKategorieGeschlossen.setValue(value));
  }

  protected displayOrganisator(value: IVerein | string | null): string {
    return typeof value === 'string' ? value : (value?.name ?? '');
  }

  protected onOrganisatorSelected(event: MatAutocompleteSelectedEvent): void {
    const verein = event.option.value as IVerein;
    this.form.controls.organisatorId.setValue(verein.id);
  }

  protected onOrganisatorSearchOpened(): void {
    this.organisatorSearch.setValue('');
  }

  protected onOrganisatorSearchClosed(): void {
    const selectedId = this.form.controls.organisatorId.value;
    const selected = this.vereine().find((verein) => verein.id === selectedId);
    this.organisatorSearch.setValue(selected ?? '');
  }

  protected onAddSlot(): void {
    if (!this.isSaving()) {
      this.form.controls.wertungsrichterSlots.push(this.createSlotForm());
    }
  }

  protected onRemoveSlot(index: number): void {
    const slots = this.form.controls.wertungsrichterSlots;
    if (!this.isSaving() && slots.length > 1) {
      slots.removeAt(index);
    }
  }

  private createSlotForm(): WertungsrichterSlotForm {
    return this.formBuilder.group(
      {
        brevet: [1, [Validators.required, Validators.min(1), Validators.max(2)]],
        tag: this.formBuilder.control<Date | null>(null, Validators.required),
        startzeit: ['', Validators.pattern(/^([01]\d|2[0-3]):[0-5]\d$/)],
        endzeit: ['', Validators.pattern(/^([01]\d|2[0-3]):[0-5]\d$/)],
        beschreibung: [''],
      },
      { validators: validateSlotTimes },
    );
  }

  protected onSave(): void {
    if (this.isSaving()) {
      return;
    }
    this.form.markAllAsTouched();
    this.organisatorSearch.markAsTouched();
    if (this.form.invalid) {
      return;
    }
    this.isSaving.set(true);
    this.errorMessage.set('');
    const values = this.form.getRawValue();
    this.form.disable({ emitEvent: false });
    this.anlassService
      .createAnlass({
        ...values,
        anlassBezeichnung: values.anlassBezeichnung.trim(),
        ort: values.ort.trim(),
        halle: values.halle.trim(),
        startDatum: toMidnightDateTime(values.startDatum),
        endDatum: toMidnightDateTime(values.endDatum),
        anmeldungBeginn: toMidnightDateTime(values.anmeldungBeginn),
        erfassenGeschlossen: toMidnightDateTime(values.erfassenGeschlossen),
        crossKategorieAenderungenGeschlossen: toMidnightDateTime(values.crossKategorieAenderungenGeschlossen),
        aenderungenInKategorieGeschlossen: toMidnightDateTime(values.aenderungenInKategorieGeschlossen),
        aenderungenNichtMehrErlaubt: toMidnightDateTime(values.aenderungenNichtMehrErlaubt),
        wertungsrichterSlots: values.wertungsrichterSlots.map((slot, index) => ({
          reihenfolge: index + 1,
          brevet: slot.brevet,
          tag: slot.tag ? formatDate(slot.tag, 'yyyy-MM-dd', 'en-US') : '',
          start_zeit: slot.startzeit ? `${slot.startzeit}:00` : null,
          end_zeit: slot.endzeit ? `${slot.endzeit}:00` : null,
          beschreibung: slot.beschreibung.trim(),
        })),
      })
      .pipe(
        takeUntilDestroyed(this.destroyRef),
        finalize(() => {
          this.isSaving.set(false);
          this.form.enable({ emitEvent: false });
          this.form.controls.crossKategorieAenderungenGeschlossen.disable({ emitEvent: false });
          this.form.controls.aenderungenInKategorieGeschlossen.disable({ emitEvent: false });
        }),
      )
      .subscribe({
        next: () => {
          this.store.dispatch(AnlassActions.loadAllAnlaesseInvoked());
          void this.router.navigate(['/anlaesse']);
        },
        error: () => {
          this.errorMessage.set('Der Anlass konnte nicht gespeichert werden. Bitte erneut versuchen.');
        },
      });
  }
}
