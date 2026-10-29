import { randomUUID } from 'node:crypto';
import type { IUser } from '../apps/at-app/src/app/core/model/IUser';
import type { IVerein } from '../apps/at-app/src/app/verein/verein';

export const testAccount = {
  verein: 'ZTV',
  username: 'admin@example.test',
  password: 'test-only-password',
};

type InMemoryRequest = { method: string; url: string; body?: unknown };
type InMemoryResponse = { status: number; body: unknown };
type Database = {
  organisationen: IVerein[];
  user: IUser[];
  anlaesse: Record<string, unknown>[];
};

function asRecord(value: unknown): Record<string, unknown> | undefined {
  return value !== null && typeof value === 'object' && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : undefined;
}

export class InMemoryDbService {
  private readonly database = this.createDb();
  private isAuthenticated = false;
  private readonly clubStarts = new Map<string, { startet: boolean; verlaengerungsDate: string | null }>();

  createDb(): Database {
    const organisationen = [
      { id: '00000000-0000-4000-8000-000000000001', name: 'ZTV', verbandId: 'test-verband' },
      { id: '00000000-0000-4000-8000-000000000002', name: 'TV Winterthur', verbandId: 'test-verband' },
      { id: '00000000-0000-4000-8000-000000000003', name: 'TV Zürich', verbandId: 'test-verband' },
    ];
    const year = new Date().getFullYear() + 1;
    return {
      organisationen,
      user: [
        {
          id: '00000000-0000-4000-8000-000000000010',
          organisationids: [organisationen[0].id],
          benutzername: testAccount.username,
          name: 'Test',
          vorname: 'Admin',
          email: testAccount.username,
          handy: '',
          aktiv: true,
          rollen: [{ id: 'test-admin-role', name: 'ADMINISTRATOR', aktiv: true }],
        },
      ],
      anlaesse: [
        {
          id: '00000000-0000-4000-8000-000000000020',
          anlassBezeichnung: 'Testwettkampf',
          ort: 'Zürich',
          halle: 'Testhalle',
          organisatorId: organisationen[0].id,
          aktiv: true,
          published: true,
          tiTu: 'Alle',
          tiefsteKategorie: 'K1',
          hoechsteKategorie: 'K7',
          startDatum: `${year}-10-22T00:00:00`,
          endDatum: `${year}-10-23T00:00:00`,
          anmeldungBeginn: `${year}-01-01T00:00:00`,
          erfassenGeschlossen: `${year}-09-01T00:00:00`,
          crossKategorieAenderungenGeschlossen: `${year}-09-01T00:00:00`,
          aenderungenInKategorieGeschlossen: `${year}-10-01T00:00:00`,
          aenderungenNichtMehrErlaubt: `${year}-10-01T00:00:00`,
          wertungsrichterSlots: [],
        },
      ],
    };
  }

  handle(request: InMemoryRequest): InMemoryResponse {
    const path = new URL(request.url, 'http://in-memory.test').pathname.replace(/\/$/, '');
    if (request.method === 'GET' && path === '/admin/organisationen') {
      return this.response(200, this.database.organisationen);
    }
    if (request.method === 'GET' && path === '/admin/anlaesse') {
      return this.response(200, this.database.anlaesse);
    }
    if (request.method === 'POST' && path === '/admin/login') {
      return this.login(request.body);
    }
    if (!this.isAuthenticated) {
      return this.response(401, { message: 'Anmeldung erforderlich' });
    }
    if (request.method === 'GET' && path === '/admin/user') {
      return this.response(200, this.database.user);
    }
    const eventResponse = this.handleEventRequest(request.method, path);
    if (eventResponse) {
      return eventResponse;
    }
    const participationResponse = this.handleParticipationRequest(request, path);
    if (participationResponse) {
      return participationResponse;
    }
    const summaries = path.match(/^\/admin\/anlaesse\/organisationen\/([^/]+)\/summaries$/);
    if (request.method === 'GET' && summaries) {
      return this.response(
        200,
        this.database.anlaesse.map((anlass) => ({
          anlassId: anlass.id,
          organisationsId: summaries[1],
          startet: false,
          verlaengerungsDate: null,
          startendeBr1: 0,
          startendeBr2: 0,
          gemeldeteBr1: 0,
          gemeldeteBr2: 0,
          br1Ok: true,
          br2Ok: true,
          ...this.clubStarts.get(`${anlass.id}:${summaries[1]}`),
        })),
      );
    }
    if (request.method === 'POST' && path === '/admin/anlaesse') {
      const input = asRecord(request.body);
      if (
        !input ||
        typeof input.anlassBezeichnung !== 'string' ||
        !Array.isArray(input.wertungsrichterSlots) ||
        input.wertungsrichterSlots.length === 0
      ) {
        return this.response(400, { message: 'Anlass und mindestens ein Slot sind erforderlich' });
      }
      const slots = input.wertungsrichterSlots.map((value: unknown, index: number) => ({
        ...asRecord(value),
        id: randomUUID(),
        reihenfolge: index + 1,
      }));
      const saved = { ...input, id: randomUUID(), aktiv: true, published: false, wertungsrichterSlots: slots };
      this.database.anlaesse.push(saved);
      return this.response(201, saved);
    }
    return this.response(404, { message: `Nicht gemockter Endpunkt: ${request.method} ${path}` });
  }

  private handleEventRequest(method: string, path: string): InMemoryResponse | undefined {
    const eventPath = path.match(/^\/admin\/anlaesse\/([^/]+)$/);
    if (method === 'DELETE' && eventPath) {
      const index = this.database.anlaesse.findIndex((event) => event.id === eventPath[1]);
      if (index === -1) {
        return this.response(404, { message: 'Anlass nicht gefunden' });
      }
      this.database.anlaesse.splice(index, 1);
      return this.response(204, null);
    }
    const statistics = path.match(/^\/admin\/anlaesse\/([^/]+)\/teilnehmer\/statistic(?:\/[^/]+){0,2}$/);
    if (method === 'GET' && statistics) {
      if (!this.database.anlaesse.some((event) => event.id === statistics[1])) {
        return this.response(404, { message: 'Anlass nicht gefunden' });
      }
      return this.response(200, {
        total: 0,
        totalStartende: 0,
        totalZurueckgezogen: 0,
        startet: 0,
        neumeldung: 0,
        abgemeldet_1: 0,
        abgemeldet_2: 0,
        abgemeldet_3: 0,
        ummeldung: 0,
        verletzt: 0,
        nichtGestartet: 0,
        lauflistenGeneriert: false,
      });
    }
    const divisions = path.match(/^\/anlaesse\/([^/]+)\/lauflisten\/[^/]+$/);
    if (method === 'GET' && divisions) {
      return this.database.anlaesse.some((event) => event.id === divisions[1])
        ? this.response(200, [])
        : this.response(404, { message: 'Anlass nicht gefunden' });
    }
    if (method === 'GET' && /^\/admin\/teilnahmen\/\d{4}\/organisationen\/[^/]+(?:\/teilnahmen)?$/.test(path)) {
      return this.response(200, []);
    }
    return undefined;
  }

  private handleParticipationRequest(request: InMemoryRequest, path: string): InMemoryResponse | undefined {
    const link = path.match(/^\/admin\/anlaesse\/([^/]+)\/organisationen\/([^/]+)$/);
    if (request.method === 'PATCH' && link) {
      const input = asRecord(request.body);
      if (!this.database.anlaesse.some((event) => event.id === link[1]) ||
          !this.database.organisationen.some((organisation) => organisation.id === link[2])) {
        return this.response(404, { message: 'Anlass oder Verein nicht gefunden' });
      }
      if (typeof input?.startet !== 'boolean') {
        return this.response(400, { message: 'Startstatus ist erforderlich' });
      }
      const state = {
        startet: input.startet,
        verlaengerungsDate: typeof input.verlaengerungsDate === 'string' ? input.verlaengerungsDate : null,
      };
      this.clubStarts.set(`${link[1]}:${link[2]}`, state);
      return this.response(200, { anlassId: link[1], organisationsId: link[2], ...state });
    }
    if (request.method === 'GET' &&
        /^\/admin\/anlaesse\/[^/]+\/organisationen\/[^/]+\/wertungsrichter\/[12]\/(?:verfuegbar|eingeteilt)$/.test(path)) {
      return this.response(200, []);
    }
    return undefined;
  }

  private login(body: unknown): InMemoryResponse {
    const input = asRecord(body);
    const user = this.database.user.find(
      (candidate) =>
        candidate.benutzername === input?.username && candidate.organisationids.includes(String(input?.organisationId)),
    );
    if (!user || input?.password !== testAccount.password) {
      return this.response(401, { message: 'Ungültige Test-Anmeldedaten' });
    }
    this.isAuthenticated = true;
    return this.response(200, user);
  }

  private response(status: number, body: unknown): InMemoryResponse {
    return { status, body: structuredClone(body) };
  }
}
