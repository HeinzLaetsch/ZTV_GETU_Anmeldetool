import { Component, EventEmitter, OnInit, Output } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { MatDialogRef } from "@angular/material/dialog";
import { Router } from "@angular/router";
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

  vereine: IVerein[];
  username: string;
  password: string;

  vwVereinControl = new FormControl("", Validators.required);
  vwUserNameControl = new FormControl("", Validators.required);
  vwPasswordControl = new FormControl("", Validators.required);

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
            self.userService.loadUser().subscribe((result) => {
              console.log("Login UserService loaded");
            });
            self.teilnehmerService
              .loadTeilnehmer(self.vwVereinControl.value)
              .subscribe((result) => {
                console.log("Login teilnehmerService loaded");
              });
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
