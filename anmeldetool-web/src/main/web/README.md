# AtApp

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 8.3.6.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `npm run e2e` or `npm run e2e:headless` to execute the Playwright suite in Chromium and Firefox.

### Playwright tests without a backend

Install Chromium and Firefox once:

```sh
npx playwright install chromium firefox
```

Run the offline suite:

```sh
npx nx run at-app:playwright --skip-nx-cache
```

Playwright starts a dedicated frontend server using `at-app:serve:e2e` on
`http://127.0.0.1:4300/ztv-anmeldetool/` and stops it after the tests. A running development
server on port 4200 is not affected. Set `PLAYWRIGHT_BASE_URL` to use an existing frontend server instead.

The test-only `InMemoryDbService` in [e2e/in-memory-db.service.ts](e2e/in-memory-db.service.ts)
provides isolated Verein, user, and Anlass fixtures for each browser test. It handles simulated login,
loads event summaries, and stores new events with their Wertungsrichter slots in memory. All browser
HTTP API requests are intercepted by [e2e/fixtures.ts](e2e/fixtures.ts); no backend is contacted.
Unexpected endpoints fail the test instead of silently using the real API.

The suite runs in Chromium and Firefox and covers successful and failed login, the landing page, live organizer search, category bounds,
and creating/reloading an event with multiple slots. It uses fictional accounts from `testAccount`;
no real credentials or backend process are required. Data is discarded between tests. The in-memory
API is a test double, not a replacement for the Java validation and persistence tests.
Screenshots, videos, and traces remain disabled.

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).
