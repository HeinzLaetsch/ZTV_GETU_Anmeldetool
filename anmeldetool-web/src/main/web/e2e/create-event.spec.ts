import { expect, loginAsTestUser, test } from './fixtures';

test.describe('Anlass erstellen und löschen mit simuliertem Backend', () => {
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

  test('creates an event with slots, cancels deletion, then deletes the event and its slots', async ({
    page,
    inMemoryDb,
  }): Promise<void> => {
    const year = new Date().getFullYear() + 1;
    const pageErrors: string[] = [];
    page.on('pageerror', (error) => pageErrors.push(error.message));
    await page.getByRole('textbox', { name: 'Bezeichnung', exact: true }).fill('Offline Testanlass');
    await page.getByRole('textbox', { name: 'Ort', exact: true }).fill('Zürich');
    await page.getByRole('textbox', { name: 'Halle', exact: true }).fill('Testhalle');
    await page.getByRole('textbox', { name: 'IBAN', exact: true }).fill('CH93 0076 2011 6238 5295 7');
    await page.getByRole('checkbox', { name: 'SM-Qualifikation', exact: true }).check();
    await page.getByRole('checkbox', { name: 'Ausserkantonal', exact: true }).check();
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
          iban: 'CH93 0076 2011 6238 5295 7',
          smQuali: true,
          ausserkantonal: true,
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

    let deleteRequests = 0;
    page.on('request', (request) => {
      if (request.method() === 'DELETE' && new URL(request.url()).pathname === `/admin/anlaesse/${saved.id}`) {
        deleteRequests++;
      }
    });
    await page.goto(`#/admin/${saved.id}/admin`);
    const deleteButton = page.getByRole('button', { name: 'Anlass löschen', exact: true });
    await deleteButton.click();
    const confirmation = page.getByRole('dialog', { name: 'Anlass löschen?', exact: true });
    await expect(confirmation).toContainText('Offline Testanlass');
    await expect(confirmation).toContainText('alle dazugehörigen Slots');
    const cancelButton = confirmation.getByRole('button', { name: 'Abbrechen', exact: true });
    await expect(cancelButton).toBeFocused();
    await cancelButton.click();
    await expect(confirmation).toBeHidden();
    await expect(deleteButton).toBeEnabled();
    expect(deleteRequests).toBe(0);
    expect(inMemoryDb.handle({ method: 'GET', url: '/admin/anlaesse' }).body).toEqual(
      expect.arrayContaining([expect.objectContaining({ id: saved.id })]),
    );

    await deleteButton.click();
    const deletedResponse = page.waitForResponse(
      (candidate) =>
        candidate.request().method() === 'DELETE' &&
        new URL(candidate.url()).pathname === `/admin/anlaesse/${saved.id}`,
    );
    await confirmation.getByRole('button', { name: 'Endgültig löschen', exact: true }).click();
    expect((await deletedResponse).status()).toBe(204);
    expect(deleteRequests).toBe(1);
    await expect(page).toHaveURL(/#\/anlaesse$/);
    await expect(page.getByRole('heading', { name: 'Offline Testanlass', exact: true })).toHaveCount(0);
    await expect(page.getByRole('heading', { name: 'Testwettkampf', exact: true })).toBeVisible();
    const remaining = inMemoryDb.handle({ method: 'GET', url: '/admin/anlaesse' }).body;
    expect(remaining).not.toEqual(expect.arrayContaining([expect.objectContaining({ id: saved.id })]));
    for (const slot of saved.wertungsrichterSlots) {
      expect(remaining).not.toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            wertungsrichterSlots: expect.arrayContaining([expect.objectContaining({ id: slot.id })]),
          }),
        ]),
      );
    }
    expect(pageErrors).toEqual([]);
  });
});
