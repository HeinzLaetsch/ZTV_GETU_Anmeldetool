import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { of } from 'rxjs';
import { vi } from 'vitest';
import { IAnlass } from '../../core/model/IAnlass';
import type { ITimeplanVorschlag } from '../../core/model/ITimeplanVorschlag';
import { KategorieEnum } from '../../core/model/KategorieEnum';
import { AnlassService } from '../../core/service/anlass/anlass.service';
import { TimeplanComponent } from './timeplan.component';

describe('TimeplanComponent', () => {
  let fixture: ComponentFixture<TimeplanComponent>;
  let root: HTMLElement;
  const getTimeplan = vi.fn();
  const saveTimeplan = vi.fn();

  const vorschlag: ITimeplanVorschlag = {
    kategorie: KategorieEnum.K1,
    tiTu: 'Ti',
    maxAnlagen: 6,
    maxAbteilungen: 8,
    anzahlTeilnehmer: 90,
    aktuelleTeilnehmer: 95,
    anzahlGruppen: 10,
    gruppenGroesseMin: 9,
    gruppenGroesseMax: 9,
    anzahlAnlagen: 3,
    anzahlAbteilungen: 1,
    gruppenProAnlage: 4,
    geraete: ['BODEN', 'RECK', 'SPRUNG', 'SCHAUKELRINGE'],
    gespeichert: true,
  };

  beforeEach(async () => {
    vi.clearAllMocks();
    getTimeplan.mockReturnValue(of([vorschlag]));
    saveTimeplan.mockReturnValue(of([{ ...vorschlag, maxAnlagen: 1, anzahlAnlagen: 1, anzahlAbteilungen: 3 }]));
    await TestBed.configureTestingModule({
      imports: [TimeplanComponent],
      providers: [{ provide: AnlassService, useValue: { getTimeplan, saveTimeplan } }],
    }).compileComponents();
    fixture = TestBed.createComponent(TimeplanComponent);
    fixture.componentRef.setInput('anlass', new IAnlass({ id: 'anlass-id' }));
    root = fixture.nativeElement;
    fixture.detectChanges();
    await fixture.whenStable();
    fixture.detectChanges();
  });

  function cells(): string[] {
    return Array.from(root.querySelectorAll('tbody td')).map((cell) => cell.textContent?.trim() ?? '');
  }

  it('shows the proposal per Kategorie with Geräte and a stale Teilnehmer warning', () => {
    expect(getTimeplan).toHaveBeenCalledWith('anlass-id');
    const values = cells();
    expect(values[0]).toBe('K1');
    expect(values[1]).toBe('Turnerinnen');
    expect(values[2]).toBe('Boden, Reck, Sprung, Schaukelringe');
    expect(values[5]).toContain('90');
    expect(values[5]).toContain('(aktuell 95)');
    expect(values.slice(6)).toEqual(['10', '9', '3', '1', '4']);
  });

  it('sends the edited maxima and shows the recalculated result', async () => {
    const input = root.querySelector<HTMLInputElement>('input[aria-label="Max. Anlagen K1 Turnerinnen"]');
    if (!input) {
      throw new Error('Missing Max. Anlagen input');
    }
    input.value = '1';
    input.dispatchEvent(new Event('input', { bubbles: true }));
    fixture.detectChanges();

    root.querySelector<HTMLButtonElement>('button')?.click();
    fixture.detectChanges();
    await fixture.whenStable();
    fixture.detectChanges();

    expect(saveTimeplan).toHaveBeenCalledWith('anlass-id', [
      { kategorie: KategorieEnum.K1, tiTu: 'Ti', maxAnlagen: 1, maxAbteilungen: 8 },
    ]);
    expect(cells().slice(8, 10)).toEqual(['1', '3']);
  });

  it('disables the calculation for maxima outside the available Anlagen', () => {
    const input = root.querySelector<HTMLInputElement>('input[aria-label="Max. Anlagen K1 Turnerinnen"]');
    if (!input) {
      throw new Error('Missing Max. Anlagen input');
    }
    input.value = '7';
    input.dispatchEvent(new Event('input', { bubbles: true }));
    fixture.detectChanges();

    expect(root.querySelector<HTMLButtonElement>('button')?.disabled).toBe(true);
    expect(root.querySelector('[role="alert"]')?.textContent).toContain('zwischen 1 und 6');
  });
});
