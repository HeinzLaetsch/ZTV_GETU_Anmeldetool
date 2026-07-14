import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AbstractControl, FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
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
import { Store } from '@ngrx/store';
import { type Observable, combineLatest, of } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingUserService } from 'src/app/core/service/caching-services/caching.user.service';
import type { IVerein } from 'src/app/verein/verein';
import type { AppState } from '../../redux/core.state';
import { selectAlleVereine } from '../../redux/verein';

@Component({
  selector: 'ztv-login-dialog',
  templateUrl: './login-dialog.component.html',
  styleUrls: ['./login-dialog.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
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
export class LoginComponent {
  appearance = 'outline';
  loginError = false;
  errorMessage: string | undefined = undefined;

  loginForm = new FormGroup({
    verein: new FormControl<IVerein | string | null>(null, {
      validators: [Validators.required, this.vereinSelectionValidator],
    }),
    userName: new FormControl('', {
      nonNullable: true,
      validators: [Validators.required],
    }),
    password: new FormControl('', {
      nonNullable: true,
      validators: [Validators.required],
    }),
  });

  readonly vereine$: Observable<IVerein[]>;
  readonly filteredOptions: Observable<IVerein[]>;

  constructor(
    //public dialogRef: MatDialogRef<LoginDialogComponent>,
    private authService: AuthService,
    private store: Store<AppState>,
    private userService: CachingUserService,
    private router: Router,
  ) {
    this.vereine$ = this.store.select(selectAlleVereine);
    this.filteredOptions = combineLatest([
      this.vereine$,
      this.vereinControl.valueChanges.pipe(startWith(this.vereinControl.value)),
    ]).pipe(
      map(([vereine, value]) => {
        const name = typeof value === 'string' ? value : (value?.name ?? '');

        return name ? this._filter(vereine, name) : vereine.slice();
      }),
    );
  }

  get vereinControl(): FormControl<IVerein | string | null> {
    return this.loginForm.controls.verein;
  }

  get userNameControl(): FormControl<string> {
    return this.loginForm.controls.userName;
  }

  get passwordControl(): FormControl<string> {
    return this.loginForm.controls.password;
  }

  private vereinSelectionValidator(control: AbstractControl<IVerein | string | null>) {
    const value = control.value;
    if (!value) {
      return null;
    }
    return typeof value === 'string' ? { vereinSelection: true } : null;
  }

  private _filter(vereine: IVerein[], name: string): IVerein[] {
    const filterValue = name.toLowerCase();

    return vereine.filter((option) => option.name.toLowerCase().includes(filterValue));
  }

  displayFn(verein: IVerein): string {
    return verein && verein.name ? verein.name : '';
  }

  login() {
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    const verein = this.vereinControl.value;
    if (!verein || typeof verein === 'string') {
      this.vereinControl.setErrors({ vereinSelection: true });
      this.vereinControl.markAsTouched();
      return;
    }

    const { userName, password } = this.loginForm.getRawValue();

    this.loginError = false;
    try {
      this.authService.login(verein, userName, password).subscribe(
        (result) => {
          //this.dialogRef.close('OK');
          this.loginError = false;
          this.userService.loadUser().subscribe((result) => {
            // TODO register Error
          });
          // TODO check if preload is realy neccessary
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
    //this.dialogRef.close();
  }
  newVereinClicked(): void {
    console.log('New Anmelder clicked');
    //this.dialogRef.close(1);
  }

  newAnmelderClicked(): void {
    console.log('New Anmelder clicked');
    //this.dialogRef.close(2);
  }
}
