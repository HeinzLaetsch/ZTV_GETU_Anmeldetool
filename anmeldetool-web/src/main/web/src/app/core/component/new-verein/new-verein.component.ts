import { Component, signal, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, UntypedFormBuilder, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { Router, RouterModule } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop'; // <-- Wichtig für die Umwandlung
import { switchMap } from 'rxjs';
import type { IVerband } from 'src/app/core/model/IVerband';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { VerbandService } from 'src/app/core/service/verband/verband.service';
import { VereinService } from 'src/app/core/service/verein/verein.service';
import type { IVerein } from 'src/app/verein/verein';
import type { IRolle } from '../../model/IRolle';
import type { IUser } from '../../model/IUser';
import { UserService } from '../../service/user/user.service';
import { UserComponent } from 'src/app/shared/component/user/user.component';

@Component({
  selector: 'app-new-verein',
  templateUrl: './new-verein.component.html',
  styleUrls: ['./new-verein.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatCheckboxModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    RouterModule,
    UserComponent,
  ],
})
export class NewVereinComponent {
  // Moderne Dependency Injection via inject()
  private formBuilder = inject(UntypedFormBuilder);
  public dialogRef = inject(MatDialogRef<NewVereinComponent>);
  private authService = inject(AuthService);
  private vereinService = inject(VereinService);
  private verbandService = inject(VerbandService);
  private userService = inject(UserService);
  private router = inject(Router);

  appearance = 'outline';
  form = this.formBuilder.group({
    vereinsNameControl: ['', Validators.required],
    verbandFormControl: ['', Validators.required],
  });

  // Lokaler State als veränderbare Signale
  userValid = signal(false);
  mouseoverlogin = signal(false);
  error = signal(false);
  errorMessage = signal<string | undefined>(undefined);

  // Das Objekt wird weiterhin im Speicher gehalten für die API-Logik
  verein: IVerein = {
    id: '',
    name: '',
    verbandId: '',
  };

  readonly verantwortlicher = signal<IUser>({
    id: '',
    organisationids: [''],
    name: '',
    vorname: '',
    password: '',
    benutzername: '',
    email: '',
    handy: '',
    aktiv: true,
  });

  // 1. Observables direkt in Lese-Signale umwandeln
  // Initialwert ist ein leeres Array [], damit im Template sofort eine Liste da ist.
  vereine = toSignal(this.vereinService.getVereine(), { initialValue: [] as IVerein[] });
  verbaende = toSignal(this.verbandService.getVerband(), { initialValue: [] as IVerband[] });

  updateUserValid(valid: boolean): void {
    this.userValid.set(valid);
  }

  updateVerantwortlicher(user: IUser): void {
    this.verantwortlicher.set(user);
  }

  save(): void {
    const rollen: IRolle[] = [
      { id: '', name: 'ANMELDER', aktiv: true },
      { id: '', name: 'VEREINSVERANTWORTLICHER', aktiv: true },
    ];

    // Daten aus dem Formular holen
    this.verein.name = this.form.controls.vereinsNameControl.value ?? '';
    this.verein.verbandId = this.form.controls.verbandFormControl.value ?? '';

    // 2. Existenzprüfung mit dem neuen vereine-Signal()
    const existing = this.vereine().filter((v) => {
      return v.name.toUpperCase() === this.verein.name.toUpperCase();
    });

    if (existing.length > 0) {
      this.error.set(true);
      this.errorMessage.set('Es existiert bereits ein Verein mit dem Namen: ' + this.verein.name);
      return;
    }

    const verantwortlicher = {
      ...this.verantwortlicher(),
      benutzername: this.verantwortlicher().email,
      aktiv: true,
      rollen,
    };
    const password = verantwortlicher.password ?? '';

    // Diese Kette bleibt ein Observable, da es sich um eine einmalige "Aktion" (HTTP Post) handelt.
    this.userService.getUserByBenutzername(verantwortlicher.benutzername).subscribe({
      next: (user) => {
        if (user) {
          this.error.set(true);
          this.errorMessage.set(
            'Es existiert bereits ein Benutzer mit dem Benutzernamen: ' + verantwortlicher.benutzername,
          );
        } else {
          this.vereinService
            .createVerein(this.verein)
            .pipe(
              switchMap((createdVerein) => {
                const userWithOrganisation: IUser = {
                  ...verantwortlicher,
                  organisationids: [createdVerein.id],
                };
                this.authService.currentVerein = createdVerein;
                this.verein = createdVerein;
                return this.userService.createUser(userWithOrganisation);
              }),
            )
            .subscribe({
              next: (createdUser) => {
                this.authService.login(this.verein, createdUser.benutzername, password).subscribe({
                  next: () => {
                    this.router.navigate(['anlaesse']);
                  },
                  error: (msg) => {
                    console.error('Error: ', msg);
                  },
                });
                this.dialogRef.close('OK');
              },
              error: (err) => {
                this.error.set(true);
                this.errorMessage.set(err);
              },
            });
        }
      },
      error: (err) => {
        console.error('Error', err);
      },
    });
  }

  getError(): string {
    return '';
  }

  cancel(): void {
    this.dialogRef.close('CANCEL');
  }
}
