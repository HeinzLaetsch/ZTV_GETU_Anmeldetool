import { HttpClient, HttpParams } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "src/environments/environment";
import { IRolle } from "../../model/IRolle";
import { IUser } from "../../model/IUser";
import { ServiceHelper } from "src/app/utils/service-helper";

@Injectable({
  providedIn: "root",
})
export class RoleService extends ServiceHelper {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/role";

  constructor(private http: HttpClient) {
    super();
  }

  getRoles(): Observable<IRolle[]> {
    // console.log("getRoles called");
    const params = new HttpParams().set("userId", "");
    return this.http.get<IRolle[]>(this.url, { params }).pipe(
      catchError((err, caught) => {
        return this.handleError("getRoles", err, caught);
      })
    );
  }

  getRolesForUser(user: IUser): Observable<IRolle[]> {
    // console.log("getRolesForUser called");
    const params = new HttpParams().set("userId", user.id);
    return this.http.get<IRolle[]>(this.url, { params }).pipe(
      catchError((err, caught) => {
        return this.handleError("getRolesForUser", err, caught);
      })
    );
  }
}
