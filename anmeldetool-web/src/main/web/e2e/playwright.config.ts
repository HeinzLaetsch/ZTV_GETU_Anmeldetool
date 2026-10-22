import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: '.',
  testMatch: '**/*.spec.ts',
  outputDir: '../tmp/playwright',
  forbidOnly: Boolean(process.env.CI),
  retries: 0,
  workers: 1,
  reporter: 'list',
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL ?? 'http://127.0.0.1:4300/ztv-anmeldetool/',
    trace: 'off',
    screenshot: 'off',
    video: 'off',
  },
  webServer: process.env.PLAYWRIGHT_BASE_URL
    ? undefined
    : {
        command: 'npx nx run at-app:serve:e2e',
        url: 'http://127.0.0.1:4300/ztv-anmeldetool/',
        reuseExistingServer: !process.env.CI,
        timeout: 120_000,
        env: { NX_NO_CLOUD: 'true', NX_TUI: 'false' },
        stdout: 'pipe',
        stderr: 'pipe',
      },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
  ],
});
