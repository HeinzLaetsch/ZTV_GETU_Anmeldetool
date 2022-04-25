import { Component, OnInit } from "@angular/core";
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { MatDialogRef } from "@angular/material/dialog";
import { Router } from "@angular/router";
import { IVerband } from "src/app/core/model/IVerband";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { VerbandService } from "src/app/core/service/verband/verband.service";
import { VereinService } from "src/app/core/service/verein/verein.service";
import { IRolle } from "../../core/model/IRolle";
import { IUser } from "../../core/model/IUser";
import { IVerein } from "../verein";

@Component({
  selector: "app-new-verein",
  templateUrl: "./new-verein.component.html",
  styleUrls: ["./new-verein.component.css"],
})
export class NewVereinComponent implements OnInit {
  //floatLabel = 'Always';
  appearance = "outline";
  form: FormGroup;
  verein: IVerein = {
    id: "",
    name: "",
    verbandId: "",
  };

  _verantwortlicher: IUser = {
    id: "",
    organisationids: [""],
    name: "",
    vorname: "",
    password: "",
    benutzername: "",
    email: "",
    handy: "",
    aktiv: true,
  };

  userValid: boolean;

  selectedVerbandValue: string;
  selectedVerband: string = "";

  vereinsName: string = "";
  nachname: string = "";
  vorname: string = "";
  passwort: string = "";
  mobilNummer: string = "";
  eMailAdresse: string = "";

  mouseoverlogin: boolean;

  vereine: IVerein[];
  verbaende: IVerband[];

  error: boolean;
  errorMessage = undefined;

  constructor(
    private formBuilder: FormBuilder,
    public dialogRef: MatDialogRef<NewVereinComponent>,
    private authService: AuthService,
    private vereinService: VereinService,
    private verbandService: VerbandService,
    private userService: CachingUserService,
    private teilnehmerService: CachingTeilnehmerService,
    private router: Router
  ) {
    this.form = this.formBuilder.group({
      vereinsNameControl: [this.vereinsName, Validators.required],
      verbandFormControl: ["", Validators.required],
    });
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
    });
  }

  updateUserValid(valid: boolean) {
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
      { id: "", name: "ANMELDER", aktiv: true },
      { id: "", name: "VEREINSVERANTWORTLICHER", aktiv: true },
    ];
    const self = this;
    this.verein.name = this.form.controls.vereinsNameControl.value;
    this.verein.verbandId = this.form.controls.verbandFormControl.value;
    console.log("Verband: ", this.verein.verbandId);

    const existing = this.vereine.filter((verein) => {
      return verein.name.toUpperCase() === this.verein.name.toUpperCase();
    });
    if (existing.length > 0) {
      this.error = true;
      this.errorMessage =
        "Es existiert bereits ein Verein mit dem Namen: " + this.verein.name;
      return;
    }

    this.verantwortlicher.benutzername = this.verantwortlicher.email;
    this._verantwortlicher.aktiv = true;
    this._verantwortlicher.rollen = rollen;
    this.userService
      .getUserByBenutzername(this.verantwortlicher.benutzername)
      .subscribe(
        (user) => {
          if (user) {
            this.error = true;
            this.errorMessage =
              "Es existiert bereits ein Benutzer mit dem Benutzernamen: " +
              this.verantwortlicher.benutzername;
          } else {
            this.authService
              .createVereinAndUser(this.verein, this._verantwortlicher)
              .subscribe(
                (user) => {
                  console.log(
                    "Neuer Verein inklusive User kreiert ",
                    user.benutzername
                  );
                  // Immer erster !!
                  this.verein.id = user.organisationids[0];
                  const self = this;
                  this.authService
                    .login(
                      this.verein,
                      user.benutzername,
                      this._verantwortlicher.password
                    )
                    .subscribe({
                      next(data) {
                        self.router.navigate(["anlass"]);

                        self.userService.reset().subscribe((result) => {
                          // console.log("Login UserService loaded");
                        });
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
                        console.log("Error: ", msg);
                      },
                    });

                  self.dialogRef.close("OK");
                },
                (error) => {
                  this.error = true;
                  this.errorMessage = error;
                }
              );
          }
        },
        (error) => {
          console.error("Error", error);
        }
      );

    console.log("Save");
  }

  getError(): string {
    console.log(this.form.errors);
    return "";
  }
  cancel(): void {
    this.dialogRef.close("CANCEL");
    console.log("Cancel");
  }
}
