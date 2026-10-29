import { expect, test } from '@playwright/test';
import { InMemoryDbService, testAccount } from './in-memory-db.service';

test.describe('InMemoryDbService', () => {
  function login(database: InMemoryDbService): void {
    const organisation = database.createDb().organisationen[0];
    const result = database.handle({
      method: 'POST',
      url: '/admin/login',
      body: {
        username: testAccount.username,
        password: testAccount.password,
        organisationId: organisation.id,
      },
    });
    expect(result.status).toBe(200);
  }

  test('provides deterministic isolated fixtures', () => {
    const database = new InMemoryDbService();
    expect(database.handle({ method: 'GET', url: '/admin/organisationen' }).body).toEqual(
      database.createDb().organisationen,
    );
    const first = database.handle({ method: 'GET', url: '/admin/anlaesse' });
    expect(first.body).toEqual(new InMemoryDbService().handle({ method: 'GET', url: '/admin/anlaesse' }).body);
  });

  test('rejects incorrect login credentials', () => {
    const database = new InMemoryDbService();
    expect(
      database.handle({
        method: 'POST',
        url: '/admin/login',
        body: {
          username: testAccount.username,
          password: 'incorrect',
          organisationId: database.createDb().organisationen[0].id,
        },
      }).status,
    ).toBe(401);
  });

  test('requires a successful login before saving', () => {
    const database = new InMemoryDbService();
    expect(database.handle({ method: 'POST', url: '/admin/anlaesse', body: {} }).status).toBe(401);
  });

  test('saves an event with generated slot IDs and reloads it without leaking into other tests', () => {
    const database = new InMemoryDbService();
    login(database);
    const result = database.handle({
      method: 'POST',
      url: '/admin/anlaesse',
      body: {
        anlassBezeichnung: 'Neuer Testanlass',
        wertungsrichterSlots: [{ brevet: 1, tag: '2027-03-01', start_zeit: null, end_zeit: null, beschreibung: '' }],
      },
    });
    expect(result.status).toBe(201);
    expect(result.body).toMatchObject({
      id: expect.any(String),
      published: false,
      aktiv: true,
      wertungsrichterSlots: [{ id: expect.any(String), reihenfolge: 1, brevet: 1 }],
    });
    expect(database.handle({ method: 'GET', url: '/admin/anlaesse' }).body).toEqual(
      expect.arrayContaining([result.body]),
    );
    expect(new InMemoryDbService().handle({ method: 'GET', url: '/admin/anlaesse' }).body).toHaveLength(1);
  });

  test('returns 404 for unimplemented endpoints instead of contacting a real backend', () => {
    const database = new InMemoryDbService();
    login(database);
    expect(database.handle({ method: 'GET', url: '/admin/not-implemented' }).status).toBe(404);
  });

  test('requires authentication before deleting an event', () => {
    const database = new InMemoryDbService();
    const id = database.createDb().anlaesse[0].id;
    expect(database.handle({ method: 'DELETE', url: `/admin/anlaesse/${id}` }).status).toBe(401);
    expect(database.handle({ method: 'GET', url: '/admin/anlaesse' }).body).toHaveLength(1);
  });

  test('deletes only the selected event and its nested slots', () => {
    const database = new InMemoryDbService();
    login(database);
    const created = database.handle({
      method: 'POST',
      url: '/admin/anlaesse',
      body: { anlassBezeichnung: 'Delete test', wertungsrichterSlots: [{ brevet: 1 }, { brevet: 2 }] },
    });
    const saved = created.body as { id: string; wertungsrichterSlots: { id: string }[] };
    expect(saved.wertungsrichterSlots).toHaveLength(2);
    expect(database.handle({ method: 'DELETE', url: `/admin/anlaesse/${saved.id}` })).toEqual({
      status: 204,
      body: null,
    });
    expect(database.handle({ method: 'GET', url: '/admin/anlaesse' }).body).toEqual(database.createDb().anlaesse);
    expect(database.handle({ method: 'DELETE', url: `/admin/anlaesse/${saved.id}` }).status).toBe(404);
  });
});
