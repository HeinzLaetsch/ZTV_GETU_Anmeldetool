import { Component, EventEmitter, OnInit, Output } from "@angular/core";
import { UntypedFormControl, Validators } from "@angular/forms";
import { MatDialogRef } from "@angular/material/dialog";
import { Router } from "@angular/router";
import { Observable, of } from "rxjs";
import { map, startWith } from "rxjs/operators";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { IVerein } from "src/app/verein/verein";
import { AppState } from "../../redux/core.state";
import { Store, select } from "@ngrx/store";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { selectAlleVereine } from "../../redux/verein";

@Component({
  selector: "app-login-dialog",
  templateUrl: "./login-dialog.component.html",
  styleUrls: ["./login-dialog.component.css"],
})
export class LoginDialogComponent extends SubscriptionHelper implements OnInit {
  @Output()
  showDialog = new EventEmitter<Number>();

  appearance = "outline";
  loginError: boolean;
  errorMessage = undefined;

  public vereine$: Observable<IVerein[]>;
  vereine: IVerein[];
  username: string;
  password: string;

  vwVereinControl = new UntypedFormControl("", Validators.required);
  vwUserNameControl = new UntypedFormControl("", Validators.required);
  vwPasswordControl = new UntypedFormControl("", Validators.required);

  filteredOptions: Observable<IVerein[]>;

  constructor(
    public dialogRef: MatDialogRef<LoginDialogComponent>,
    private authService: AuthService,
    private store: Store<AppState>,
    private userService: CachingUserService,
    private router: Router
  ) {
    super();
    this.vereine$ = this.store.pipe(select(selectAlleVereine));
    this.loginError = false;
  }

  ngOnInit() {
    this.registerSubscription(
      this.vereine$.subscribe((data) => {
        this.vereine = data;
        this.filteredOptions = this.vwVereinControl.valueChanges.pipe(
          startWith(""),
          map((value) => (typeof value === "string" ? value : value.name)),
          map((name) => (name ? this._filter(name) : this.vereine.slice()))
        );
      })
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
            // TODO check if preload is realy neccessary
            /*
            self.teilnehmerService
              .loadTeilnehmer(self.vwVereinControl.value)
              .subscribe((result) => {
                // TODO register Error
              });
              */
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
