import { expect, loginAsTestUser, test, testAccount } from './fixtures';

test('Anlass Statistik displays participant counts and disables start before registration opens', async ({
  page,
  inMemoryDb,
}): Promise<void> => {
  const seed = inMemoryDb.createDb();
  const event = seed.anlaesse[0];
  const organisation = seed.organisationen[0];
  const eventId = String(event.id);

  inMemoryDb.handle({
    method: 'POST',
    url: '/admin/login',
    body: {
      username: testAccount.username,
      password: testAccount.password,
      organisationId: organisation.id,
    },
  });

  await page.route('**/admin/anlaesse/organisationen/*/summaries', async (route): Promise<void> => {
    await route.fulfill({
      json: [
        {
          anlassId: eventId,
          organisationsId: organisation.id,
          startet: false,
          verlaengerungsDate: '2099-12-31T23:59:59',
          startendeBr1: 10,
          startendeK1: 2,
          startendeK2: 3,
          startendeK3: 2,
          startendeK4: 3,
          startendeK5: 2,
          startendeK5A: 1,
          startendeK5B: 1,
          startendeK6: 3,
          startendeK7: 3,
          startendeKD: 1,
          startendeKH: 1,
          startendeBr2: 8,
          gemeldeteBr1: 10,
          gemeldeteBr2: 8,
          br1Ok: true,
          br2Ok: true,
        },
      ],
    });
  });

  await page.goto('#/anlaesse');
  await loginAsTestUser(page);
  await page.goto(`#/anlaesse/${eventId}`);

  await expect(page.getByText('Anlass Statistik')).toBeVisible();
  await expect(page.getByText('Teilnehmer Total: 18 / 3')).toBeVisible();
  await expect(page.getByText('Teilnehmer K1-K4: 10')).toBeVisible();
  await expect(page.getByText('Teilnehmer K5-K7: 8')).toBeVisible();
  await expect(page.getByText('K1: 2')).toBeVisible();
  await expect(page.getByText('K4: 3')).toBeVisible();
  await expect(page.getByText('K5: 2')).toBeVisible();
  await expect(page.getByText('K7: 3')).toBeVisible();

  const checkbox = page.getByRole('checkbox', { name: 'Verein startet', exact: true });
  await expect(checkbox).toBeDisabled();
  await expect(checkbox).not.toBeChecked();
});
