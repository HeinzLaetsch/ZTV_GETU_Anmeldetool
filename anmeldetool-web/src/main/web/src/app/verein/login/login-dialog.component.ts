import { Component, EventEmitter, OnInit, Output } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { MatDialogRef } from "@angular/material/dialog";
import { Router } from "@angular/router";
import { Observable, of } from "rxjs";
import { map, startWith } from "rxjs/operators";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { IVerein } from "../verein";

@Component({
  selector: "app-login-dialog",
  templateUrl: "./login-dialog.component.html",
  styleUrls: ["./login-dialog.component.css"],
})
export class LoginDialogComponent implements OnInit {
  @Output()
  showDialog = new EventEmitter<Number>();

  appearance = "outline";
  loginError: boolean;
  errorMessage = undefined;

  vereine: IVerein[];
  username: string;
  password: string;

  vwVereinControl = new FormControl("", Validators.required);
  vwUserNameControl = new FormControl("", Validators.required);
  vwPasswordControl = new FormControl("", Validators.required);

  filteredOptions: Observable<IVerein[]>;

  constructor(
    public dialogRef: MatDialogRef<LoginDialogComponent>,
    private authService: AuthService,
    public vereinService: CachingVereinService,
    private userService: CachingUserService,
    private teilnehmerService: CachingTeilnehmerService,
    private router: Router
  ) {
    this.loginError = false;
  }

  ngOnInit() {
    this.vereine = this.vereinService.getVereine();
    this.filteredOptions = this.vwVereinControl.valueChanges.pipe(
      startWith(""),
      map((value) => (typeof value === "string" ? value : value.name)),
      map((name) => (name ? this._filter(name) : this.vereine.slice()))
    );
  }
  private _filter(name: string): IVerein[] {
    const filterValue = name.toLowerCase();

    return this.vereine.filter((option) =>
      option.name.toLowerCase().includes(filterValue)
    );
  }

  displayFn(verein: IVerein): string {
    return verein && verein.name ? verein.name : "";
  }

  login() {
    this.loginError = false;
    // console.log("Login: ", this.vwUserNameControl.value);
    try {
      const self = this;
      this.authService
        .login(
          this.vwVereinControl.value,
          this.vwUserNameControl.value,
          this.vwPasswordControl.value
        )
        // .pipe(catchError(this.handleError<boolean>("login")))
        .subscribe(
          (result) => {
            self.dialogRef.close("OK");
            self.loginError = false;
            self.userService.loadUser().subscribe((result) => {
              // TODO register Error
            });
            self.teilnehmerService
              .loadTeilnehmer(self.vwVereinControl.value)
              .subscribe((result) => {
                // TODO register Error
              });
          },
          (error) => {
            this.loginError = true;
            this.errorMessage =
              "Fehler beim Login, Verein, Name oder Passwort falsch";
          }
        );
    } catch (error) {
      console.error("Error logging in: " + error);
      this.loginError = true;
    }
  }

  private handleError<T>(operation = "operation", result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    };
  }
  cancel() {
    this.router.navigate(["anlass"]);
  }

  onNoClick(): void {
    this.dialogRef.close();
  }
  newVereinClicked(): void {
    console.log("New Anmelder clicked");
    this.dialogRef.close(1);
    this.showDialog.emit(1);
  }

  newAnmelderClicked(): void {
    console.log("New Anmelder clicked");
    this.dialogRef.close(2);
    this.showDialog.emit(2);
  }
}
