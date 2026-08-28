import { HttpClient } from '@angular/common/http';
import { computed, inject, Injectable, signal } from '@angular/core';
import { catchError, mapTo, Observable, of, switchMap, tap, throwError } from 'rxjs';
import { IUser } from 'src/app/core/model/IUser';
import { IVerein } from 'src/app/verein/verein';
import { environment } from 'src/environments/environment';
import { ILoginData } from '../../model/ILoginData';
import { CachingUserService } from '../caching-services/caching.user.service';
import { UserActions } from '../../redux/user';
import { AppState } from '../../redux/core.state';
import { Store } from '@ngrx/store';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private store: Store<AppState> = inject(Store<AppState>);
  
  // Privates Signal für den Login-Status
  private readonly _isLoggedIn = signal(false);

  private readonly _currentUser = signal<IUser | null>(null);

  // Read-only Signal für die Komponenten
  readonly isLoggedIn = computed(() => this._isLoggedIn());

  readonly isAuthenticatedSig = computed(() => this.isLoggedIn());

  readonly isAdministratorSig = computed(() => this.isAuthenticatedSig() && this.hasRole('ADMINISTRATOR'));

  readonly isVereinsVerantwortlicherSig = computed(
    () => this.isAdministratorSig() || (this.isAuthenticatedSig() && this.hasRole('VEREINSVERANTWORTLICHER')),
  );

  readonly isVereinsAnmmelderSig = computed(
    () =>
      this.isAdministratorSig() ||
      (this.isAuthenticatedSig() && (this.hasRole('ANMELDER') || this.isVereinsVerantwortlicherSig())),
  );

  readonly isWertungsrichterSig = computed(
    () => this.isAdministratorSig() || (this.isAuthenticatedSig() && this.hasRole('WERTUNGSRICHTER')),
  );

  readonly isRechnungsbueroSig = computed(() => this.isAuthenticatedSig() && this.hasRole('RECHNUNGSBUERO'));

  readonly isSekretariatSig = computed(() => this.isAuthenticatedSig() && this.hasRole('SEKRETARIAT'));

  readonly isAnlassUserSig = computed(() => this.isRechnungsbueroSig() || this.isSekretariatSig());

  private readonly apiHost = `${environment.apiHost}`;
  private readonly loginUrl = this.apiHost + '/admin/login';

  private token = '';

  get currentUser(): IUser | null {
    return this._currentUser();
  }

  set currentUser(user: IUser | null) {
    this._currentUser.set(user);
  }

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
    if (!this.isAdministratorSig()) {
      return this._currentVerein;
    } else {
      if (this._selectedVerein) {
        return this._selectedVerein;
      }
      return this._currentVerein;
    }
  }

  setToken(token: string): void {
    this.token = token;
  }
  getToken(): string {
    return this.token;
  }

  selectVerein(verein: IVerein): void {
    if (this.isAdministratorSig()) {
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
        this.store.dispatch(UserActions.loadAllUserInvoked());
        this._isLoggedIn.set(true);
      }),
      catchError((error) => {
        this._isLoggedIn.set(false);
        return throwError(() => error);
      }),
    );
  }
  /*
   */
  isAuthenticated(): boolean {
    return this.isAuthenticatedSig();
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
    return this.isVereinsAnmmelderSig();
  }

  isVereinsVerantwortlicher(): boolean {
    return this.isVereinsVerantwortlicherSig();
  }

  isWertungsrichter(): boolean {
    return this.isWertungsrichterSig();
  }

  isAdministrator(): boolean {
    return this.isAdministratorSig();
  }

  isRechnungsbuero(): boolean {
    return this.isRechnungsbueroSig();
  }
  isSekretariat(): boolean {
    return this.isSekretariatSig();
  }

  isAnlassUser(): boolean {
    return this.isAnlassUserSig();
  }
}
