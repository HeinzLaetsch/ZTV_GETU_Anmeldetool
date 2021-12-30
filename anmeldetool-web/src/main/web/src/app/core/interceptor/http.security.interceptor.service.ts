import {
  HttpErrorResponse,
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
} from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Router } from "@angular/router";
import { Observable } from "rxjs";
import { tap } from "rxjs/operators";
import { AuthService } from "../service/auth/auth.service";
@Injectable()
export class HttpSecurityInterceptorService implements HttpInterceptor {
  constructor(private router: Router, private authService: AuthService) {}

  intercept(
    req: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    /*
    console.log(
      "Interceptor called: ",
      req.url,
      " , ",
      req.method,
      " , ",
      req.headers
    );*/
    let newHeaders = req.headers;
    if (this.authService.isAuthenticated()) {
      // console.log('Authenticated will add Headers');

      if (this.authService.currentUser !== null) {
        newHeaders = newHeaders
          .append("authtoken", this.authService.getToken())
          .append("userid", this.authService.currentUser.id)
          .append("vereinsid", this.authService.currentVerein.id)
          .append("X-Requested-With", "XMLHttpRequest");
      }
    } else {
      // console.log("Dont do anything");
    }
    const authReq = req.clone({ withCredentials: true, headers: newHeaders });
    return next.handle(authReq).pipe(
      tap(
        (evt) => {
          // console.info("Evt: ", evt);
        },
        (err: any) => {
          if (err instanceof HttpErrorResponse) {
            if (err.status !== 401) {
              return;
            }
            this.authService.currentUser = undefined;
            this.router.navigate(["/"]);
          }
        }
      )
    );
    /*
    .pipe(
      tap((evt) => {
        console.info("Evt: ", evt);
        if (evt instanceof HttpResponse) {
          const token = evt.headers.get("JSESSIONID");
          console.info("JSESSIONID: ", token);
          if (token !== null && token !== undefined)
            this.authService.setToken(token);
        }
      })
    );*/
  }
}
