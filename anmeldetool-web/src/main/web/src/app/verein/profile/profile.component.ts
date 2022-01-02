import { Component, OnInit, ViewChild } from "@angular/core";
import { MatTabGroup } from "@angular/material/tabs";
import { Router } from "@angular/router";
import { IRolle } from "src/app/core/model/IRolle";
import { IUser } from "src/app/core/model/IUser";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { IVerein } from "../verein";

@Component({
  selector: "app-profile",
  templateUrl: "./profile.component.html",
  styleUrls: ["./profile.component.css"],
})
export class ProfileComponent implements OnInit {
  appearance = "outline";
  currentUser: IUser;
  _vereinsUser: IUser[];

  @ViewChild("tabs") tabGroup: MatTabGroup;

  constructor(
    private authService: AuthService,
    private userService: CachingUserService,
    private router: Router
  ) {}

  ngOnInit() {
    // console.log("ProfileComponent::ngOnInit: ", this.authService.currentUser);
    this.currentUser = this.authService.currentUser;
    this._vereinsUser = this.userService.getUser();
  }

  get vereinsUsers(): IUser[] {
    return this._vereinsUser;
  }

  isVereinsVerantwortlicher(): boolean {
    return true;
  }
  get usertext(): string {
    return JSON.stringify(this.currentUser);
  }
  get verein(): IVerein {
    return this.authService.currentVerein;
  }
  get user(): IUser {
    return this.currentUser;
  }
  set user(value: IUser) {
    this.currentUser = value;
  }
  getTabIndex() {
    console.log(
      "Index: ",
      this._vereinsUser[this._vereinsUser.length - 1].benutzername
    );
    if (this._vereinsUser[this._vereinsUser.length - 1].benutzername) {
      return 0;
    }
    return this._vereinsUser.length - 1;
  }

  addUser(event: any) {
    this._vereinsUser.push({
      id: undefined,
      organisationids: [this.authService.currentVerein.id],
      benutzername: "",
      name: "",
      vorname: "",
      email: "",
      handy: "",
      aktiv: true,
      password: "getu",
      rollen: new Array<IRolle>(),
    });
    this.tabGroup.selectedIndex = this._vereinsUser.length - 1;
  }
}
