import { HttpClient } from '@angular/common/http';
import { computed, Injectable, signal } from '@angular/core';
import { catchError, mapTo, Observable, of, switchMap, tap, throwError } from 'rxjs';
import { IUser } from 'src/app/core/model/IUser';
import { IVerein } from 'src/app/verein/verein';
import { environment } from 'src/environments/environment';
import { ILoginData } from '../../model/ILoginData';
import { CachingUserService } from '../caching-services/caching.user.service';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  // Privates Signal für den Login-Status
  private readonly _isLoggedIn = signal(false);

  // Read-only Signal für die Komponenten
  readonly isLoggedIn = computed(() => this._isLoggedIn());

  private readonly apiHost = `${environment.apiHost}`;
  private readonly loginUrl = this.apiHost + '/admin/login';

  private token = '';

  currentUser!: IUser;
  private _currentVerein!: IVerein;
  private _selectedVerein!: IVerein;

  constructor(
    private http: HttpClient,
    private userService: CachingUserService,
  ) {}
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

  login(verein: IVerein, userName: string, password: string): Observable<IUser> {
    const loginData: ILoginData = {
      organisationId: verein.id,
      username: userName,
      password: password,
    };

    return this.http.post<IUser>(this.loginUrl, loginData).pipe(
      tap((user) => {
        this.currentUser = user;
        this.currentVerein = verein;
        this._isLoggedIn.set(true);
      }),
      switchMap((user) =>
        this.userService.loadUser().pipe(
          mapTo(user),
          // Keep login successful even if user cache refresh fails.
          catchError(() => of(user)),
        ),
      ),
      catchError((error) => {
        this._isLoggedIn.set(false);
        return throwError(() => error);
      }),
    );
  }
  /*
   */
  isAuthenticated(): boolean {
    return this.isLoggedIn();
  }

  hasRole(roleName: string): boolean {
    const rollen = this.currentUser?.rollen?.filter((role) => role.name === roleName.toUpperCase());
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
    if (this.isAuthenticated()) {
      return this.hasRole('ANMELDER') || this.isVereinsVerantwortlicher();
    } else {
      return false;
    }
  }

  isVereinsVerantwortlicher(): boolean {
    if (this.isAdministrator()) {
      return true;
    }
    if (this.isAuthenticated()) {
      return this.hasRole('VEREINSVERANTWORTLICHER');
    } else {
      return false;
    }
  }

  isWertungsrichter(): boolean {
    if (this.isAdministrator()) {
      return true;
    }
    if (this.isAuthenticated()) {
      return this.hasRole('WERTUNGSRICHTER');
    } else {
      return false;
    }
  }

  isAdministrator(): boolean {
    if (this.isAuthenticated()) {
      return this.hasRole('ADMINISTRATOR');
    } else {
      return false;
    }
  }

  isRechnungsbuero(): boolean {
    if (this.isAuthenticated()) {
      return this.hasRole('RECHNUNGSBUERO');
    } else {
      return false;
    }
  }
  isSekretariat(): boolean {
    if (this.isAuthenticated()) {
      return this.hasRole('SEKRETARIAT');
    } else {
      return false;
    }
  }

  isAnlassUser(): boolean {
    return this.isRechnungsbuero() || this.isSekretariat();
  }
}
