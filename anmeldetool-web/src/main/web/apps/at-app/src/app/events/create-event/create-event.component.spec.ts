import { TestbedHarnessEnvironment } from '@angular/cdk/testing/testbed';
import { type Signal, signal } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { MatAutocompleteHarness } from '@angular/material/autocomplete/testing';
import { MatDatepickerInputHarness } from '@angular/material/datepicker/testing';
import { MatSelectHarness } from '@angular/material/select/testing';
import { provideRouter, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { of, Subject, throwError } from 'rxjs';
import { vi } from 'vitest';
import { IAnlass } from '../../core/model/IAnlass';
import { AnlassActions } from '../../core/redux/anlass/anlass.actions';
import { AnlassService } from '../../core/service/anlass/anlass.service';
import { AuthService } from '../../core/service/auth/auth.service';
import { CreateEventComponent } from './create-event.component';

describe('CreateEventComponent', () => {
  let fixture: ComponentFixture<CreateEventComponent>;
  let root: HTMLElement;
  const createAnlass = vi.fn();
  const dispatch = vi.fn();
  const verein = { id: 'verein-id', name: 'Testverein', verbandId: 'verband-id' };
  const winterthur = { ...verein, id: 'winterthur-id', name: 'TV Winterthur' };
  const zurich = { ...verein, id: 'zurich-id', name: 'TV Zürich' };

  beforeEach(async () => {
    vi.clearAllMocks();
    createAnlass.mockReturnValue(of(new IAnlass({ id: 'new-id' })));
    await TestBed.configureTestingModule({
      imports: [CreateEventComponent],
      providers: [
        provideRouter([]),
        { provide: AnlassService, useValue: { createAnlass } },
        { provide: AuthService, useValue: { currentVerein: verein } },
        {
          provide: Store,
          useValue: { selectSignal: (): Signal<(typeof verein)[]> => signal([verein, winterthur, zurich]), dispatch },
        },
      ],
    }).compileComponents();
    vi.spyOn(TestBed.inject(Router), 'navigate').mockResolvedValue(true);
    fixture = TestBed.createComponent(CreateEventComponent);
    root = fixture.nativeElement;
    fixture.detectChanges();
    await fixture.whenStable();
    fixture.detectChanges();
  });

  function fillInput(name: string, value: string): void {
    const input = root.querySelector<HTMLInputElement>(`input[name="${name}"]`);
    if (!input) {
      throw new Error(`Missing input: ${name}`);
    }
    input.value = value;
    input.dispatchEvent(new Event('input', { bubbles: true }));
  }

  function fillValidForm(): void {
    fillInput('anlassBezeichnung', ' Testanlass ');
    fillInput('ort', 'Zürich');
    fillInput('halle', 'Turnhalle');
    fillInput('anmeldungBeginn', '2027-01-01');
    fillInput('erfassenGeschlossen', '2027-02-01');
    fillInput('aenderungenNichtMehrErlaubt', '2027-02-04');
    fillInput('startDatum', '2027-03-01');
    fillInput('endDatum', '2027-03-02');
    fixture.detectChanges();
    fillSlot(0);
  }

  function fillSlot(index: number): void {
    fillInput(`slot-tag-${index}`, '01.03.2027');
    fillInput(`slot-startzeit-${index}`, '08:00');
    fillInput(`slot-endzeit-${index}`, '12:00');
    fillInput(`slot-beschreibung-${index}`, ` Einsatz ${index + 1} `);
  }

  function clickButton(label: string): void {
    const button = Array.from(root.querySelectorAll<HTMLButtonElement>('button')).find(
      (candidate) => candidate.getAttribute('aria-label') === label || candidate.textContent?.includes(label),
    );
    if (!button) {
      throw new Error(`Missing button: ${label}`);
    }
    button.click();
    fixture.detectChanges();
  }

  function submit(): void {
    fixture.detectChanges();
    root.querySelector('form')?.dispatchEvent(new Event('submit', { bubbles: true, cancelable: true }));
    fixture.detectChanges();
  }

  function categorySelect(name: string): Promise<MatSelectHarness> {
    return TestbedHarnessEnvironment.loader(fixture).getHarness(
      MatSelectHarness.with({ selector: `[formControlName="${name}"]` }),
    );
  }

  it('only offers the lowest selected category and higher categories as the upper bound', async () => {
    const lowest = await categorySelect('tiefsteKategorie');
    await lowest.open();
    await lowest.clickOptions({ text: 'K3' });

    const highest = await categorySelect('hoechsteKategorie');
    await highest.open();
    const options = await highest.getOptions();
    expect(await Promise.all(options.map((option) => option.getText()))).toEqual([
      'K3',
      'K4',
      'K5',
      'K5A',
      'K5B',
      'K6',
      'KD',
      'KH',
      'K7',
    ]);
  });

  it('only offers categories up to the selected upper bound as the lower bound', async () => {
    const highest = await categorySelect('hoechsteKategorie');
    await highest.open();
    await highest.clickOptions({ text: 'K3' });

    const lowest = await categorySelect('tiefsteKategorie');
    await lowest.open();
    const options = await lowest.getOptions();
    expect(await Promise.all(options.map((option) => option.getText()))).toEqual(['K1', 'K2', 'K3']);
  });

  it('allows saving a single-category range with equal bounds', async () => {
    const lowest = await categorySelect('tiefsteKategorie');
    await lowest.open();
    await lowest.clickOptions({ text: 'K3' });
    const highest = await categorySelect('hoechsteKategorie');
    await highest.open();
    await highest.clickOptions({ text: 'K3' });

    fillValidForm();
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({ tiefsteKategorie: 'K3', hoechsteKategorie: 'K3' }),
    );
  });

  it('restores options when the lower bound is reduced again', async () => {
    const lowest = await categorySelect('tiefsteKategorie');
    await lowest.open();
    await lowest.clickOptions({ text: 'K3' });
    await lowest.open();
    await lowest.clickOptions({ text: 'K1' });

    const highest = await categorySelect('hoechsteKategorie');
    await highest.open();
    const options = await highest.getOptions();
    expect(await Promise.all(options.map((option) => option.getText()))).toEqual([
      'K1',
      'K2',
      'K3',
      'K4',
      'K5',
      'K5A',
      'K5B',
      'K6',
      'KD',
      'KH',
      'K7',
    ]);
  });

  it('shows the creation form', () => {
    expect(root.querySelector('h1')?.textContent).toContain('Neuen Anlass erstellen');
    expect(root.querySelector<HTMLInputElement>('[name="organisatorSearch"]')?.value).toBe('Testverein');
  });

  it('filters organizer options on each input, ignoring case and surrounding whitespace', async () => {
    const search = await TestbedHarnessEnvironment.loader(fixture).getHarness(MatAutocompleteHarness);
    await search.focus();
    expect(await search.getOptions()).toHaveLength(3);
    await search.enterText('tv');
    expect(await search.getOptions()).toHaveLength(3);
    await search.enterText('tv w');
    expect(await Promise.all((await search.getOptions()).map((option) => option.getText()))).toEqual(['TV Winterthur']);
    await search.enterText('  ZÜR  ');
    expect(await Promise.all((await search.getOptions()).map((option) => option.getText()))).toEqual(['TV Zürich']);
    fillInput('organisatorSearch', '');
    fixture.detectChanges();
    expect(await search.getOptions()).toHaveLength(3);
  });

  it('shows an empty result when the organizer search has no matches', async () => {
    const search = await TestbedHarnessEnvironment.loader(fixture).getHarness(MatAutocompleteHarness);
    await search.enterText('no-matching-club');
    const options = await search.getOptions();
    expect(options).toHaveLength(1);
    expect(await options[0].getText()).toBe('Kein Verein gefunden');
    expect(await options[0].isDisabled()).toBe(true);
  });

  it('saves the ID of an organizer selected from the filtered results', async () => {
    fillValidForm();
    const search = await TestbedHarnessEnvironment.loader(fixture).getHarness(MatAutocompleteHarness);
    await search.enterText('winter');
    await search.selectOption({ text: 'TV Winterthur' });
    expect(await search.getValue()).toBe('TV Winterthur');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(expect.objectContaining({ organisatorId: winterthur.id }));
  });

  it('keeps the previous organizer when a search is closed without selecting a result', async () => {
    fillValidForm();
    const search = await TestbedHarnessEnvironment.loader(fixture).getHarness(MatAutocompleteHarness);
    await search.enterText('winter');
    await search.blur();
    root.querySelector('h1')?.click();
    await fixture.whenStable();
    fixture.detectChanges();
    expect(await search.getValue()).toBe('Testverein');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(expect.objectContaining({ organisatorId: verein.id }));
  });

  it('displays the event dates before the registration deadlines in the requested order', () => {
    const labels = root.querySelectorAll('fieldset:nth-of-type(2) mat-label');
    expect(Array.from(labels, (label) => label.textContent?.trim())).toEqual([
      'Beginn des Anlasses',
      'Ende des Anlasses',
      'Anmeldebeginn',
      'Anmeldeschluss',
      'Kategorienwechsel bis',
      'Änderungen innerhalb der Kategorie bis',
      'Letzte Änderungen bis',
    ]);
  });

  it('does not save incomplete required fields', () => {
    submit();
    expect(createAnlass).not.toHaveBeenCalled();
    expect(root.textContent).toContain('Bitte ausfüllen.');
  });

  it('provides a calendar picker for all seven date fields', async () => {
    const loader = TestbedHarnessEnvironment.loader(fixture);
    expect(
      await loader.getAllHarnesses(MatDatepickerInputHarness.with({ selector: 'fieldset:nth-of-type(2) input' })),
    ).toHaveLength(7);
    expect(root.querySelector('input[type="datetime-local"]')).toBeNull();
    fillValidForm();
    fillInput('endDatum', '2027-03-16');
    const startDate = await loader.getHarness(MatDatepickerInputHarness.with({ selector: '[name="startDatum"]' }));
    await startDate.openCalendar();
    const calendar = await startDate.getCalendar();
    await calendar.selectCell({ text: '15' });
    fillInput('slot-tag-0', '15.03.2027');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(expect.objectContaining({ startDatum: '2027-03-15T00:00:00' }));
  });

  it('serializes every date at local midnight without shifting the selected day', () => {
    fillValidForm();
    fillInput('startDatum', '2027-03-01T17:43:12');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        startDatum: '2027-03-01T00:00:00',
        endDatum: '2027-03-02T00:00:00',
        anmeldungBeginn: '2027-01-01T00:00:00',
        erfassenGeschlossen: '2027-02-01T00:00:00',
        crossKategorieAenderungenGeschlossen: '2027-02-01T00:00:00',
        aenderungenInKategorieGeschlossen: '2027-02-04T00:00:00',
        aenderungenNichtMehrErlaubt: '2027-02-04T00:00:00',
      }),
    );
  });

  it('rejects invalid date input', () => {
    fillValidForm();
    fillInput('startDatum', 'not-a-date');
    submit();
    expect(createAnlass).not.toHaveBeenCalled();
    expect(root.textContent).toContain('Bitte ein gültiges Datum angeben.');
  });

  it('keeps the within-category deadline disabled and copies changes immediately without blur', () => {
    const target = root.querySelector<HTMLInputElement>('[name="aenderungenInKategorieGeschlossen"]');
    expect(target?.disabled).toBe(true);
    for (const value of ['22.10.2026', '23.10.2026', '']) {
      fillInput('aenderungenNichtMehrErlaubt', value);
      fixture.detectChanges();
      expect(target?.value).toBe(value);
      expect(target?.disabled).toBe(true);
    }
  });

  it('keeps the category-change deadline disabled and copies the registration deadline immediately', () => {
    const target = root.querySelector<HTMLInputElement>('[name="crossKategorieAenderungenGeschlossen"]');
    expect(target?.disabled).toBe(true);
    for (const value of ['22.10.2026', '23.10.2026', '']) {
      fillInput('erfassenGeschlossen', value);
      fixture.detectChanges();
      expect(target?.value).toBe(value);
      expect(target?.disabled).toBe(true);
    }
  });

  it('clears the category-change deadline when the registration deadline becomes invalid', () => {
    fillInput('erfassenGeschlossen', '22.10.2026');
    fillInput('erfassenGeschlossen', 'not-a-date');
    fixture.detectChanges();
    expect(root.querySelector<HTMLInputElement>('[name="crossKategorieAenderungenGeschlossen"]')?.value).toBe('');
  });

  it('copies the registration calendar selection into the disabled category-change deadline and payload', async () => {
    fillValidForm();
    const source = await TestbedHarnessEnvironment.loader(fixture).getHarness(
      MatDatepickerInputHarness.with({ selector: '[name="erfassenGeschlossen"]' }),
    );
    await source.openCalendar();
    const calendar = await source.getCalendar();
    await calendar.selectCell({ text: '3' });
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        erfassenGeschlossen: '2027-02-03T00:00:00',
        crossKategorieAenderungenGeschlossen: '2027-02-03T00:00:00',
      }),
    );
  });

  it('clears the copied deadline when the source date becomes invalid', () => {
    fillInput('aenderungenNichtMehrErlaubt', '22.10.2026');
    fillInput('aenderungenNichtMehrErlaubt', 'not-a-date');
    fixture.detectChanges();
    expect(root.querySelector<HTMLInputElement>('[name="aenderungenInKategorieGeschlossen"]')?.value).toBe('');
  });

  it('copies a calendar selection and includes the disabled deadline in the saved payload', async () => {
    fillValidForm();
    const source = await TestbedHarnessEnvironment.loader(fixture).getHarness(
      MatDatepickerInputHarness.with({ selector: '[name="aenderungenNichtMehrErlaubt"]' }),
    );
    await source.openCalendar();
    const calendar = await source.getCalendar();
    await calendar.selectCell({ text: '5' });
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        aenderungenInKategorieGeschlossen: '2027-02-05T00:00:00',
        aenderungenNichtMehrErlaubt: '2027-02-05T00:00:00',
      }),
    );
  });

  it('recognizes manually entered Swiss dates in every date field', () => {
    fillValidForm();
    fillInput('startDatum', '22.10.2026');
    fillInput('endDatum', '23.10.2026');
    fillInput('anmeldungBeginn', '01.08.2026');
    fillInput('erfassenGeschlossen', '01.09.2026');
    fillInput('aenderungenNichtMehrErlaubt', '04.09.2026');
    fillInput('slot-tag-0', '22.10.2026');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        startDatum: '2026-10-22T00:00:00',
        endDatum: '2026-10-23T00:00:00',
        anmeldungBeginn: '2026-08-01T00:00:00',
        erfassenGeschlossen: '2026-09-01T00:00:00',
        crossKategorieAenderungenGeschlossen: '2026-09-01T00:00:00',
        aenderungenInKategorieGeschlossen: '2026-09-04T00:00:00',
        aenderungenNichtMehrErlaubt: '2026-09-04T00:00:00',
      }),
    );
  });

  it('interprets an ambiguous date as day-month-year rather than month-day-year', () => {
    fillValidForm();
    fillInput('startDatum', '03.04.2027');
    fillInput('endDatum', '04.04.2027');
    fillInput('slot-tag-0', '03.04.2027');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(expect.objectContaining({ startDatum: '2027-04-03T00:00:00' }));
  });

  it('accepts single-digit days and months and surrounding whitespace', () => {
    fillValidForm();
    fillInput('startDatum', ' 1.3.2027 ');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(expect.objectContaining({ startDatum: '2027-03-01T00:00:00' }));
  });

  it.each(['31.02.2027', '29.02.2027', '31.04.2027', '22.13.2027'])(
    'rejects the invalid calendar date %s without rolling it over',
    (value) => {
      fillValidForm();
      fillInput('startDatum', value);
      submit();
      expect(createAnlass).not.toHaveBeenCalled();
      expect(root.textContent).toContain('Bitte ein gültiges Datum angeben.');
    },
  );

  it('accepts February 29 in a leap year', () => {
    fillValidForm();
    fillInput('startDatum', '29.02.2028');
    fillInput('endDatum', '01.03.2028');
    fillInput('slot-tag-0', '29.02.2028');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(expect.objectContaining({ startDatum: '2028-02-29T00:00:00' }));
  });

  it('saves trimmed values, reloads events and returns to the list', () => {
    fillValidForm();
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        anlassBezeichnung: 'Testanlass',
        organisatorId: verein.id,
        tiTu: 'Alle',
        startDatum: '2027-03-01T00:00:00',
      }),
    );
    expect(dispatch).toHaveBeenCalledWith(AnlassActions.loadAllAnlaesseInvoked());
    expect(TestBed.inject(Router).navigate).toHaveBeenCalledWith(['/anlaesse']);
  });

  it('rejects dates in the wrong order', () => {
    fillValidForm();
    fillInput('endDatum', '2027-01-01');
    submit();
    expect(createAnlass).not.toHaveBeenCalled();
    expect(root.textContent).toContain('zeitlicher Reihenfolge');
  });

  it('rejects registration deadlines after the event begins regardless of display order', () => {
    fillValidForm();
    fillInput('aenderungenNichtMehrErlaubt', '2027-03-02');
    submit();
    expect(createAnlass).not.toHaveBeenCalled();
    expect(root.textContent).toContain('zeitlicher Reihenfolge');
  });

  it('preserves entered values and shows an error when saving fails', () => {
    createAnlass.mockReturnValue(throwError(() => new Error('Server unavailable')));
    fillValidForm();
    submit();
    expect(root.querySelector('[role="alert"]')?.textContent).toContain('nicht gespeichert');
    expect(root.querySelector<HTMLInputElement>('[name="ort"]')?.value).toBe('Zürich');
    expect(dispatch).not.toHaveBeenCalled();
    const target = root.querySelector<HTMLInputElement>('[name="aenderungenInKategorieGeschlossen"]');
    expect(target?.disabled).toBe(true);
    fillInput('aenderungenNichtMehrErlaubt', '22.02.2027');
    fixture.detectChanges();
    expect(target?.value).toBe('22.2.2027');
    expect(target?.disabled).toBe(true);
    const categoryChange = root.querySelector<HTMLInputElement>('[name="crossKategorieAenderungenGeschlossen"]');
    expect(categoryChange?.disabled).toBe(true);
    fillInput('erfassenGeschlossen', '21.02.2027');
    fixture.detectChanges();
    expect(categoryChange?.value).toBe('21.2.2027');
    expect(categoryChange?.disabled).toBe(true);
  });

  it('prevents duplicate requests while saving', () => {
    const response = new Subject<IAnlass>();
    createAnlass.mockReturnValue(response);
    fillValidForm();
    submit();
    submit();
    expect(createAnlass).toHaveBeenCalledTimes(1);
    expect(root.querySelector<HTMLButtonElement>('button[type="submit"]')?.disabled).toBe(true);
    response.complete();
  });

  it('starts with one required slot and does not allow removing the last slot', () => {
    const remove = root.querySelector<HTMLButtonElement>('[aria-label="Slot 1 entfernen"]');
    expect(remove?.disabled).toBe(true);
    clickButton('Slot 1 entfernen');
    expect(root.querySelectorAll('.slot-row')).toHaveLength(1);
    fillValidForm();
    fillInput('slot-tag-0', '');
    submit();
    expect(createAnlass).not.toHaveBeenCalled();
  });

  it('saves multiple slots with date-only days, time-only values and sequential order', async () => {
    fillValidForm();
    clickButton('Slot hinzufügen');
    fillSlot(1);
    const brevet = await TestbedHarnessEnvironment.loader(fixture).getHarness(
      MatSelectHarness.with({ selector: '[aria-label="Slot 2"] mat-select' }),
    );
    await brevet.open();
    await brevet.clickOptions({ text: 'Brevet 2' });
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        wertungsrichterSlots: [
          {
            reihenfolge: 1,
            brevet: 1,
            tag: '2027-03-01',
            start_zeit: '08:00:00',
            end_zeit: '12:00:00',
            beschreibung: 'Einsatz 1',
          },
          {
            reihenfolge: 2,
            brevet: 2,
            tag: '2027-03-01',
            start_zeit: '08:00:00',
            end_zeit: '12:00:00',
            beschreibung: 'Einsatz 2',
          },
        ],
      }),
    );
  });

  it('labels the optional description field as Kommentar', () => {
    const labels = Array.from(root.querySelectorAll('.slot-row mat-label'), (label) => label.textContent?.trim());
    expect(labels).toContain('Kommentar');
    expect(labels).not.toContain('Beschreibung');
    for (const name of ['slot-startzeit-0', 'slot-endzeit-0', 'slot-beschreibung-0']) {
      expect(root.querySelector<HTMLInputElement>(`[name="${name}"]`)?.required).toBe(false);
    }
  });

  it.each([
    { start: '', end: '', expectedStart: null, expectedEnd: null },
    { start: '08:00', end: '', expectedStart: '08:00:00', expectedEnd: null },
    { start: '', end: '12:00', expectedStart: null, expectedEnd: '12:00:00' },
  ])('saves a slot with optional times: $start / $end and an empty comment', (values) => {
    fillValidForm();
    fillInput('slot-startzeit-0', values.start);
    fillInput('slot-endzeit-0', values.end);
    fillInput('slot-beschreibung-0', ' ');
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        wertungsrichterSlots: [
          expect.objectContaining({
            start_zeit: values.expectedStart,
            end_zeit: values.expectedEnd,
            beschreibung: '',
          }),
        ],
      }),
    );
  });

  it('removes a slot and renumbers the remaining slots when saving', () => {
    fillValidForm();
    clickButton('Slot hinzufügen');
    fillSlot(1);
    clickButton('Slot 1 entfernen');
    expect(root.querySelectorAll('.slot-row')).toHaveLength(1);
    submit();
    expect(createAnlass).toHaveBeenCalledWith(
      expect.objectContaining({
        wertungsrichterSlots: [expect.objectContaining({ reihenfolge: 1, beschreibung: 'Einsatz 2' })],
      }),
    );
  });

  it.each(['08:00', '07:59'])('rejects an invalid slot end time of %s', (time) => {
    fillValidForm();
    fillInput('slot-endzeit-0', time);
    submit();
    expect(createAnlass).not.toHaveBeenCalled();
    expect(root.textContent).toContain('Die Endzeit muss nach der Startzeit liegen.');
  });

  it.each(['28.02.2027', '03.03.2027'])('rejects a slot day outside the event: %s', (day) => {
    fillValidForm();
    fillInput('slot-tag-0', day);
    submit();
    expect(createAnlass).not.toHaveBeenCalled();
    expect(root.textContent).toContain('Bitte ein Datum innerhalb des Anlasses angeben.');
  });
});
