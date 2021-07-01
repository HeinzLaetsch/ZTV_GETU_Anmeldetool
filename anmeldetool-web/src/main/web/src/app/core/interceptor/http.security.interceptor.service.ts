import {
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
  HttpResponse,
} from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { tap } from 'rxjs/operators';
import { AuthService } from '../service/auth/auth.service';
@Injectable()
export class HttpSecurityInterceptorService implements HttpInterceptor {

  constructor(private authService: AuthService) {}

  intercept(
    req: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    console.log('Interceptor called');
    let newHeaders = req.headers;
    if (this.authService.isAuthenticated()) {
      // console.log('Authenticated will add Headers');

      if (this.authService.currentUser !== null) {
        newHeaders = newHeaders
        // .append('authtoken', this.authService.getToken())
        .append('userid', this.authService.currentUser.id)
        .append('vereinsid', this.authService.currentVerein.id);
      }
    } else {
      console.log('Dont do anything');
    }
    const authReq = req.clone({withCredentials: true, headers: newHeaders});
    return next.handle(authReq);
    /*
    .pipe(
      tap( evt => {
        // console.info('Evt: ' , evt);
        if (evt instanceof HttpResponse) {
          // const token = evt.headers.get('JSESSIONID')
          console.info('JSESSIONID: ' , token);
          if (token !== null && token !== undefined)
            this.authService.setToken(token);
        }
      })
    );
    */
  }
}
