import {
  HttpErrorResponse,
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
  HttpResponse,
} from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { AuthService } from '../service/auth/auth.service';

@Injectable()
export class HttpSecurityInterceptorService implements HttpInterceptor {
  constructor(
    private router: Router,
    private authService: AuthService,
  ) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    console.log('HttpSecurityInterceptorService intercept called for URL: ', req.url);

    const isLoginRequest = req.url.includes('/admin/login');

    if (isLoginRequest) {
      return next.handle(req.clone({ withCredentials: true }));
    }

    let headers = req.headers.set('X-Requested-With', 'XMLHttpRequest');
    const vereinId = this.authService.currentVerein?.id ?? '';
    const token = this.authService.getToken();
    const userId = this.authService.currentUser?.id ?? '';

    if (this.authService.isAuthenticatedSig() && token && userId) {
      headers = headers
        .set('authtoken', token)
        .set('userid', userId)
        .set('vereinsid', vereinId)
        .set('Authorization', `Bearer ${token}`);
    } else if (vereinId) {
      headers = headers.set('vereinsid', vereinId);
    }

    const authReq = req.clone({ withCredentials: true, headers });

    return next.handle(authReq).pipe(
      tap({
        next: (evt) => {
          if (evt instanceof HttpResponse) {
            const tokenFromHeader = evt.headers.get('JSESSIONID') ?? evt.headers.get('X-AUTH-TOKEN');
            if (tokenFromHeader) {
              this.authService.setToken(tokenFromHeader);
            }
          }
        },
        error: (err: any) => {
          if (err instanceof HttpErrorResponse) {
            if (err.status !== 401 && err.status !== 403) {
              return;
            }
            this.authService.currentUser = null;
            this.router.navigate(['/']);
          }
        },
      }),
    );
  }
}
