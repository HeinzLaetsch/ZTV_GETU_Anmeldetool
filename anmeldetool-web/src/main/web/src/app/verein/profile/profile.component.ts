import { Component, OnInit, ViewChild } from "@angular/core";
import { MatTabGroup } from "@angular/material/tabs";
import { IRolle } from "src/app/core/model/IRolle";
import { IUser } from "src/app/core/model/IUser";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { IVerein } from "../verein";
import { IChangeEvent } from "./IChangeEvent";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { AppState } from "src/app/core/redux/core.state";
import { select, Store } from "@ngrx/store";
import { Observable } from "rxjs";
import {
  selectDirtyUser,
  selectUser,
  UserActions,
} from "src/app/core/redux/user";
import { v4 as uuidv4 } from "uuid";

@Component({
  selector: "app-profile",
  templateUrl: "./profile.component.html",
  styleUrls: ["./profile.component.css"],
})
export class ProfileComponent extends SubscriptionHelper implements OnInit {
  appearance = "outline";
  user$: Observable<IUser[]>;
  dirty$: Observable<IUser[]>;
  currentUser: IUser;
  vereinsUsers: IUser[] = [];
  dirtyUsers: IUser[];
  _changeEvents: IChangeEvent[];

  @ViewChild("tabs") tabGroup: MatTabGroup;

  constructor(
    private authService: AuthService,
    private store: Store<AppState> // private userService: CachingUserService
  ) {
    super();
    this._changeEvents = new Array();
    this.store.dispatch(UserActions.loadAllUserInvoked());
  }

  ngOnInit() {
    // console.log("ProfileComponent::ngOnInit: ", this.authService.currentUser);
    this.currentUser = this.authService.currentUser;
    this.user$ = this.store.pipe(select(selectUser()));
    this.dirty$ = this.store.pipe(select(selectDirtyUser()));
    this.registerSubscription(
      this.user$.subscribe((users) => {
        if (users.length > 0) {
          this.synchUsers(users);

          /* Produziert eine Menge leerer
          if (!this.tabGroup || !this.tabGroup.selectedIndex) {
            // this.tabGroup.selectedIndex = 0;
            this._changeEvents.push(this.getNewChangeEvent(0));
          }
          */
        }
      })
    );

    this.registerSubscription(
      this.dirty$.subscribe((dirtyUsers) => {
        this.dirtyUsers = dirtyUsers;
      })
    );

    //this._vereinsUser = this.userService.getUser();
    let index = 0;
  }

  private synchUsers(users: IUser[]) {
    // Keine löschen und neu schreiben mehr!!
    // Jedoch TODO wenn VereinUser > users dann abschneiden
    /*
    if (this.vereinsUsers) {
      this.vereinsUsers = this.vereinsUsers.slice(0, 0);
    } else {
      this.vereinsUsers = [];
    }*/

    users.sort((a, b) => {
      if (a.password === null) {
        return a.benutzername.localeCompare(b.benutzername);
      } else {
        return -1;
      }
    });
    let index = 0;
    users.forEach((user) => {
      let asVUString = "";
      let asUString = JSON.stringify(user);
      if (this.vereinsUsers[index]) {
        asVUString = JSON.stringify(this.vereinsUsers[index]);
        if (asUString !== asVUString) {
          this.vereinsUsers[index] = JSON.parse(asUString);
        }
      } else {
        this.vereinsUsers.push(JSON.parse(asUString));
        this._changeEvents.push(this.getNewChangeEvent(index));
      }
      index++;
    });
    // this.vereinsUsers = users;
    // Sollte keinen neuen brauchen wenn Daten geändert haben
    /*
    let index = 0;
    this.vereinsUsers.forEach(() => {
      this._changeEvents.push(this.getNewChangeEvent(index++));
    });
    */
  }

  public disAllowTab(): boolean {
    return this.dirtyUsers.length > 0;
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

  isVereinsVerantwortlicher(): boolean {
    return true;
  }
  hasChanges(): boolean {
    if (this.dirtyUsers) {
      return this.dirtyUsers.length > 0;
    }
    return false;
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
      this.vereinsUsers[this.vereinsUsers.length - 1].benutzername
    );
    if (this.vereinsUsers[this.vereinsUsers.length - 1].benutzername) {
      return 0;
    }
    return this.vereinsUsers.length - 1;
  }

  getTabName(name: string, tabIndex: number) {
    if (this.hasUnsafedWork(tabIndex)) {
      return name + " *";
    } else {
      return name;
    }
  }
  hasUnsafedWork(tabIndex: number): boolean {
    return this.vereinsUsers[tabIndex].dirty;
    /*
    const ce = this._changeEvents[tabIndex];
    if (ce.userHasChanged || this.vereinsUsers[tabIndex].dirty) {
      return true;
    }
    if (ce.rolesChanged) {
      return true;
    }
    if (ce.wrChanged) {
      return true;
    }
    */
  }

  addUser(event: any) {
    //TODO Achtung add

    //this.vereinsUser.push({
    const newUser = {
      id: uuidv4(),
      organisationids: [this.authService.currentVerein.id],
      benutzername: "",
      name: "",
      vorname: "",
      email: "",
      handy: "",
      aktiv: true,
      dirty: true,
      password: "getu",
      rollen: new Array<IRolle>(),
    };
    this.vereinsUsers.unshift(JSON.parse(JSON.stringify(newUser)));
    this.store.dispatch(UserActions.addDirtyUser({ payload: newUser }));
    /*
    this.tabGroup.selectedIndex = this.vereinsUser.length - 1;
    this._changeEvents.push(
      this.getNewChangeEvent(this.tabGroup.selectedIndex)
    );
    */
  }
  saveUser(event: any) {
    this.dirtyUsers.forEach((user) => {
      this.store.dispatch(UserActions.saveUserInvoked({ payload: user }));
    });
  }
  userChange(changeEvent: IChangeEvent) {
    //TODO Achtung change
    this._changeEvents[changeEvent.tabIndex] = changeEvent;
    if (changeEvent.saved) {
      // TODO reset dirty Flag
    }
    if (changeEvent.canceled && !this.vereinsUsers[changeEvent.tabIndex]?.id) {
      const vu1 = this.vereinsUsers.slice(0, changeEvent.tabIndex);
      const vu2 = this.vereinsUsers.slice(changeEvent.tabIndex + 1);
      this.vereinsUsers = vu1;
      this.vereinsUsers.concat(vu2);
      const ce1 = this._changeEvents.slice(0, changeEvent.tabIndex);
      const ce2 = this._changeEvents.slice(changeEvent.tabIndex + 1);
      this._changeEvents = ce1;
      this._changeEvents.concat(ce2);
    }
  }

  getUserCopy(orgUser: IUser): IUser {
    // console.log('Get user: ', this.currentUser);
    // return this.deepCopy(this.currentUser);
    //return JSON.parse(JSON.stringify(orgUser));
    return orgUser;
  }
}
