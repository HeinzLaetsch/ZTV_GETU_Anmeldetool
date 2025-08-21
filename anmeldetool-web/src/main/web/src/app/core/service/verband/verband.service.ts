import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { IVerband } from "../../model/IVerband";
import { ServiceHelper } from "src/app/utils/service-helper";

@Injectable({
  providedIn: "root",
})
export class VerbandService extends ServiceHelper {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/verbaende";

  constructor(private http: HttpClient) {
    super();
  }

  getVerband(): Observable<IVerband[]> {
    return this.http.get<IVerband[]>(this.url).pipe(
      catchError((err, caught) => {
        return this.handleError("getVerband", err, caught);
      })
    );
  }
}
