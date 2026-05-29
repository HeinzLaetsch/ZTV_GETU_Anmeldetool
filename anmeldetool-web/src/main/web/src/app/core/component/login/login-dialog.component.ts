import { Component, EventEmitter, type OnInit, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, UntypedFormControl, Validators } from '@angular/forms';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { Router, RouterModule } from '@angular/router';
import { select, Store } from '@ngrx/store';
import { type Observable, of } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingUserService } from 'src/app/core/service/caching-services/caching.user.service';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import type { IVerein } from 'src/app/verein/verein';
import type { AppState } from '../../redux/core.state';
import { selectAlleVereine } from '../../redux/verein';

@Component({
  selector: 'lxt-login-dialog',
  templateUrl: './login-dialog.component.html',
  styleUrls: ['./login-dialog.component.css'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatDialogModule,
    MatAutocompleteModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatCheckboxModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    RouterModule,
  ],
})
export class LoginDialogComponent extends SubscriptionHelper implements OnInit {
  @Output()
  showDialog = new EventEmitter<number>();

  appearance = 'outline';
  loginError: boolean;
  errorMessage = undefined;

  vereine$: Observable<IVerein[]>;
  vereine: IVerein[];
  username: string;
  password: string;

  vwVereinControl = new UntypedFormControl('', Validators.required);
  vwUserNameControl = new UntypedFormControl('', Validators.required);
  vwPasswordControl = new UntypedFormControl('', Validators.required);

  filteredOptions: Observable<IVerein[]>;

  constructor(
    public dialogRef: MatDialogRef<LoginDialogComponent>,
    private authService: AuthService,
    private store: Store<AppState>,
    private userService: CachingUserService,
    private router: Router,
  ) {
    super();
    this.vereine$ = this.store.pipe(select(selectAlleVereine));
    this.loginError = false;
  }

  ngOnInit() {
    this.registerSubscription(
      this.vereine$.subscribe((data) => {
        this.vereine = data;
        this.filteredOptions = this.vwVereinControl.valueChanges.pipe(
          startWith(''),
          map((value) => (typeof value === 'string' ? value : value.name)),
          map((name) => (name ? this._filter(name) : this.vereine.slice())),
        );
      }),
    );
  }
  private _filter(name: string): IVerein[] {
    const filterValue = name.toLowerCase();

    return this.vereine.filter((option) => option.name.toLowerCase().includes(filterValue));
  }

  displayFn(verein: IVerein): string {
    return verein && verein.name ? verein.name : '';
  }

  login() {
    this.loginError = false;
    // console.log("Login: ", this.vwUserNameControl.value);
    try {
      this.authService
        .login(this.vwVereinControl.value, this.vwUserNameControl.value, this.vwPasswordControl.value)
        // .pipe(catchError(this.handleError<boolean>("login")))
        .subscribe(
          (result) => {
            this.dialogRef.close('OK');
            this.loginError = false;
            this.userService.loadUser().subscribe((result) => {
              // TODO register Error
            });
            // TODO check if preload is realy neccessary
            /*
            self.teilnehmerService
              .loadTeilnehmer(self.vwVereinControl.value)
              .subscribe((result) => {
                // TODO register Error
              });
              */
          },
          (error) => {
            this.loginError = true;
            this.errorMessage = 'Fehler beim Login, Verein, Name oder Passwort falsch';
          },
        );
    } catch (error) {
      console.error('Error logging in: ' + error);
      this.loginError = true;
    }
  }

  private handleError<T>(operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
  cancel() {
    this.router.navigate(['anlass']);
  }

  onNoClick(): void {
    this.dialogRef.close();
  }
  newVereinClicked(): void {
    console.log('New Anmelder clicked');
    this.dialogRef.close(1);
    this.showDialog.emit(1);
  }

  newAnmelderClicked(): void {
    console.log('New Anmelder clicked');
    this.dialogRef.close(2);
    this.showDialog.emit(2);
  }
}
