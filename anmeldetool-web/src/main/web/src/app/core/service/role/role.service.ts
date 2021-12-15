import { HttpClient, HttpParams } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { IRolle } from "../../model/IRolle";
import { IUser } from "../../model/IUser";

@Injectable({
  providedIn: "root",
})
export class RoleService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/role";

  constructor(private http: HttpClient) {}

  getRoles(): Observable<IRolle[]> {
    console.log("getRoles called");
    const params = new HttpParams().set("userId", "");
    return this.http
      .get<IRolle[]>(this.url, { params })
      .pipe(catchError(this.handleError<IRolle[]>("getRoles", [])));
  }

  getRolesForUser(user: IUser): Observable<IRolle[]> {
    console.log("getRolesForUser called");
    const params = new HttpParams().set("userId", user.id);
    return this.http
      .get<IRolle[]>(this.url, { params })
      .pipe(catchError(this.handleError<IRolle[]>("getRolesForUser", [])));
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
