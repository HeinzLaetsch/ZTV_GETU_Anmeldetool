import { Component, OnInit, EventEmitter, Output } from "@angular/core";
import { Router } from "@angular/router";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { FormBuilder, FormControl, FormGroup, Validators } from "@angular/forms";
import { VereinService } from "src/app/core/service/verein/verein.service";
import { MatDialogRef } from "@angular/material/dialog";
import { IVerein } from '../verein';
import { IRolle } from 'src/app/core/model/IRolle';
import { IUser } from 'src/app/core/model/IUser';
import { ConfirmedValidator } from 'src/app/shared/validators/ConfirmedValidator';

@Component({
  selector: "app-new-anmelder",
  templateUrl: "./new-anmelder.component.html",
  styleUrls: ["./new-anmelder.component.css"],
})
export class NewAnmelderComponent implements OnInit {
  //floatLabel = 'Always';
  appearance = "outline";
  form: FormGroup;
  vereine: IVerein[];
  verein: IVerein = {
    id: '-1',
    name: '',
    verbandId: ''
  };

  _anmelder: IUser = {
    id: '-1',
    organisationid: '-1',
    name: '',
    vorname: '',
    password: '',
    benutzername: '',
    email: '',
    handy: '',
    aktiv: true
  };
  vereinsName: string = "TV Seebach";
  nachname: string = "Hess";
  vorname: string = "Eliane";
  passwort: string = "pw";
  mobilNummer: string = "078 111 11 11";
  eMailAdresse: string = "eliane.hess@tvseebach.ch";

  selectedCountry: string;

  mouseoverlogin: boolean;

  userValid: boolean;

  constructor(
    private formBuilder: FormBuilder,
    public dialogRef: MatDialogRef<NewAnmelderComponent>,
    private authService: AuthService,
    private vereinService: VereinService,
    private router: Router) {
      this.form = this.formBuilder.group({
        vereinFormControl: ["", Validators.required],
        // nachnameControl: [this.nachname, Validators.required],
        // vornameControl: [this.vorname, Validators.required],
        // passwortControl: [this.passwort, Validators.required],
        // passwort2Control: [this.passwort, Validators.required],
        // eMailAdresseControl: [this.mobilNummer, [Validators.required, Validators.email, Validators.pattern('^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$')]],
        //mobilNummerControl: [this.eMailAdresse, [Validators.required, Validators.pattern('[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}')]]
   }
   //,{ validator: ConfirmedValidator('passwortControl' , 'passwort2Control')  }
   )
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
    const rollen: IRolle[] = [
      {id: '', name: 'ANMELDER', aktiv: false}
    ]
    console.log('Verein: ', this.form.controls.vereinFormControl.value)
    this.anmelder.organisationid = this.form.controls.vereinFormControl.value;
    // this.anmelder.name = this.form.controls.nachnameControl.value;
    // this.anmelder.vorname = this.form.controls.vornameControl.value;
    // this.anmelder.password = this.form.controls.passwortControl.value;
    // this.anmelder.email = this.form.controls.eMailAdresseControl.value;
    // this.anmelder.benutzername = this.anmelder.email;
    // this.anmelder.handy = this.form.controls.mobilNummerControl.value;
    this._anmelder.aktiv = true;
    this._anmelder.rollen = rollen;

    this.authService.createUser(this.anmelder).subscribe( user => {
      console.log("User kreiert " , user.benutzername);
      this.dialogRef.close('OK');
      this.router.navigate(['profile']);
    })
  }

  cancel(): void {
    this.dialogRef.close("CANCEL");
    console.log("Cancel");
  }
}
