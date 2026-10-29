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
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { Store } from '@ngrx/store';
import { finalize } from 'rxjs';
import type { IAnlass } from '../../core/model/IAnlass';
import type { IWertungsrichterSlot } from '../../core/model/IWertungsrichterSlot';
import { KategorieEnum } from '../../core/model/KategorieEnum';
import { isTiTuEnumEqual, TiTuEnum } from '../../core/model/TiTuEnum';
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
  id: FormControl<string>;
  egalSlot: FormControl<boolean>;
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
  selector: 'ztv-event-form',
  templateUrl: './event-form.component.html',
  styleUrls: ['./event-form.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [ReactiveFormsModule, RouterLink, MaterialModule],
  providers: [
    { provide: DateAdapter, useClass: EventDateAdapter },
    { provide: MAT_DATE_LOCALE, useValue: 'de-CH' },
  ],
})
export class EventFormComponent {
  private readonly formBuilder = inject(FormBuilder).nonNullable;
  private readonly anlassService = inject(AnlassService);
  private readonly authService = inject(AuthService);
  private readonly store = inject(Store);
  private readonly router = inject(Router);
  private readonly destroyRef = inject(DestroyRef);
  private readonly eventId = inject(ActivatedRoute).snapshot.paramMap.get('id');
  private existingEvent: IAnlass | null = null;

  protected readonly isEditing = Boolean(this.eventId);
  protected readonly isLoading = signal(this.isEditing);
  protected readonly returnLink = this.eventId ? ['/admin', this.eventId, 'admin'] : ['/anlaesse'];

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
      iban: [''],
      smQuali: [false],
      ausserkantonal: [false],
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

    if (this.eventId) {
      this.anlassService
        .getAnlaesse(false)
        .pipe(takeUntilDestroyed())
        .subscribe({
          next: (events) => {
            const event = events.find((candidate) => candidate.id === this.eventId);
            if (event) {
              this.loadEvent(event);
            } else {
              this.errorMessage.set('Der Anlass wurde nicht gefunden.');
            }
            this.isLoading.set(false);
          },
          error: () => {
            this.isLoading.set(false);
            this.errorMessage.set('Der Anlass konnte nicht geladen werden.');
          },
        });
    }
  }

  private loadEvent(event: IAnlass): void {
    this.existingEvent = event;
    this.form.patchValue(
      {
        anlassBezeichnung: event.anlassBezeichnung,
        ort: event.ort,
        halle: event.halle,
        organisatorId: event.organisatorId,
        iban: event.iban ?? '',
        smQuali: event.smQuali,
        ausserkantonal: event.ausserkantonal,
        tiTu: isTiTuEnumEqual(event.tiTu, TiTuEnum.Ti)
          ? 'Ti'
          : isTiTuEnumEqual(event.tiTu, TiTuEnum.Tu)
            ? 'Tu'
            : 'Alle',
        tiefsteKategorie: event.tiefsteKategorie,
        hoechsteKategorie: event.hoechsteKategorie,
        startDatum: event.startDatum,
        endDatum: event.endDatum,
        anmeldungBeginn: event.anmeldungBeginn,
        erfassenGeschlossen: event.erfassenGeschlossen,
        crossKategorieAenderungenGeschlossen: event.crossKategorieAenderungenGeschlossen,
        aenderungenInKategorieGeschlossen: event.aenderungenInKategorieGeschlossen,
        aenderungenNichtMehrErlaubt: event.aenderungenNichtMehrErlaubt,
      },
      { emitEvent: false },
    );
    this.form.controls.tiefsteKategorie.updateValueAndValidity();
    this.form.controls.hoechsteKategorie.updateValueAndValidity();
    const organizer = this.vereine().find((verein) => verein.id === event.organisatorId);
    this.organisatorSearch.setValue(organizer ?? '');
    const slots = this.form.controls.wertungsrichterSlots;
    slots.clear();
    for (const slot of event.wertungsrichterSlots ?? []) {
      slots.push(this.createSlotForm(slot));
    }
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

  private createSlotForm(slot?: IWertungsrichterSlot): WertungsrichterSlotForm {
    return this.formBuilder.group(
      {
        id: [slot?.id ?? ''],
        egalSlot: [slot?.egalSlot ?? false],
        brevet: [slot?.brevet ?? 1, [Validators.required, Validators.min(1), Validators.max(2)]],
        tag: this.formBuilder.control<Date | null>(slot?.tag ?? null, slot?.egalSlot ? [] : Validators.required),
        startzeit: [
          slot?.startzeit ? formatDate(slot.startzeit, 'HH:mm', 'en-US') : '',
          Validators.pattern(/^([01]\d|2[0-3]):[0-5]\d$/),
        ],
        endzeit: [
          slot?.endzeit ? formatDate(slot.endzeit, 'HH:mm', 'en-US') : '',
          Validators.pattern(/^([01]\d|2[0-3]):[0-5]\d$/),
        ],
        beschreibung: [slot?.beschreibung ?? ''],
      },
      { validators: validateSlotTimes },
    );
  }

  protected onSave(): void {
    if (this.isSaving() || this.isLoading() || (this.isEditing && !this.existingEvent)) {
      return;
    }
    this.form.markAllAsTouched();
    this.organisatorSearch.markAsTouched();
    if (this.form.invalid) {
      console.error('Ungültiges Anlassformular', {
        errors: this.form.errors,
        fields: Object.entries(this.form.controls)
          .filter(([, control]) => control.invalid)
          .map(([field, control]) => ({ field, errors: control.errors })),
        slots: this.form.controls.wertungsrichterSlots.controls.flatMap((slot, index) =>
          slot.invalid
            ? [
                {
                  index,
                  errors: slot.errors,
                  fields: Object.entries(slot.controls)
                    .filter(([, control]) => control.invalid)
                    .map(([field, control]) => ({ field, errors: control.errors })),
                },
              ]
            : [],
        ),
      });
      this.errorMessage.set('Bitte alle Pflichtfelder korrekt ausfüllen.');
      return;
    }
    this.isSaving.set(true);
    this.errorMessage.set('');
    const values = this.form.getRawValue();
    this.form.disable({ emitEvent: false });
    const input: CreateAnlass = {
      ...values,
      anlassBezeichnung: values.anlassBezeichnung.trim(),
      ort: values.ort.trim(),
      halle: values.halle.trim(),
      iban: values.iban.trim(),
      startDatum: toMidnightDateTime(values.startDatum),
      endDatum: toMidnightDateTime(values.endDatum),
      anmeldungBeginn: toMidnightDateTime(values.anmeldungBeginn),
      erfassenGeschlossen: toMidnightDateTime(values.erfassenGeschlossen),
      crossKategorieAenderungenGeschlossen: toMidnightDateTime(values.crossKategorieAenderungenGeschlossen),
      aenderungenInKategorieGeschlossen: toMidnightDateTime(values.aenderungenInKategorieGeschlossen),
      aenderungenNichtMehrErlaubt: toMidnightDateTime(values.aenderungenNichtMehrErlaubt),
      wertungsrichterSlots: values.wertungsrichterSlots.map((slot, index) => ({
        ...(this.isEditing && slot.id ? { id: slot.id } : {}),
        ...(this.isEditing ? { egalSlot: slot.egalSlot } : {}),
        reihenfolge: index + 1,
        brevet: slot.brevet,
        tag: slot.tag ? formatDate(slot.tag, 'yyyy-MM-dd', 'en-US') : '',
        start_zeit: slot.startzeit ? `${slot.startzeit}:00` : null,
        end_zeit: slot.endzeit ? `${slot.endzeit}:00` : null,
        beschreibung: slot.beschreibung.trim(),
      })),
    };
    const save$ = this.existingEvent
      ? this.anlassService.updateAnlass({
          ...this.existingEvent,
          ...input,
          id: this.existingEvent.id,
          published: this.existingEvent.published,
          aktiv: this.existingEvent.aktiv,
        })
      : this.anlassService.createAnlass(input);
    save$
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
          void this.router.navigate(this.returnLink);
        },
        error: () => {
          this.errorMessage.set('Der Anlass konnte nicht gespeichert werden. Bitte erneut versuchen.');
        },
      });
  }
}
