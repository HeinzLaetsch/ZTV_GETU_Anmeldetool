import { Component, OnInit, ViewChild } from "@angular/core";
import { MatTabGroup } from "@angular/material/tabs";
import { IRolle } from "src/app/core/model/IRolle";
import { IUser } from "src/app/core/model/IUser";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { IVerein } from "../verein";
import { IChangeEvent } from "./IChangeEvent";

@Component({
  selector: "app-profile",
  templateUrl: "./profile.component.html",
  styleUrls: ["./profile.component.css"],
})
export class ProfileComponent implements OnInit {
  appearance = "outline";
  currentUser: IUser;
  _vereinsUser: IUser[];
  _changeEvents: IChangeEvent[];

  @ViewChild("tabs") tabGroup: MatTabGroup;

  constructor(
    private authService: AuthService,
    private userService: CachingUserService
  ) {}

  ngOnInit() {
    // console.log("ProfileComponent::ngOnInit: ", this.authService.currentUser);
    this.currentUser = this.authService.currentUser;
    this._vereinsUser = this.userService.getUser();
    let index = 0;
    this._changeEvents = new Array();
    this._vereinsUser.forEach(() => {
      this._changeEvents.push(this.getNewChangeEvent(index++));
    });
  }
  public disAllowTab(): boolean {
    const changes = this._changeEvents.filter((ce) =>
      this.hasUnsafedWork(ce.tabIndex)
    );
    return changes.length > 0;
  }
  private getNewChangeEvent(index: number): IChangeEvent {
    const ce: IChangeEvent = {
      tabIndex: index,
      hasWr: false,
      rolesChanged: false,
      userHasChanged: false,
      userValid: true,
      wrChanged: false,
      canceled: false,
      saved: false,
    };
    return ce;
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

  getTabName(name: string, tabIndex: number) {
    if (this.hasUnsafedWork(tabIndex)) {
      return name + " *";
    } else {
      return name;
    }
  }
  hasUnsafedWork(tabIndex: number) {
    const ce = this._changeEvents[tabIndex];
    if (ce.userHasChanged) {
      return true;
    }
    if (ce.rolesChanged) {
      return true;
    }
    if (ce.userHasChanged) {
      return true;
    }
    if (ce.wrChanged) {
      return true;
    }
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
    this._changeEvents.push(
      this.getNewChangeEvent(this.tabGroup.selectedIndex)
    );
  }

  userChange(changeEvent: IChangeEvent) {
    this._changeEvents[changeEvent.tabIndex] = changeEvent;
    if (changeEvent.saved) {
      // TODO reset dirty Flag
    }
    if (changeEvent.canceled && !this._vereinsUser[changeEvent.tabIndex]?.id) {
      const vu1 = this._vereinsUser.slice(0, changeEvent.tabIndex);
      const vu2 = this._vereinsUser.slice(changeEvent.tabIndex + 1);
      this._vereinsUser = vu1;
      this._vereinsUser.concat(vu2);
      const ce1 = this._changeEvents.slice(0, changeEvent.tabIndex);
      const ce2 = this._changeEvents.slice(changeEvent.tabIndex + 1);
      this._changeEvents = ce1;
      this._changeEvents.concat(ce2);
    }
  }
}
