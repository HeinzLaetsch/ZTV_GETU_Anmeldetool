import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { environment } from 'src/environments/environment';
import { IAnlass } from '../../model/IAnlass';
import { KategorieEnum } from '../../model/KategorieEnum';
import { AnlassService, type CreateAnlass } from './anlass.service';

describe('AnlassService slot contract', () => {
  let service: AnlassService;
  let http: HttpTestingController;
  const slot = {
    id: 'slot-id',
    reihenfolge: 1,
    brevet: 2,
    tag: '2027-03-01',
    start_zeit: '08:00:00',
    end_zeit: '12:00:00',
    beschreibung: 'Vormittag',
    egalSlot: false,
  };

  beforeEach(() => {
    TestBed.configureTestingModule({ providers: [provideHttpClient(), provideHttpClientTesting()] });
    service = TestBed.inject(AnlassService);
    http = TestBed.inject(HttpTestingController);
  });

  afterEach(() => http.verify());

  it('posts new slots without IDs and maps the saved slots into IWertungsrichterSlot dates', () => {
    const input: CreateAnlass = {
      anlassBezeichnung: 'Testanlass',
      ort: 'Zürich',
      halle: 'Turnhalle',
      organisatorId: 'verein-id',
      tiTu: 'Alle',
      tiefsteKategorie: KategorieEnum.K1,
      hoechsteKategorie: KategorieEnum.K7,
      startDatum: '2027-03-01T00:00:00',
      endDatum: '2027-03-02T00:00:00',
      anmeldungBeginn: '2027-01-01T00:00:00',
      erfassenGeschlossen: '2027-02-01T00:00:00',
      crossKategorieAenderungenGeschlossen: '2027-02-02T00:00:00',
      aenderungenInKategorieGeschlossen: '2027-02-04T00:00:00',
      aenderungenNichtMehrErlaubt: '2027-02-04T00:00:00',
      wertungsrichterSlots: [
        {
          reihenfolge: 1,
          brevet: 2,
          tag: slot.tag,
          start_zeit: slot.start_zeit,
          end_zeit: slot.end_zeit,
          beschreibung: slot.beschreibung,
        },
      ],
    };
    let saved: IAnlass | undefined;
    service.createAnlass(input).subscribe((result) => {
      saved = result;
    });
    const request = http.expectOne(`${environment.apiHost}/admin/anlaesse`);
    expect(request.request.method).toBe('POST');
    expect(request.request.body.wertungsrichterSlots).toEqual(input.wertungsrichterSlots);
    expect(request.request.body.wertungsrichterSlots[0].id).toBeUndefined();
    request.flush({ id: 'anlass-id', wertungsrichterSlots: [slot] });
    expect(saved).toBeInstanceOf(IAnlass);
    expect(saved?.wertungsrichterSlots?.[0]).toEqual({
      id: 'slot-id',
      reihenfolge: 1,
      brevet: 2,
      beschreibung: 'Vormittag',
      egalSlot: false,
      tag: new Date(2027, 2, 1),
      startzeit: new Date(2027, 2, 1, 8),
      endzeit: new Date(2027, 2, 1, 12),
    });
  });

  it('preserves slot association and times when the event list is reloaded', () => {
    let events: IAnlass[] = [];
    service.getAnlaesse(true).subscribe((result) => {
      events = result;
    });
    http.expectOne(`${environment.apiHost}/admin/anlaesse`).flush([{ id: 'anlass-id', wertungsrichterSlots: [slot] }]);
    expect(events[0].id).toBe('anlass-id');
    expect(events[0].wertungsrichterSlots?.[0].id).toBe('slot-id');
    expect(events[0].wertungsrichterSlots?.[0].startzeit?.getHours()).toBe(8);
    expect(events[0].wertungsrichterSlots?.[0].endzeit?.getHours()).toBe(12);
  });

  it('also loads existing unrestricted slots without dates or times', () => {
    let events: IAnlass[] = [];
    service.getAnlaesse(true).subscribe((result) => {
      events = result;
    });
    http.expectOne(`${environment.apiHost}/admin/anlaesse`).flush([
      {
        id: 'anlass-id',
        wertungsrichterSlots: [{ ...slot, egalSlot: true, tag: null, start_zeit: null, end_zeit: null }],
      },
    ]);
    expect(events[0].wertungsrichterSlots?.[0].egalSlot).toBe(true);
    expect(events[0].wertungsrichterSlots?.[0].tag).toBeUndefined();
    expect(events[0].wertungsrichterSlots?.[0].startzeit).toBeUndefined();
  });
});
