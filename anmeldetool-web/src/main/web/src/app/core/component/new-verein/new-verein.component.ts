import { Component, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  FormsModule,
  ReactiveFormsModule,
  UntypedFormBuilder,
  type UntypedFormGroup,
  Validators,
} from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { RouterModule } from '@angular/router';
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
  selector: 'lxt-new-verein',
  templateUrl: './new-verein.component.html',
  styleUrls: ['./new-verein.component.css'],
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
export class NewVereinComponent implements OnInit {
  //floatLabel = 'Always';
  appearance = 'outline';
  form: UntypedFormGroup;
  verein: IVerein = {
    id: '',
    name: '',
    verbandId: '',
  };

  _verantwortlicher: IUser = {
    id: '',
    organisationids: [''],
    name: '',
    vorname: '',
    password: '',
    benutzername: '',
    email: '',
    handy: '',
    aktiv: true,
  };

  userValid: boolean;

  selectedVerbandValue: string;
  selectedVerband = '';

  vereinsName = '';
  nachname = '';
  vorname = '';
  passwort = '';
  mobilNummer = '';
  eMailAdresse = '';

  mouseoverlogin: boolean;

  vereine: IVerein[];
  verbaende: IVerband[];

  error: boolean;
  errorMessage = undefined;

  constructor(
    private formBuilder: UntypedFormBuilder,
    public dialogRef: MatDialogRef<NewVereinComponent>,
    private authService: AuthService,
    private vereinService: VereinService,
    private verbandService: VerbandService,
    private userService: UserService,
  ) {
    this.form = this.formBuilder.group({
      vereinsNameControl: [this.vereinsName, Validators.required],
      verbandFormControl: ['', Validators.required],
    });
    this._verantwortlicher.name = this.nachname;
    this._verantwortlicher.vorname = this.vorname;
    this._verantwortlicher.password = this.passwort;
    this._verantwortlicher.email = this.eMailAdresse;
    this._verantwortlicher.handy = this.mobilNummer;
  }

  ngOnInit(): void {
    this.vereinService.getVereine().subscribe((vereine) => {
      this.vereine = vereine;
    });
    this.verbandService.getVerband().subscribe((verbaende) => {
      this.verbaende = verbaende;
    });
  }

  updateUserValid(valid: boolean): void {
    this.userValid = valid;
    // console.log("Valid changed", valid);
  }

  get verantwortlicher() {
    return this._verantwortlicher;
  }
  set verantwortlicher(verantwortlicher: IUser) {
    // console.log("Verantwortlicher changed", verantwortlicher);
    this._verantwortlicher = verantwortlicher;
  }
  save(): void {
    const rollen: IRolle[] = [
      { id: '', name: 'ANMELDER', aktiv: true },
      { id: '', name: 'VEREINSVERANTWORTLICHER', aktiv: true },
    ];

    this.verein.name = this.form.controls.vereinsNameControl.value;
    this.verein.verbandId = this.form.controls.verbandFormControl.value;
    console.log('Verband: ', this.verein.verbandId);

    const existing = this.vereine.filter((verein) => {
      return verein.name.toUpperCase() === this.verein.name.toUpperCase();
    });
    if (existing.length > 0) {
      this.error = true;
      this.errorMessage = 'Es existiert bereits ein Verein mit dem Namen: ' + this.verein.name;
      return;
    }

    this.verantwortlicher.benutzername = this.verantwortlicher.email;
    this._verantwortlicher.aktiv = true;
    this._verantwortlicher.rollen = rollen;
    this.userService.getUserByBenutzername(this.verantwortlicher.benutzername).subscribe(
      (user) => {
        if (user) {
          this.error = true;
          this.errorMessage =
            'Es existiert bereits ein Benutzer mit dem Benutzernamen: ' + this.verantwortlicher.benutzername;
        } else {
          this.authService.createVereinAndUser(this.verein, this._verantwortlicher).subscribe(
            (loggedInUser) => {
              console.log('Neuer Verein inklusive User kreiert ', loggedInUser.benutzername);
              // Immer erster !!
              this.verein.id = loggedInUser.organisationids[0];
              this.authService
                .login(this.verein, loggedInUser.benutzername, this._verantwortlicher.password)
                .subscribe({
                  next(data) {
                    this.router.navigate(['anlass']);

                    /* ToDo check if preload is realy neccessary
                         self.userService.reset().subscribe((result) => {
                           // console.log("Login UserService loaded");
                         });
                         */
                    // TODO check if preload is realy neccessary
                    /*
                         self.teilnehmerService
                           .loadTeilnehmer(self.verein)
                           .subscribe((result) => {
                             // console.log("Login teilnehmerService loaded");
                           });
                           */
                  },
                  error(msg) {
                    console.log('Error: ', msg);
                  },
                });

              this.dialogRef.close('OK');
            },
            (error) => {
              this.error = true;
              this.errorMessage = error;
            },
          );
        }
      },
      (error) => {
        console.error('Error', error);
      },
    );

    console.log('Save');
  }

  getError(): string {
    console.log(this.form.errors);
    return '';
  }
  cancel(): void {
    this.dialogRef.close('CANCEL');
    console.log('Cancel');
  }
}
