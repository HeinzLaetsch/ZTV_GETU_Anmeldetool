import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { environment } from "src/environments/environment";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";
import { ServiceHelper } from "src/app/utils/service-helper";

@Injectable({
  providedIn: "root",
})
export class VereinService extends ServiceHelper {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/organisationen";

  vereine = {};

  constructor(private http: HttpClient) {
    super();
  }

  getVereine(): Observable<IVerein[]> {
    return this.http.get<IVerein[]>(this.url).pipe(
      catchError((err, caught) => {
        return this.handleError("getStarts", err, caught);
      })
    );
  }

  getStarts(): Observable<IOrganisationAnlassLink[]> {
    return this.http.get<IOrganisationAnlassLink[]>(this.url).pipe(
      catchError((err, caught) => {
        return this.handleError("getStarts", err, caught);
      })
    );
  }
}
