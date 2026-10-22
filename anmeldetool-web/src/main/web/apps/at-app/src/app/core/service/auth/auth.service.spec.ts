import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { provideRouter, Router } from '@angular/router';
import { provideStore } from '@ngrx/store';
import { vi } from 'vitest';
import { appReducers } from 'src/app/core/redux/app.reducer';

import { AuthService } from './auth.service';

describe('AuthService', () => {
  let service: AuthService;
  let http: HttpTestingController;
  let router: Router;
  const verein = { id: 'verein-id', name: 'Testverein', verbandId: 'verband-id' };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        provideHttpClient(),
        provideHttpClientTesting(),
        provideStore(appReducers),
        provideRouter([
          {
            path: 'anlaesse',
            children: [],
            canActivate: [(): boolean => TestBed.inject(AuthService).isLoggedIn()],
          },
          { path: 'user', children: [] },
          { path: 'admin/:id/admin', children: [] },
        ]),
      ],
    });
    service = TestBed.inject(AuthService);
    http = TestBed.inject(HttpTestingController);
    router = TestBed.inject(Router);
  });

  afterEach(() => {
    http.verify();
    vi.restoreAllMocks();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it.each(['/user', '/admin/anlass-id/admin'])(
    'opens Alle Anlässe after a successful login from %s',
    async (previousUrl) => {
      await router.navigateByUrl(previousUrl);
      const navigate = vi.spyOn(router, 'navigate');
      const user = { id: 'user-id', rollen: [] };
      service.login(verein, 'test@example.com', 'test-password').subscribe();
      expect(navigate).not.toHaveBeenCalled();
      const request = http.expectOne((candidate) => candidate.url.endsWith('/admin/login'));
      request.flush(user);

      expect(service.isLoggedIn()).toBe(true);
      expect(service.currentUser).toEqual(user);
      expect(service.currentVerein).toEqual(verein);
      expect(navigate).toHaveBeenCalledWith(['/anlaesse']);
      await navigate.mock.results[0].value;
      expect(router.url).toBe('/anlaesse');
    },
  );

  it('stays on the current page after a failed login', async () => {
    await router.navigateByUrl('/user');
    const navigate = vi.spyOn(router, 'navigate');
    const onError = vi.fn();
    service.login(verein, 'test@example.com', 'test-password').subscribe({ error: onError });
    http
      .expectOne((request) => request.url.endsWith('/admin/login'))
      .flush('Invalid login', {
        status: 401,
        statusText: 'Unauthorized',
      });
    expect(onError).toHaveBeenCalledOnce();
    expect(service.isLoggedIn()).toBe(false);
    expect(navigate).not.toHaveBeenCalled();
    expect(router.url).toBe('/user');
  });
});
