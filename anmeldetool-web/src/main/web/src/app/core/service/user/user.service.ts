import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { environment } from "src/environments/environment";
import { IRolle } from "../../model/IRolle";
import { IUser } from "../../model/IUser";
import { IWertungsrichter } from "../../model/IWertungsrichter";
import { ServiceHelper } from "src/app/utils/service-helper";

@Injectable({
  providedIn: "root",
})
export class UserService extends ServiceHelper {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/user";

  constructor(private http: HttpClient) {
    super();
  }

  getUser(): Observable<IUser[]> {
    console.log("getUser called");
    return this.http.get<IUser[]>(this.url).pipe(
      catchError((err, caught) => {
        return this.handleError("getUser", err, caught);
      })
    );
  }
  getUserByBenutzername(benutzername: string): Observable<IUser> {
    // console.log("getUser called");
    return this.http
      .get<IUser>(this.url + "/benutzernamen/" + benutzername)
      .pipe(
        catchError((err, caught) => {
          return this.handleError("getUserByBenutzername", err, caught);
        })
      );
  }
  updateRoles(
    user: IUser,
    verein: IVerein,
    roles: IRolle[]
  ): Observable<IUser> {
    const url =
      this.url +
      "/" +
      user.id +
      "/" +
      "organisationen" +
      "/" +
      verein.id +
      "/rollen";
    // console.log("updateRoles called: ", url, " , data: ", roles);
    return this.http.patch<IUser>(url, roles).pipe(
      catchError((err, caught) => {
        return this.handleError("updateRoles", err, caught);
      })
    );
  }

  getWertungsrichter(id: string): Observable<IWertungsrichter> {
    return this.http
      .get<IWertungsrichter>(this.url + "/" + id + "/wertungsrichter")
      .pipe(
        catchError((err, caught) => {
          return this.handleError("getWertungsrichter", err, caught);
        })
      );
  }

  updateWertungsrichter(
    id: string,
    wertungsrichter: IWertungsrichter
  ): Observable<any> {
    return this.http
      .put<IWertungsrichter>(
        this.url + "/" + id + "/wertungsrichter",
        wertungsrichter
      )
      .pipe(
        catchError((err, caught) => {
          return this.handleError("updateWertungsrichter", err, caught);
        })
      );
  }

  deleteWertungsrichterForUserId(id: string): Observable<IWertungsrichter> {
    return this.http
      .delete<IWertungsrichter>(this.url + "/" + id + "/wertungsrichter")
      .pipe(
        catchError((err, caught) => {
          return this.handleError(
            "deleteWertungsrichterForUserId",
            err,
            caught
          );
        })
      );
  }
}
