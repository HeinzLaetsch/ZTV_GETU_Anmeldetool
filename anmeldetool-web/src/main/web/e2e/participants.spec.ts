import { expect, loginAsTestUser, test, testAccount } from './fixtures';

for (const width of [1440, 780, 390]) {
  test(`participant headers fit on one line at ${width}px`, async ({ page, inMemoryDb }): Promise<void> => {
    const seed = inMemoryDb.createDb();
    inMemoryDb.handle({
      method: 'POST',
      url: '/admin/login',
      body: {
        username: testAccount.username,
        password: testAccount.password,
        organisationId: seed.organisationen[0].id,
      },
    });
    const longName = 'Kantonalmeisterschaft Geräteturnen Nachwuchskategorien';
    inMemoryDb.handle({
      method: 'POST',
      url: '/admin/anlaesse',
      body: {
        ...seed.anlaesse[0],
        anlassBezeichnung: longName,
        wertungsrichterSlots: [{ brevet: 1, tag: '2027-10-22', beschreibung: '' }],
      },
    });
    await page.goto('#/anlaesse');
    await loginAsTestUser(page);
    await page.getByRole('button', { name: 'Teilnehmer', exact: true }).click();
    await expect(page.locator('ag-grid-angular')).toBeVisible();
    await expect(page.locator('.ag-header-cell-text').filter({ hasText: 'aktuelle Kategorie' })).toBeVisible();
    await page.setViewportSize({ width, height: 1000 });
    await page.evaluate(async (): Promise<void> => {
      await document.fonts.ready;
    });

    for (const scrollToEnd of [false, true]) {
      await page.locator('.ag-body-horizontal-scroll-viewport').evaluate((element, atEnd): void => {
        element.scrollLeft = atEnd ? element.scrollWidth : 0;
      }, scrollToEnd);
      await expect
        .poll(async (): Promise<string[]> =>
          page.locator('.ag-header-cell-text').evaluateAll((elements) =>
            elements.flatMap((element) => {
              const text = element as HTMLElement;
              if (text.getBoundingClientRect().width === 0) {
                return [];
              }
              return getComputedStyle(text).whiteSpace !== 'nowrap' ||
                text.scrollWidth > text.clientWidth + 1 ||
                text.scrollHeight > text.clientHeight + 1
                ? [text.textContent ?? 'Unnamed column']
                : [];
            }),
          ),
        )
        .toEqual([]);
      if (scrollToEnd) {
        await expect(page.locator('.ag-header-cell-text').filter({ hasText: longName })).toBeVisible();
      }
    }
  });
}
