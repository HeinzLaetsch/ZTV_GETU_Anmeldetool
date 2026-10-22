import { expect, loginAsTestUser, test } from './fixtures';

test.describe('Anlass erstellen ohne Backend', () => {
  test.beforeEach(async ({ page }): Promise<void> => {
    await page.goto('#/anlaesse');
    await loginAsTestUser(page);
    await page.getByRole('button', { name: 'Anlässe Verwalten', exact: true }).click();
    await page.getByRole('menuitem', { name: 'Neuen Anlass erstellen', exact: true }).click();
    await expect(page.getByRole('heading', { name: 'Neuen Anlass erstellen', exact: true })).toBeVisible();
  });

  test('filters organizers and both category bounds while typing and selecting', async ({ page }): Promise<void> => {
    const organizer = page.getByRole('combobox', { name: 'Organisator', exact: true });
    await organizer.fill('winter');
    await expect(page.getByRole('option', { name: 'TV Winterthur', exact: true })).toBeVisible();
    await expect(page.getByRole('option', { name: 'TV Zürich', exact: true })).toHaveCount(0);
    await organizer.fill('ZÜR');
    await expect(page.getByRole('option', { name: 'TV Zürich', exact: true })).toBeVisible();
    await expect(page.getByRole('option', { name: 'TV Winterthur', exact: true })).toHaveCount(0);
    await organizer.fill('no-matching-club');
    await expect(page.getByRole('option', { name: 'Kein Verein gefunden', exact: true })).toBeDisabled();
    await organizer.fill('winter');
    await page.getByRole('option', { name: 'TV Winterthur', exact: true }).click();
    await expect(organizer).toHaveValue('TV Winterthur');

    await page.getByRole('combobox', { name: 'Tiefste Kategorie', exact: true }).click();
    await page.getByRole('option', { name: 'K3', exact: true }).click();
    await page.getByRole('combobox', { name: 'Höchste Kategorie', exact: true }).click();
    await expect(page.getByRole('option', { name: 'K1', exact: true })).toHaveCount(0);
    await expect(page.getByRole('option', { name: 'K2', exact: true })).toHaveCount(0);
    await page.getByRole('option', { name: 'K4', exact: true }).click();
    await page.getByRole('combobox', { name: 'Tiefste Kategorie', exact: true }).click();
    await expect(page.getByRole('option', { name: 'K4', exact: true })).toBeVisible();
    await expect(page.getByRole('option', { name: 'K5', exact: true })).toHaveCount(0);
  });

  test('saves an event and multiple slots and reloads them from the in-memory database', async ({
    page,
    inMemoryDb,
  }): Promise<void> => {
    const year = new Date().getFullYear() + 1;
    await page.getByRole('textbox', { name: 'Bezeichnung', exact: true }).fill('Offline Testanlass');
    await page.getByRole('textbox', { name: 'Ort', exact: true }).fill('Zürich');
    await page.getByRole('textbox', { name: 'Halle', exact: true }).fill('Testhalle');
    await page.getByRole('textbox', { name: 'Beginn des Anlasses', exact: true }).fill(`22.10.${year}`);
    await page.getByRole('textbox', { name: 'Ende des Anlasses', exact: true }).fill(`23.10.${year}`);
    await page.getByRole('textbox', { name: 'Anmeldebeginn', exact: true }).fill(`01.01.${year}`);
    await page.getByRole('textbox', { name: 'Anmeldeschluss', exact: true }).fill(`01.09.${year}`);
    await page.getByRole('textbox', { name: 'Letzte Änderungen bis', exact: true }).fill(`01.10.${year}`);
    await expect(page.getByRole('textbox', { name: 'Kategorienwechsel bis', exact: true })).toBeDisabled();
    await expect(
      page.getByRole('textbox', { name: 'Änderungen innerhalb der Kategorie bis', exact: true }),
    ).toBeDisabled();

    await page
      .getByRole('group', { name: 'Slot 1', exact: true })
      .getByRole('textbox', { name: 'Tag', exact: true })
      .fill(`22.10.${year}`);
    await page.getByRole('button', { name: 'Slot hinzufügen', exact: true }).click();
    const second = page.getByRole('group', { name: 'Slot 2', exact: true });
    await second.getByRole('textbox', { name: 'Tag', exact: true }).fill(`23.10.${year}`);
    await second.getByRole('combobox', { name: 'Brevet', exact: true }).click();
    await page.getByRole('option', { name: 'Brevet 2', exact: true }).click();

    const savedResponse = page.waitForResponse(
      (response) => response.request().method() === 'POST' && new URL(response.url()).pathname === '/admin/anlaesse',
    );
    await page.getByRole('button', { name: 'Anlass erstellen', exact: true }).click();
    const response = await savedResponse;
    expect(response.status()).toBe(201);
    const saved: { id: string; wertungsrichterSlots: { id: string }[] } = await response.json();
    expect(saved.wertungsrichterSlots).toHaveLength(2);
    expect(new Set(saved.wertungsrichterSlots.map((slot) => slot.id)).size).toBe(2);
    await expect(page).toHaveURL(/#\/anlaesse$/);
    await expect(page.getByRole('heading', { name: 'Offline Testanlass', exact: true })).toBeVisible();
    expect(inMemoryDb.handle({ method: 'GET', url: '/admin/anlaesse' }).body).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          id: saved.id,
          startDatum: `${year}-10-22T00:00:00`,
          erfassenGeschlossen: `${year}-09-01T00:00:00`,
          crossKategorieAenderungenGeschlossen: `${year}-09-01T00:00:00`,
          aenderungenInKategorieGeschlossen: `${year}-10-01T00:00:00`,
          wertungsrichterSlots: [
            expect.objectContaining({
              id: expect.any(String),
              brevet: 1,
              tag: `${year}-10-22`,
              start_zeit: null,
              end_zeit: null,
              beschreibung: '',
            }),
            expect.objectContaining({
              id: expect.any(String),
              brevet: 2,
              tag: `${year}-10-23`,
              start_zeit: null,
              end_zeit: null,
              beschreibung: '',
            }),
          ],
        }),
      ]),
    );
  });
});
