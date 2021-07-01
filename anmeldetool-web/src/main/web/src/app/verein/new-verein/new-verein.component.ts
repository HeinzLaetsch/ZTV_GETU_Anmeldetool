import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { VereinService } from 'src/app/core/service/verein/verein.service';
import { MatDialogRef } from '@angular/material/dialog';
import { IUser } from '../../core/model/IUser';
import { IRolle } from '../../core/model/IRolle';
import { IVerein } from '../verein';
import { IVerband } from 'src/app/core/model/IVerband';
import { ConfirmedValidator } from 'src/app/shared/validators/ConfirmedValidator';
import { VerbandService } from 'src/app/core/service/verband/verband.service';

@Component({
  selector: 'app-new-verein',
  templateUrl: './new-verein.component.html',
  styleUrls: [ './new-verein.component.css']
})

export class NewVereinComponent implements OnInit {

  //floatLabel = 'Always';
  appearance = 'outline';
  form: FormGroup;
  verein: IVerein = {
    id: '',
    name: '',
    verbandId: ''
  };

  _verantwortlicher: IUser = {
    id: '',
    organisationid: '',
    name: '',
    vorname: '',
    password: '',
    benutzername: '',
    email: '',
    handy: '',
    aktiv: true
  };

  userValid: boolean;

  selectedVerbandValue: string;
  selectedVerband: string = '';

  vereinsName: string = "TV Seebach";
  nachname: string = "Lätsch";
  vorname: string = "Heinz";
  passwort: string = "pw";
  mobilNummer: string = "078 111 11 11";
  eMailAdresse: string = "heinz.laetsch@tvseebach.ch";

  mouseoverlogin: boolean;

  vereine: IVerein[];
  verbaende: IVerband[];

  constructor(
    private formBuilder: FormBuilder,
    public dialogRef: MatDialogRef<NewVereinComponent>,
    private authService: AuthService,
    private vereinService: VereinService,
    private verbandService: VerbandService,
    private router: Router
    ) {
      this.form = this.formBuilder.group({
        vereinsNameControl: [this.vereinsName, Validators.required],
        verbandFormControl: ['', Validators.required],
        // nachnameControl: [this.nachname, Validators.required],
        // vornameControl: [this.vorname, Validators.required],
        // passwortControl: [this.passwort, Validators.required],
        // passwort2Control: [this.passwort, Validators.required],
        // eMailAdresseControl: [this.eMailAdresse, [Validators.required, Validators.email, Validators.pattern('^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$')]],
        // mobilNummerControl: [this.mobilNummer, [Validators.required, Validators.pattern('[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}')]]
      }
      //, { validator: ConfirmedValidator('passwortControl' , 'passwort2Control')}
      )
      this._verantwortlicher.name = this.nachname;
      this._verantwortlicher.vorname = this.vorname;
      this._verantwortlicher.password = this.passwort;
      this._verantwortlicher.email = this.eMailAdresse;
      this._verantwortlicher.handy = this.mobilNummer;

    }

    ngOnInit() {
      this.vereinService.getVereine().subscribe((vereine) => {
        this.vereine = vereine;
      });
      this.verbandService.getVerband().subscribe((verbaende) => {
        this.verbaende = verbaende;
      })
    }

    updateUserValid(valid: boolean) {
      this.userValid = valid;
      console.log('Valid changed', valid);
    }

    get verantwortlicher() {
      return this._verantwortlicher;
    }
    set verantwortlicher(verantwortlicher: IUser) {
      console.log('Verantwortlicher changed', verantwortlicher);
      this._verantwortlicher = verantwortlicher;
    }
  save(): void {
    const rollen: IRolle[] = [
      {id:'', name: 'ANMELDER', aktiv: true},
      {id: '', name: 'VEREINSVERANTWORTLICHER', aktiv: true}
    ]
    const self = this;
    this.verein.name = this.form.controls.vereinsNameControl.value;
    this.verein.verbandId = this.form.controls.verbandFormControl.value;
    console.log("Verband: ", this.verein.verbandId);

    // this.verantwortlicher.benutzername = this.form.controls.eMailAdresseControl.value;
    // this.verantwortlicher.email =  this.form.controls.eMailAdresseControl.value;
    // this.verantwortlicher.vorname = this.form.controls.vornameControl.value;
    // this.verantwortlicher.name = this.form.controls.nachnameControl.value;
    // this.verantwortlicher.handy = this.form.controls.mobilNummerControl.value;
    // this.verantwortlicher.password = this.form.controls.passwortControl.value;
    this.verantwortlicher.benutzername = this.verantwortlicher.email;
    this._verantwortlicher.aktiv = true;
    this._verantwortlicher.rollen = rollen;

    this.authService.createVereinAndUser(this.verein,this._verantwortlicher).subscribe( user => {
      console.log("Neuer Verein inklusive User kreiert " , user.benutzername);
      self.dialogRef.close('OK');
      self.router.navigate(['events']);
})
    /*
    this.authService.createUser(this.verantwortlicher, RoleEnum.RIEGENLEITER).subscribe( {
      next(data) {
        console.log('Riegenleiter created: ' , data);
        self.authService.loginUser('bla', self.verantwortlicher.eMail , self.verantwortlicher.password).subscribe({
          next(data) {
            // console.log('Logged In: ' , data);
            // self.keycloakService.getKeycloakInstance().refreshToken ='123';
            console.log('self.keycloakService 2: ' + self.keycloakService.getKeycloakInstance().authenticated);
            console.log('self.keycloakService 2: ' + self.keycloakService.getKeycloakInstance());
            //self.keycloakService.isLoggedIn().then( loggedIn => {
            //  console.log('LoggedIn :' , loggedIn);
            //});

            // self.authService.isAuthenticated().subscribe( auth => {
            // });
            self.dialogRef.close('OK');
            self.router.navigate(['events']);
          }
        }
        )
        // self.dialogRef.close('OK');
      },
      error(msg) {
        console.log('Error: ', msg);
      }
    });
    */

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
