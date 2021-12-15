import { Injectable } from "@angular/core";
import { HttpClient, HttpParams } from "@angular/common/http";
import { catchError } from "rxjs/operators";
import { IUser } from "../../model/IUser";
import { Observable, of } from "rxjs";
import { IRolle } from "../../model/IRolle";
import { IWertungsrichter } from "../../model/IWertungsrichter";

@Injectable({
  providedIn: "root",
})
export class UserService {
  private url: string = "http://localhost:8088/admin/user";

  constructor(private http: HttpClient) {}

  getUser(): Observable<IUser[]> {
    console.log("getUser called");
    return this.http
      .get<IUser[]>(this.url)
      .pipe(catchError(this.handleError<IUser[]>("getUser", [])));
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
  updateRoles(user: IUser, roles: IRolle[]): Observable<IUser> {
    const url =
      this.url +
      "/" +
      user.id +
      "/" +
      "organisationen" +
      "/" +
      user.organisationid +
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

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
