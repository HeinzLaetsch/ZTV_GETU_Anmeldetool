import { Component, Output, EventEmitter, OnInit } from "@angular/core";
import { MatDialogRef } from "@angular/material/dialog";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { Router } from "@angular/router";
import { FormControlDirective, FormControl, Validators } from "@angular/forms";
import { VereinService } from "src/app/core/service/verein/verein.service";
import { IVerein } from "../verein";
import { catchError } from "rxjs/operators";
import { VerbandService } from 'src/app/core/service/verband/verband.service';
import { CachingVereinService } from 'src/app/core/service/caching-services/caching.verein.service';
import { Subscription } from 'rxjs';

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

  vereine: IVerein[];
  // Verein: string;
  username: string;
  password: string;

  vwVereinControl = new FormControl("", Validators.required);
  vwUserNameControl = new FormControl("", Validators.required);
  vwPasswordControl = new FormControl("", Validators.required);

  constructor(
    public dialogRef: MatDialogRef<LoginDialogComponent>,
    private authService: AuthService,
    public vereinService: CachingVereinService,
    private router: Router
  ) {
    this.loginError = false;
  }

  ngOnInit() {
    let localSubscription: Subscription = undefined;
    localSubscription =  this.vereinService.loadVereine().subscribe( result => {
      this.vereine = this.vereinService.getVereine();
      console.log('LoginDialogComponent:: ngOnInit: ' , this.vereine);
      if (localSubscription) {
        localSubscription.unsubscribe();
      }
    });
  }

  login() {
    this.loginError = false;
    console.log("Login: ", this.vwUserNameControl.value);
    try {
      const self = this;
      this.authService
        .login(
          this.vwVereinControl.value,
          this.vwUserNameControl.value,
          this.vwPasswordControl.value
        )
        .subscribe({
          next(data) {
            console.log("Response: ", data);
            self.dialogRef.close("OK");
            self.loginError = false;
          },
          error(msg) {
            console.log("Error: ", msg);
            self.loginError = true;
          },
        });
    } catch (error) {
      console.error("Error logging in: " + error);
      this.loginError = true;
    }
  }

  cancel() {
    this.router.navigate(["events"]);
  }

  onNoClick(): void {
    this.dialogRef.close();
  }
  /*
  onShowPage(showPage: number): void {
    console.log("On ShowPage", showPage);
    this.showPage = showPage;
  }
*/
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
