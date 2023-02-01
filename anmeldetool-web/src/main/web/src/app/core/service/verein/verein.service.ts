import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { environment } from "src/environments/environment";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";

@Injectable({
  providedIn: "root",
})
export class VereinService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/organisationen";

  vereine = {};

  constructor(private http: HttpClient) {}

  getVereine(): Observable<IVerein[]> {
    return this.http
      .get<IVerein[]>(this.url)
      .pipe(catchError(this.handleError<IVerein[]>("getVereine", [])));
  }

  getStarts(): Observable<IOrganisationAnlassLink[]> {
    return this.http
      .get<IOrganisationAnlassLink[]>(this.url)
      .pipe(
        catchError(this.handleError<IOrganisationAnlassLink[]>("getStarts", []))
      );
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
