import { expect, loginAsTestUser, test, testAccount } from './fixtures';

test('logs in with a selected Verein and opens the main navigation', async ({ page }): Promise<void> => {
  await page.goto('#/anlaesse/neu');

  const loginHeading = page.getByRole('heading', { name: 'Login', exact: true });
  const loginButton = page.getByRole('button', { name: 'Login', exact: true });
  await expect(loginHeading).toBeVisible();
  await expect(loginButton).toBeDisabled();

  await loginAsTestUser(page);

  await expect(loginHeading).toBeHidden();
  const navigation = page.getByLabel('Hauptnavigation');
  await expect(navigation).toBeVisible();
  await expect(navigation.getByRole('button', { name: 'Alle Anlässe' })).toBeVisible();
  await expect(navigation.getByRole('button', { name: 'Teilnehmer', exact: true })).toBeVisible();
  await expect(page.getByLabel('Benutzerkonto').getByRole('button', { name: 'Benutzerdaten' })).toBeVisible();
  await expect(page).toHaveURL(/#\/anlaesse$/);
  await expect(page.getByRole('heading', { name: 'Testwettkampf', exact: true })).toBeVisible();
});

test('rejects an incorrect password without opening protected content', async ({ page }): Promise<void> => {
  await page.goto('#/anlaesse');
  await page.getByRole('combobox', { name: 'Wähle deinen Verein aus' }).fill(testAccount.verein);
  await page.getByRole('option', { name: testAccount.verein, exact: true }).click();
  await page.getByRole('textbox', { name: 'Gib den Benutzernamen (E-Mail) ein' }).fill(testAccount.username);
  await page.getByRole('textbox', { name: 'Gib das Passwort ein' }).fill('incorrect-test-password');
  await page.getByRole('button', { name: 'Login', exact: true }).click();
  await expect(page.getByRole('heading', { name: 'Login', exact: true })).toBeVisible();
  await expect(page.getByText(/Fehler beim Login/)).toBeVisible();
  await expect(page.getByLabel('Hauptnavigation')).toHaveCount(0);
});
