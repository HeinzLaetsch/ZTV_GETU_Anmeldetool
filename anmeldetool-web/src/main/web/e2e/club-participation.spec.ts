import { expect, loginAsTestUser, test, testAccount } from './fixtures';

test('Verein startet sends PATCH and persists checking and unchecking', async ({ page, inMemoryDb }): Promise<void> => {
  const seed = inMemoryDb.createDb();
  const organisation = seed.organisationen[0];
  inMemoryDb.handle({
    method: 'POST',
    url: '/admin/login',
    body: { username: testAccount.username, password: testAccount.password, organisationId: organisation.id },
  });
  const created = inMemoryDb.handle({
    method: 'POST',
    url: '/admin/anlaesse',
    body: {
      ...seed.anlaesse[0],
      anlassBezeichnung: 'Offener Testanlass',
      anmeldungBeginn: '2000-01-01T00:00:00',
      wertungsrichterSlots: [{ brevet: 1, tag: `${new Date().getFullYear() + 1}-10-22`, beschreibung: '' }],
    },
  });
  expect(created.status).toBe(201);
  const event = created.body as { id: string };
  const patchPath = `/admin/anlaesse/${event.id}/organisationen/${organisation.id}`;
  const errors: string[] = [];
  const corsErrors: string[] = [];
  page.on('pageerror', (error) => errors.push(error.message));
  page.on('console', (message) => {
    if (message.type() === 'error' && /cors|cross-origin/i.test(message.text())) {
      corsErrors.push(message.text());
    }
  });

  await page.goto('#/anlaesse');
  await loginAsTestUser(page);
  await page.goto(`#/anlaesse/${event.id}`);
  const checkbox = page.getByRole('checkbox', { name: 'Verein startet', exact: true });
  await expect(checkbox).toBeEnabled();
  await expect(checkbox).not.toBeChecked();

  for (const checked of [true, false]) {
    const savedResponse = page.waitForResponse(
      (response) => response.request().method() === 'PATCH' && new URL(response.url()).pathname === patchPath,
    );
    await checkbox.setChecked(checked);
    const response = await savedResponse;
    expect(response.status()).toBe(200);
    const requestOrigin = await response.request().headerValue('origin');
    expect(response.headers()['access-control-allow-origin']).toBe(requestOrigin ?? new URL(response.url()).origin);
    expect(response.request().postDataJSON()).toMatchObject({
      anlassId: event.id,
      organisationsId: organisation.id,
      startet: checked,
    });
    expect(await response.request().headerValue('authorization')).toBe('Bearer in-memory-test-token');
    await expect(checkbox).toBeChecked({ checked });
    expect(
      inMemoryDb.handle({
        method: 'GET',
        url: `/admin/anlaesse/organisationen/${organisation.id}/summaries`,
      }).body,
    ).toEqual(expect.arrayContaining([expect.objectContaining({ anlassId: event.id, startet: checked })]));

    await page.reload();
    await loginAsTestUser(page);
    await page.goto(`#/anlaesse/${event.id}`);
    await expect(checkbox).toBeChecked({ checked });
  }
  expect(errors).toEqual([]);
  expect(corsErrors).toEqual([]);
});
