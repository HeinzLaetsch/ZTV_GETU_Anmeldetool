import { HTTP_INTERCEPTORS, HttpClient, provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { AuthService } from '../service/auth/auth.service';
import { HttpSecurityInterceptorService } from './http.security.interceptor.service';

describe('HttpSecurityInterceptorService', () => {
  let http: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        provideHttpClient(withInterceptorsFromDi()),
        provideHttpClientTesting(),
        provideRouter([]),
        {
          provide: AuthService,
          useValue: {
            currentUser: { id: 'user-id' },
            currentVerein: { id: 'verein-id' },
            getToken: (): string => 'test-jwt',
            isAuthenticatedSig: (): boolean => true,
            setToken: vi.fn(),
          },
        },
        {
          provide: HTTP_INTERCEPTORS,
          useClass: HttpSecurityInterceptorService,
          multi: true,
        },
      ],
    });
    http = TestBed.inject(HttpTestingController);
  });

  afterEach(() => http.verify());

  it('sends authenticated requests with a bearer token', () => {
    TestBed.inject(HttpClient).get('/private').subscribe();
    const request = http.expectOne('/private');

    expect(request.request.headers.get('Authorization')).toBe('Bearer test-jwt');
    request.flush({});
  });
});
