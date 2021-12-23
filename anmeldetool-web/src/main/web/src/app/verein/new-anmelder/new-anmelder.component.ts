import { Component, OnInit } from "@angular/core";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { MatDialogRef } from "@angular/material/dialog";
import { Router } from "@angular/router";
import { IRolle } from "src/app/core/model/IRolle";
import { IUser } from "src/app/core/model/IUser";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { VereinService } from "src/app/core/service/verein/verein.service";
import { IVerein } from "../verein";

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
    id: "-1",
    name: "",
    verbandId: "",
  };

  _anmelder: IUser = {
    organisationid: "-1",
    name: "",
    vorname: "",
    password: "",
    benutzername: "",
    email: "",
    handy: "",
    aktiv: true,
  };
  vereinsName: string = "";
  nachname: string = "";
  vorname: string = "";
  passwort: string = "";
  mobilNummer: string = "";
  eMailAdresse: string = "";

  selectedCountry: string;

  mouseoverlogin: boolean;

  userValid: boolean;

  constructor(
    private formBuilder: FormBuilder,
    public dialogRef: MatDialogRef<NewAnmelderComponent>,
    private authService: AuthService,
    private vereinService: VereinService,
    private router: Router
  ) {
    this.form = this.formBuilder.group({
      vereinFormControl: ["", Validators.required],
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
    console.log("Valid changed", valid);
  }

  get anmelder() {
    return this._anmelder;
  }
  set anmelder(anmelder: IUser) {
    console.log("Anmelder changed", anmelder);
    this._anmelder = anmelder;
  }

  save(): void {
    const rollen: IRolle[] = [{ id: "", name: "ANMELDER", aktiv: false }];
    console.log("Verein: ", this.form.controls.vereinFormControl.value);
    this.anmelder.organisationid = this.form.controls.vereinFormControl.value;

    this._anmelder.aktiv = true;
    this._anmelder.rollen = rollen;

    this.anmelder.benutzername = this.anmelder.email;

    this.authService.createUser(this.anmelder).subscribe((user) => {
      console.log("User kreiert ", user.benutzername);
      this.dialogRef.close("OK");
      this.router.navigate(["profile"]);
    });
  }

  cancel(): void {
    this.dialogRef.close("CANCEL");
    console.log("Cancel");
  }
}
