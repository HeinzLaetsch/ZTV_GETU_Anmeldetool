import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatAutocompleteModule, MatAutocompleteSelectedEvent } from '@angular/material/autocomplete';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { Router, RouterModule } from '@angular/router';
import { Store } from '@ngrx/store';
import { combineLatest, take } from 'rxjs';
import type { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import type { IVerein } from 'src/app/verein/verein';
import type { AppState } from '../../redux/core.state';
import { selectAlleVereine } from '../../redux/verein';
import { NewVereinComponent } from '../new-verein/new-verein.component';
import { vereinSelectionValidator } from './verein-selection-validator';

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
export class LoginComponent implements OnInit {
  appearance = 'outline';
  loginError = false;
  errorMessage: string | undefined = undefined;
  // , this.vereinSelectionValidator
  private fb = inject(FormBuilder);
  verein = new FormControl<IVerein | string | null>('', [vereinSelectionValidator]);

  loginForm = this.fb.group({
    //new FormGroup({
    verein: this.verein,
    userName: new FormControl(
      '',
      //nonNullable: true,
      [Validators.required, Validators.email],
    ),
    password: new FormControl(
      '',
      //nonNullable: true,
      Validators.required,
    ),
  });

  readonly vereine$: Observable<IVerein[]>;
  filteredOptions: Observable<IVerein[]>;

  constructor(
    //public dialogRef: MatDialogRef<LoginDialogComponent>,
    private authService: AuthService,
    private store: Store<AppState>,
    private router: Router,
    private dialog: MatDialog,
  ) {
    this.vereine$ = this.store.select(selectAlleVereine);
  }
  ngOnInit(): void {
    this.filteredOptions = combineLatest([
      this.vereine$,
      this.loginForm.controls.verein.valueChanges.pipe(startWith(this.loginForm.controls.verein.value)),
    ]).pipe(
      map(([vereine, value]) => {
        console.log('### FILTER:', value);
        const name = typeof value === 'string' ? value : (value?.name ?? '');
        console.log('### FILTER:', name ? this._filter(vereine, name) : vereine.slice());
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

  private _filter(vereine: IVerein[], name: string): IVerein[] {
    const filterValue = name.toLowerCase();

    return vereine.filter((option) => option.name.toLowerCase().includes(filterValue));
  }

  onVereinSelected(event: MatAutocompleteSelectedEvent): void {
    const ausgewaehlterVerein = event.option.value; // Das komplette IVerein Objekt
    console.log('Verein über Option ausgewählt:', ausgewaehlterVerein);

    //this.vereinControl.setValue(ausgewaehlterVerein);
    this.vereinControl.updateValueAndValidity();

    console.log(
      'VereinControl value nach Auswahl:',
      this.loginForm.controls.verein.value,
      this.loginForm.controls.verein.valid,
      this.loginForm.controls.verein.errors,
    );
    console.log('userNameControl value nach Auswahl:', this.userNameControl.valid, this.userNameControl.errors);
    console.log('passwordControl value nach Auswahl:', this.passwordControl.valid, this.passwordControl.errors);
  }

  displayFn = (value: IVerein | string | null): string => {
    console.log('### displayFn:', value);
    console.log('### typeof:', typeof value);
    if (typeof value === 'string') {
      return value;
    }

    return value?.name ?? '';
  };

  login(): void {
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
      this.authService
        .login(verein, userName, password)
        .pipe(take(1))
        .subscribe({
          next: () => {
            //this.dialogRef.close('OK');
            this.loginError = false;
            // AuthService.login already refreshes the user cache.
          },
          error: (error) => {
            this.loginError = true;
            this.errorMessage = 'Fehler beim Login, Verein, Name oder Passwort falsch, error' + error;
          },
        });
    } catch (error) {
      console.error('Error logging in: ' + error);
      this.loginError = true;
    }
  }

  cancel(): void {
    this.router.navigate(['anlass']);
  }

  onNoClick(): void {
    //this.dialogRef.close();
  }
  newVereinClicked(): void {
    console.log('New Verein clicked');
    this.dialog.open(NewVereinComponent, {
      width: '600px',
      height: 'auto',
      maxHeight: '90vh',
      disableClose: true,
      panelClass: 'ztv-dialog',
    });
  }

  newAnmelderClicked(): void {
    console.log('New Anmelder clicked');
    //this.dialogRef.close(2);
  }
}
