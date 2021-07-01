import { HttpClient, HttpErrorResponse, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { ILoginData } from '../../model/ILoginData';

@Injectable({
  providedIn: "root",
})
export class AuthHttpService {

  private host = "http://127.0.0.1:8080/";
  private realms = "auth/realms/";

  constructor(
    private http: HttpClient
  ) {}

  public get<T>(urlPart: string, params: HttpParams, token: string, asJson: boolean): Observable<T> {
    const url = this.host /*+ this.realms*/ + urlPart;
    const httpOptions = {
      headers: this.createHttpHeaders(token, asJson),
    };
    return this.http.get<T>(url, httpOptions).pipe(catchError(this.handleError));
  }

  /*
  public post_1(urlPart: string, formValues: string): Observable<Object> {
    const httpOptions = {
      headers: new HttpHeaders({
        "Content-Type": "application/x-www-form-urlencoded",
      }),
    };
    return this.post(urlPart, httpOptions, formValues);
  }
  */

  public post(
    urlPart: string,
    formValues: ILoginData,
    token: string,
    asJson: boolean
  ): Observable<Object> {
    console.log('post: ' , asJson);
    const url = this.createUrl(urlPart);
    return this.http
      .post(url, formValues, this.createHttpOptions(token, asJson))
      .pipe(catchError(this.handleError));
  }

  private createUrl(urlPart: string) {
    let url: string;
    if (urlPart.indexOf("realms") > 0) {
      url = this.host + urlPart;
    } else {
      url = this.host + this.realms + urlPart;
    }
    console.log("Url: " + url);
    return url;
  }
  /*
  const httpOptions = {
    headers: new HttpHeaders({
      "Content-Type": "application/json",
      Authorization: "Bearer " + token,
    }),
*/
  private createHttpOptions(token: string, asJson: boolean) {
    const httpOptions = {
      headers: this.createHttpHeaders(token, asJson)
    }
    return httpOptions;
  }
  private createHttpHeaders(token: string, asJson: boolean) {
    let headers: HttpHeaders;
    if (asJson) {
      if (token) {
        headers = new HttpHeaders({
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        });
      } else {
        headers = new HttpHeaders({
          "Content-Type": "application/json",
        });
      }
    } else {
      if (token) {
        headers= new HttpHeaders({
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer " + token
        });
      } else {
        headers= new HttpHeaders({
          "Content-Type": "application/x-www-form-urlencoded",
        });
      }
    }
    // onsole.log('Headers: ' , headers.get('Content-Type'), ' , ' , headers.get('Authorization'));
    return headers;
  }

  private handleError(error: HttpErrorResponse) {
    if (error.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error("An error occurred:", error.error.message);
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong.
      console.error(
        `Backend returned code ${error.status}, ` + `body was: ${error.error}`
      );
    }
    // Return an observable with a user-facing error message.
    return throwError("Something bad happened; please try again later.");
  }


}
