import { test as base, expect, type Page } from '@playwright/test';
import { InMemoryDbService, testAccount } from './in-memory-db.service';

export { expect, testAccount };

export const test = base.extend<{ inMemoryDb: InMemoryDbService }>({
  inMemoryDb: async ({ baseURL }, use): Promise<void> => {
    if (!baseURL) {
      throw new Error('The offline tests require a frontend baseURL.');
    }
    await use(new InMemoryDbService());
  },
  page: async ({ page, inMemoryDb }, use): Promise<void> => {
    const unhandledRequests: string[] = [];
    await page.route('**/*', async (route): Promise<void> => {
      const request = route.request();
      if (!['xhr', 'fetch'].includes(request.resourceType())) {
        await route.continue();
        return;
      }
      const body: unknown = request.postData() ? request.postDataJSON() : undefined;
      const response = inMemoryDb.handle({ method: request.method(), url: request.url(), body });
      if (response.status === 404) {
        unhandledRequests.push(`${request.method()} ${new URL(request.url()).pathname}`);
      }
      await route.fulfill({
        status: response.status,
        contentType: 'application/json',
        headers: {
          'Access-Control-Allow-Origin': request.headers().origin ?? new URL(request.url()).origin,
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Expose-Headers': 'Authorization',
          Authorization: 'Bearer in-memory-test-token',
        },
        body: response.status === 204 ? '' : JSON.stringify(response.body),
      });
    });
    await use(page);
    expect(unhandledRequests, 'Every API request must have an explicit in-memory implementation.').toEqual([]);
  },
});

export async function loginAsTestUser(page: Page): Promise<void> {
  await page.getByRole('combobox', { name: 'Wähle deinen Verein aus' }).fill(testAccount.verein);
  await page.getByRole('option', { name: testAccount.verein, exact: true }).click();
  await page.getByRole('textbox', { name: 'Gib den Benutzernamen (E-Mail) ein' }).fill(testAccount.username);
  await page.getByRole('textbox', { name: 'Gib das Passwort ein' }).fill(testAccount.password);
  await page.getByRole('button', { name: 'Login', exact: true }).click();
  await expect(page.getByRole('heading', { name: 'Login', exact: true })).toBeHidden();
}
