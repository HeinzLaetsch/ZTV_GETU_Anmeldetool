import { HttpClient } from "@angular/common/http";
import { EventEmitter, Injectable } from "@angular/core";
import { Observable, of, throwError } from "rxjs";
import { IUser } from "src/app/core/model/IUser";
import { IVerein } from "src/app/verein/verein";
import { ILoginData } from "../../model/ILoginData";
import { CachingUserService } from "../caching-services/caching.user.service";
import { CachingVereinService } from "../caching-services/caching.verein.service";

@Injectable({
  providedIn: "root",
})
export class AuthService {
  private loginUrl = "http://localhost:8088/admin/login";
  private VereineUrl = "http://localhost:8088/admin/organisationen";
  private userUrl = "http://localhost:8088/admin/user";

  isLoggedIn: boolean = false;
  token: string;

  currentUser: IUser;
  currentVerein: IVerein;

  constructor(
    private http: HttpClient,
    private vereinService: CachingVereinService,
    private userService: CachingUserService
  ) {
    console.info("Service created");
    this.token = "undefined";
  }

  setToken(token: string) {
    this.token = token;
  }
  getToken(): string {
    return this.token;
  }

  createVereinAndUser(verein: IVerein, user: IUser): Observable<IUser> {
    console.log("Verein 1: ", verein);
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.post<IVerein>(this.VereineUrl, verein).subscribe((verein) => {
      this.currentVerein = verein;
      console.log("Verein 2: ", verein);
      user.organisationid = verein.id;
      this.vereinService
        .reset()
        .subscribe((result) => console.log("Vereins Cache reloaded: ", result));
      this.createUser(user).subscribe((user) => {
        emitter.emit(user);
        this.userService
          .reset()
          .subscribe((result) => console.log("User Cache reloaded: ", result));
      });
    });
    return emitter.asObservable();
  }

  createUser(user: IUser): Observable<IUser> {
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.post<IUser>(this.userUrl, user).subscribe((user) => {
      this.currentUser = user;
      console.log("User: ", user);
      emitter.emit(user);
    });
    return emitter.asObservable();
  }

  updateUser(user: IUser): Observable<IUser> {
    const emitter: EventEmitter<IUser> = new EventEmitter();
    this.http.patch<IUser>(this.userUrl, user).subscribe((user) => {
      this.currentUser = user;
      console.log("User: ", user);
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
        console.log("Response: ", user);
        this.currentUser = user;
        this.currentVerein = this.vereinService.getVereinById(
          user.organisationid
        );
        this.userService.loadUser().subscribe((result) => {
          console.log("Users loaded: ", result);
        });
        emitter.emit(user);
      },
      (error) => {
        console.log("Error: ", error);
        return throwError(error);
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

  isVereinsAnmmelder() {
    return this.hasRole("ANMELDER");
  }

  isVereinsVerantwortlicher() {
    return this.hasRole("VEREINSVERANTWORTLICHER");
  }

  isWertungsrichter() {
    return this.hasRole("WERTUNGSRICHTER");
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
}
