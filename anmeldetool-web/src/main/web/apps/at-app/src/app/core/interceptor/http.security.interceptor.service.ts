import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { catchError, Observable, throwError } from 'rxjs';
import { AuthService } from '../service/auth/auth.service';

@Injectable()
export class HttpSecurityInterceptorService implements HttpInterceptor {
  constructor(
    private router: Router,
    private authService: AuthService,
  ) {}

  intercept(req: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    if (req.url.includes('/admin/login')) {
      return next.handle(req.clone({ withCredentials: true }));
    }

    let headers = req.headers.set('X-Requested-With', 'XMLHttpRequest');
    const vereinId = this.authService.currentVerein?.id ?? '';
    const token = this.authService.getToken();
    const userId = this.authService.currentUser?.id ?? '';

    if (this.authService.isAuthenticatedSig() && token) {
      headers = headers.set('Authorization', 'Bearer ' + token).set('authtoken', token);
      if (userId) {
        headers = headers.set('userid', userId);
      }
      if (vereinId) {
        headers = headers.set('vereinsid', vereinId);
      }
    } else if (vereinId) {
      headers = headers.set('vereinsid', vereinId);
    }

    return next.handle(req.clone({ withCredentials: true, headers })).pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status === 401 || error.status === 403) {
          this.authService.currentUser = null;
          this.authService.setToken('');
          this.router.navigate(['/']);
        }
        return throwError(() => error);
      }),
    );
  }
}
