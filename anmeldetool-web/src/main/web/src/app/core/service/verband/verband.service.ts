import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { IVerband } from "../../model/IVerband";

@Injectable({
  providedIn: "root",
})
export class VerbandService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/verbaende";

  constructor(private http: HttpClient) {}

  getVerband(): Observable<IVerband[]> {
    return this.http
      .get<IVerband[]>(this.url)
      .pipe(catchError(this.handleError<IVerband[]>("getVerband", [])));
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
