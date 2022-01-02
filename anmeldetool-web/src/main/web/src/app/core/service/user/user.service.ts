import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { environment } from "src/environments/environment";
import { IRolle } from "../../model/IRolle";
import { IUser } from "../../model/IUser";
import { IWertungsrichter } from "../../model/IWertungsrichter";

@Injectable({
  providedIn: "root",
})
export class UserService {
  apiHost = `${environment.apiHost}`;
  private url: string = this.apiHost + "/admin/user";

  constructor(private http: HttpClient) {}

  getUser(): Observable<IUser[]> {
    // console.log("getUser called");
    return this.http
      .get<IUser[]>(this.url)
      .pipe(catchError(this.handleError<IUser[]>("getUser", [])));
  }
  getUserByBenutzername(benutzername: string): Observable<IUser> {
    // console.log("getUser called");
    return this.http
      .get<IUser>(this.url + "/benutzernamen/" + benutzername)
      .pipe(catchError(this.handleError<IUser>("getUserByBenutzername")));
  }

  /*
  updateUser(user: IUser): Observable<IUser> {
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.patch<IUser>(this.userUrl, user).subscribe(
      user => {
        this.currentUser = user;
        console.log('User: ' , user);
        emitter.emit(user);
      });
      return emitter.asObservable();
  }
  */
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
    console.log("updateRoles called: ", url, " , data: ", roles);
    return this.http
      .patch<IUser>(url, roles)
      .pipe(catchError(this.handleError<IUser>("updateRoles")));
  }

  getWertungsrichter(id: string): Observable<IWertungsrichter> {
    return this.http
      .get<IWertungsrichter>(this.url + "/" + id + "/wertungsrichter")
      .pipe(
        catchError(this.handleError<IWertungsrichter>("getWertungsrichter"))
      );
  }

  updateWertungsrichter(
    id: string,
    wertungsrichter: IWertungsrichter
  ): Observable<IWertungsrichter> {
    return this.http
      .put<IWertungsrichter>(
        this.url + "/" + id + "/wertungsrichter",
        wertungsrichter
      )
      .pipe(
        catchError(this.handleError<IWertungsrichter>("updateWertungsrichter"))
      );
  }

  deleteWertungsrichterForUserId(id: string): Observable<IWertungsrichter> {
    return this.http
      .delete<IWertungsrichter>(this.url + "/" + id + "/wertungsrichter")
      .pipe(
        catchError(this.handleError<IWertungsrichter>("deleteWertungsrichter"))
      );
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
