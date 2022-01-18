import { HttpClient } from "@angular/common/http";
import { EventEmitter, Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { IUser } from "src/app/core/model/IUser";
import { IVerein } from "src/app/verein/verein";
import { environment } from "src/environments/environment";
import { ILoginData } from "../../model/ILoginData";
import { CachingUserService } from "../caching-services/caching.user.service";
import { CachingVereinService } from "../caching-services/caching.verein.service";

@Injectable({
  providedIn: "root",
})
export class AuthService {
  apiHost = `${environment.apiHost}`;
  private loginUrl = this.apiHost + "/admin/login";
  private VereineUrl = this.apiHost + "/admin/organisationen";
  private userUrl = this.apiHost + "/admin/user";

  // isLoggedIn: boolean = false;
  token: string;

  currentUser: IUser;
  private _currentVerein: IVerein;
  private _selectedVerein: IVerein;

  constructor(
    private http: HttpClient,
    private vereinService: CachingVereinService,
    private userService: CachingUserService
  ) {
    // console.info("Service created");
    this.token = "undefined";
  }
  set currentVerein(verein: IVerein) {
    this._currentVerein = verein;
  }
  get currentVerein(): IVerein {
    if (!this.isAdministrator()) {
      return this._currentVerein;
    } else {
      if (this._selectedVerein) {
        return this._selectedVerein;
      }
      return this._currentVerein;
    }
  }

  setToken(token: string) {
    this.token = token;
  }
  getToken(): string {
    return this.token;
  }

  selectVerein(verein: IVerein): void {
    if (this.isAdministrator()) {
      this._selectedVerein = verein;
    }
  }
  createVereinAndUser(verein: IVerein, user: IUser): Observable<IUser> {
    // console.log("Verein 1: ", verein);
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.post<IVerein>(this.VereineUrl, verein).subscribe(
      (verein) => {
        this.currentVerein = verein;
        // console.log("Verein 2: ", verein);
        user.organisationids = [verein.id];
        this.vereinService
          .reset()
          .subscribe((result) =>
            console.log("Vereins Cache reloaded: ", result)
          );
        this.createUser(user).subscribe(
          (user) => {
            emitter.emit(user);
          },
          (error) => {
            console.error("Error", error);
            emitter.error("Fehler beim Erstellen des Benutzers");
          }
        );
      },
      (error) => {
        console.error("Error", error);
        emitter.error("Fehler beim Erstellen des Vereins");
      }
    );
    return emitter.asObservable();
  }

  createUser(user: IUser): Observable<IUser> {
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.post<IUser>(this.userUrl, user).subscribe(
      (user) => {
        // this.currentUser = user;
        console.log("User: ", user);
        emitter.emit(user);
      },
      (error) => {
        console.error(error);
        emitter.error("Fehler beim erstellen des Users");
      }
    );
    return emitter.asObservable();
  }

  updateUser(user: IUser): Observable<IUser> {
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.patch<IUser>(this.userUrl, user).subscribe((user) => {
      // this.currentUser = user;
      // console.log("User: ", user);
      emitter.emit(user);
    });
    return emitter.asObservable();
  }

  login(
    verein: IVerein,
    userName: string,
    password: string
  ): Observable<IUser> {
    const loginData: ILoginData = {
      organisationId: verein.id,
      username: userName,
      password: password,
    };
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.post<IUser>(this.loginUrl, loginData).subscribe(
      (user) => {
        // console.log("Response: ", user);
        this.currentUser = user;
        this.currentVerein = verein;
        this.userService.loadUser().subscribe((result) => {
          // console.log("Users loaded: ", result);
        });
        emitter.emit(user);
      },
      (error) => {
        console.log("Error: ", error);
        emitter.error(error);
      },
      () => {
        console.log("Completed: ");
      }
    );
    return emitter.asObservable();
    //  .pipe(catchError(this.handleError<IUser>()));
  }
  /*
   */
  isAuthenticated(): boolean {
    if (this.currentUser == null) {
      // console.log('not logged in');
      return false;
    } else {
      //console.log('logged in: ' , this.currentUser);
      return true;
    }
  }

  private hasRole(roleName: string): boolean {
    const rollen = this.currentUser.rollen.filter(
      (role) => role.name === roleName
    );
    // console.log('Rollen: ' , rollen, ' , Name: ', roleName);
    if (rollen && rollen.length > 0) {
      return rollen[0].aktiv;
    }
    return false;
  }

  isVereinsAnmmelder(): boolean {
    if (this.isAdministrator()) {
      return true;
    }
    if (this.isAuthenticated()) return this.hasRole("ANMELDER");
    else return false;
  }

  isVereinsVerantwortlicher(): boolean {
    if (this.isAdministrator()) {
      return true;
    }
    if (this.isAuthenticated()) return this.hasRole("VEREINSVERANTWORTLICHER");
    else return false;
  }

  isWertungsrichter(): boolean {
    if (this.isAdministrator()) {
      return true;
    }
    if (this.isAuthenticated()) return this.hasRole("WERTUNGSRICHTER");
    else return false;
  }

  isAdministrator(): boolean {
    if (this.isAuthenticated()) return this.hasRole("ADMINISTRATOR");
    else return false;
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
