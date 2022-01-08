import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { Subscription } from "rxjs";
import { IRolle } from "src/app/core/model/IRolle";
import { IUser } from "src/app/core/model/IUser";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingRoleService } from "src/app/core/service/caching-services/caching.role.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { IChangeEvent } from "../IChangeEvent";

@Component({
  selector: "app-user-form",
  templateUrl: "./user-form.component.html",
  styleUrls: ["./user-form.component.css"],
})
export class UserFormComponent implements OnInit {
  @Input()
  currentUser: IUser;
  @Input()
  tabIndex: number;
  @Output()
  userChange: EventEmitter<IChangeEvent>;

  changeEvent: IChangeEvent;
  appearance = "outline";
  //userValid: boolean;
  //_userHasChanged: boolean;
  //rolesChanged: boolean;
  //wrChanged: boolean;
  //hasWr = false;

  _assignedRoles: IRolle[];
  // profileForm: FormGroup;

  _wertungsrichter: IWertungsrichter;

  constructor(
    private authService: AuthService,
    private userService: CachingUserService,
    private roleService: CachingRoleService
  ) {
    this.userChange = new EventEmitter<IChangeEvent>();
    this._wertungsrichter = {
      id: "",
      brevet: 1,
      gueltig: false,
      letzterFK: new Date(),
      aktiv: false,
    };
    this.changeEvent = {
      tabIndex: -1,
      hasWr: false,
      rolesChanged: false,
      userHasChanged: false,
      userValid: true,
      wrChanged: false,
      canceled: false,
      saved: false,
    };
  }

  ngOnInit(): void {
    // console.log("Current User: ", this.currentUser);
    this.changeEvent.tabIndex = this.tabIndex;
    if (this.currentUser.id && this.currentUser.id.length > 0) {
      this.reloadRoles(this.currentUser);
      this.userService
        .getWertungsrichter(this.currentUser.id)
        .subscribe((value) => {
          if (value) {
            this._wertungsrichter = value;
          }
        });
    } else {
      this.changeEvent.userValid = false;
      this._assignedRoles = new Array<IRolle>();
    }
  }

  isSaveDisabled() {
    if (!this.changeEvent.userValid) {
      return true;
    }
    if (
      !this.changeEvent.rolesChanged &&
      !this.changeEvent.userHasChanged &&
      !this.changeEvent.wrChanged
    ) {
      return true;
    }
    return false;
  }
  private reloadRoles(user: IUser) {
    let localSubscription2: Subscription = undefined;
    if (user.id && user.id.length > 0) {
      // console.log("user.id is valid");
      localSubscription2 = this.roleService
        .getRolesForUser(user)
        .subscribe((result) => {
          this._assignedRoles = result;
          this.changeEvent.hasWr = this.isWertungsrichter();
          // console.log("RoleFormComponent:: ngOnInit: ", this._assignedRoles);
          if (localSubscription2) {
            localSubscription2.unsubscribe();
          }
        });
    } else {
      console.log("user.id not valid");
      this._assignedRoles = new Array<IRolle>();
      this.changeEvent.hasWr = false;
    }
  }

  isWertungsrichter() {
    return this.hasRole("WERTUNGSRICHTER");
  }

  isOwner() {
    if (this.authService.isAdministrator()) {
      return true;
    }
    if (
      this.currentUser.benutzername ===
      this.authService.currentUser.benutzername
    ) {
      return true;
    }
    return false;
  }

  private hasRole(roleName: string): boolean {
    if (this._assignedRoles) {
      const rollen = this._assignedRoles.filter(
        (role) => role.name === roleName
      );
      // console.log('Rollen: ' , rollen, ' , Name: ', roleName);
      if (rollen && rollen.length > 0) {
        return rollen[0].aktiv;
      }
    }
    return false;
  }
  private updateChangeEvent() {
    this.changeEvent.canceled = false;
    this.changeEvent.saved = false;
    this.userChange.next(this.changeEvent);
  }
  get userHasChanged(): boolean {
    return this.changeEvent.userHasChanged;
  }
  set userHasChanged(value: boolean) {
    this.changeEvent.userHasChanged = value;
    // this.updateChangeEvent();
  }
  get wertungsrichter() {
    return this._wertungsrichter;
  }

  set wertungsrichter(value: IWertungsrichter) {
    this.changeEvent.wrChanged = true;
    this._wertungsrichter = value;
    this.updateChangeEvent();
  }
  get isVereinsAnmelder() {
    if (this.authService.isAdministrator()) {
      return true;
    }
    return this.authService.isVereinsAnmmelder();
  }

  get isVereinsVerantwortlicher() {
    if (this.authService.isAdministrator()) {
      return true;
    }
    return this.authService.isVereinsVerantwortlicher();
  }
  get assignedRoles(): IRolle[] {
    // console.log('Get user: ', this.currentUser);
    return this._assignedRoles;
  }
  set assignedRoles(value: IRolle[]) {
    // console.log("Set assignedRoles: ", value);
    this.changeEvent.rolesChanged = true;
    this._assignedRoles = value;
    if (this.changeEvent.hasWr !== this.isWertungsrichter()) {
      this.changeEvent.wrChanged = true;
    }
    this.changeEvent.hasWr = this.isWertungsrichter();
    this.updateChangeEvent();
  }

  get user(): IUser {
    // console.log('Get user: ', this.currentUser);
    return this.currentUser;
  }
  set user(value: IUser) {
    if (value !== this.currentUser) {
      this.currentUser = value;
      this.userHasChanged = true;
      this.updateChangeEvent();
    }
  }

  updateUserValid(valid: boolean) {
    this.changeEvent.userValid = valid;
    // console.log("Valid changed: ", this.currentUser , ', ', valid);
  }

  cancel() {
    this.currentUser = this.userService.getUserById(this.currentUser?.id);
    if (this.currentUser) {
      this.reloadRoles(this.currentUser);
    }
    this.userHasChanged = false;
    this.changeEvent.userValid = true;
    this.changeEvent.wrChanged = false;
    this.changeEvent.canceled = true;
    this.changeEvent.saved = false;
    this.userChange.next(this.changeEvent);
  }

  save(): void {
    this.changeEvent.canceled = false;
    this.changeEvent.saved = true;
    if (this.currentUser.id) {
      if (this.userHasChanged && this.changeEvent.userValid) {
        this.authService.updateUser(this.currentUser).subscribe((user) => {
          this.currentUser = user;
          this.userHasChanged = false;
        });
      }
      if (this.changeEvent.rolesChanged) {
        this.userService
          .updateRoles(
            this.currentUser,
            this.authService.currentVerein,
            this.assignedRoles
          )
          .subscribe((user) => {
            this.currentUser = user;
            this.reloadRoles(this.currentUser);
          });
        this.changeEvent.rolesChanged = false;
      }
      this.checkWrChanged();
    } else {
      this.authService.createUser(this.currentUser).subscribe((user) => {
        this.currentUser = user;
        if (this.changeEvent.rolesChanged) {
          this.userService
            .updateRoles(
              this.currentUser,
              this.authService.currentVerein,
              this.assignedRoles
            )
            .subscribe((user) => {
              this.currentUser = user;
              this.reloadRoles(this.currentUser);
            });
          this.changeEvent.rolesChanged = false;
        }
        this.checkWrChanged();
        this.userHasChanged = false;
        this.userChange.next(this.changeEvent);
      });
      this.userChange.next(this.changeEvent);
    }
  }

  checkWrChanged(): void {
    if (this.changeEvent.wrChanged) {
      if (this.changeEvent.hasWr) {
        this._wertungsrichter.personId = this.currentUser.id;
        this.userService
          .updateWertungsrichter(this.currentUser.id, this._wertungsrichter)
          .subscribe((value) => {
            this._wertungsrichter = value;
            this.changeEvent.wrChanged = false;
            this.userChange.next(this.changeEvent);
          });
      } else {
        this.userService
          .deleteWertungsrichterForUserId(this.currentUser.id)
          .subscribe((value) => {
            this._wertungsrichter = value;
            this.changeEvent.wrChanged = false;
            this.userChange.next(this.changeEvent);
          });
      }
    }
  }
}
