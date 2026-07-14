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
import { Router, RouterModule } from '@angular/router';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingUserService } from 'src/app/core/service/caching-services/caching.user.service';
import { VereinService } from 'src/app/core/service/verein/verein.service';
import { UserService } from 'src/app/core/service/user/user.service';
import type { IVerein } from 'src/app/verein/verein';

@Component({
  selector: 'lxt-new-anmelder',
  templateUrl: './new-anmelder.component.html',
  styleUrls: ['./new-anmelder.component.css'],
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
  ],
})
export class NewAnmelderComponent implements OnInit {
  //floatLabel = 'Always';
  appearance = 'outline';
  form: UntypedFormGroup;
  vereine: IVerein[];
  verein: IVerein = {
    id: '-1',
    name: '',
    verbandId: '',
  };

  _anmelder: IUser = {
    organisationids: ['-1'],
    name: '',
    vorname: '',
    password: '',
    benutzername: '',
    email: '',
    handy: '',
    aktiv: true,
  };
  vereinsName = '';
  nachname = '';
  vorname = '';
  passwort = '';
  mobilNummer = '';
  eMailAdresse = '';

  selectedCountry: string;

  mouseoverlogin: boolean;

  userValid: boolean;

  error: boolean;
  errorMessage = undefined;

  constructor(
    private formBuilder: UntypedFormBuilder,
    public dialogRef: MatDialogRef<NewAnmelderComponent>,
    private authService: AuthService,
    private vereinService: VereinService,
    private cachingUserService: CachingUserService,
    private userService: UserService,
    private router: Router,
  ) {
    this.form = this.formBuilder.group({
      vereinFormControl: ['', Validators.required],
    });
  }

  ngOnInit() {
    this.vereinService.getVereine().subscribe((vereine) => {
      this.vereine = vereine;
    });
    this._anmelder.name = this.nachname;
    this._anmelder.vorname = this.vorname;
    this._anmelder.password = this.passwort;
    this._anmelder.email = this.eMailAdresse;
    this._anmelder.handy = this.mobilNummer;
  }

  updateUserValid(valid: boolean) {
    this.userValid = valid;
    console.log('Valid changed', valid);
  }

  get anmelder() {
    return this._anmelder;
  }
  set anmelder(anmelder: IUser) {
    console.log('Anmelder changed', anmelder);
    this._anmelder = anmelder;
  }

  save(): void {
    const rollen: IRolle[] = [{ id: '', name: 'ANMELDER', aktiv: false }];
    console.log('Verein: ', this.form.controls.vereinFormControl.value);
    if (!this.anmelder.organisationids) {
      this.anmelder.organisationids = [];
    }
    this.anmelder.organisationids = this.anmelder.organisationids.slice(0, 0);
    this.anmelder.organisationids.push(this.form.controls.vereinFormControl.value);

    this._anmelder.aktiv = true;
    this._anmelder.rollen = rollen;

    this.anmelder.benutzername = this.anmelder.email;
    this.cachingUserService.getUserByBenutzername(this.anmelder.benutzername).subscribe((user) => {
      if (user) {
        this.error = true;
        this.errorMessage = 'Es existiert bereits ein Benutzer mit dem Benutzernamen: ' + this.anmelder.benutzername;
      } else {
        this.userService.createUser(this.anmelder).subscribe((user) => {
          console.log('User kreiert ', user.benutzername);
          this.dialogRef.close('OK');
          this.router.navigate(['profile']);
        });
      }
    });
  }

  cancel(): void {
    this.dialogRef.close('CANCEL');
    console.log('Cancel');
  }
}
