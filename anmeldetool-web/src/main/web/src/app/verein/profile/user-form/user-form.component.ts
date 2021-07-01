import { Component, Input, OnInit } from "@angular/core";
import { FormGroup } from "@angular/forms";
import { Subscription } from "rxjs";
import { IRolle } from "src/app/core/model/IRolle";
import { IUser } from "src/app/core/model/IUser";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingRoleService } from "src/app/core/service/caching-services/caching.role.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";

@Component({
  selector: "app-user-form",
  templateUrl: "./user-form.component.html",
  styleUrls: ["./user-form.component.css"],
})
export class UserFormComponent implements OnInit {
  @Input()
  currentUser: IUser;

  appearance = "outline";
  userValid: boolean;
  userChanged: boolean;
  rolesChanged: boolean;
  wrChanged: boolean;

  _assignedRoles: IRolle[];
  // profileForm: FormGroup;

  _wertungsrichter: IWertungsrichter;

  constructor(
    private authService: AuthService,
    private userService: CachingUserService,
    private roleService: CachingRoleService
  ) {
    this._wertungsrichter = {
      id: "",
      brevet: 1,
      gueltig: false,
      letzterFK: new Date(),
      aktiv: false,
    };
    this.userChanged = false;
    this.userValid = true;
    this.wrChanged = false;
  }

  ngOnInit(): void {
    console.log('Current User: ' , this.currentUser);
    if (this.currentUser.id && this.currentUser.id.length > 0) {
      this.reloadRoles(this.currentUser);
      this.userValid = true;
      this.userService
        .getWertungsrichter(this.currentUser.id)
        .subscribe((value) => {
          if (value) {
            this._wertungsrichter = value;
          }
        });
    } else {
      this.userValid = false;
      this._assignedRoles = new Array<IRolle>();
    }
  }

  private reloadRoles(user: IUser) {
    let localSubscription2: Subscription = undefined;
    if (user.id && user.id.length > 0) {
      console.log('user.id is valid');
      localSubscription2 = this.roleService
      .getRolesForUser(user)
      .subscribe((result) => {
        this._assignedRoles = result;
        console.log("RoleFormComponent:: ngOnInit: ", this._assignedRoles);
        if (localSubscription2) {
          localSubscription2.unsubscribe();
        }
      });
    } else {
      console.log('user.id not valid');
      this._assignedRoles = new Array<IRolle>();
    }
  }

  isWertungsrichter() {
    return this.hasRole("WERTUNGSRICHTER");
  }

  isOwner() {
    if(this.currentUser.benutzername === this.authService.currentUser.benutzername) {
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
  get wertungsrichter() {
    return this._wertungsrichter;
  }

  set wertungsrichter(value: IWertungsrichter) {
    this.wrChanged = true;
    this._wertungsrichter = value;
  }
  get isVereinsAnmelder() {
    return this.authService.isVereinsAnmmelder();
  }

  get isVereinsVerantwortlicher() {
    return this.authService.isVereinsVerantwortlicher();
  }
  get assignedRoles(): IRolle[] {
    // console.log('Get user: ', this.currentUser);
    return this._assignedRoles;
  }
  set assignedRoles(value: IRolle[]) {
    console.log("Set assignedRoles: ", value);
    this.rolesChanged = true;
    this._assignedRoles = value;
  }

  get user(): IUser {
    // console.log('Get user: ', this.currentUser);
    return this.currentUser;
  }
  set user(value: IUser) {
    console.log("Set user: ", value);
    this.userChanged = true;
    this.currentUser = value;
  }

  updateUserValid(valid: boolean) {
    this.userValid = valid;
    // console.log("Valid changed: ", this.currentUser , ', ', valid);
  }

  cancel() {
    this.currentUser = this.userService.getUserById(this.currentUser.id);
    this.reloadRoles(this.currentUser);
    this.userChanged = false;
    this.userValid = true;
    this.wrChanged = false;
  }

  save(): void {
    console.log(
      "this.userChanged: ",
      this.userChanged,
      " ,this.wrChanged: ",
      this.wrChanged,
      " ,this.userValid: ",
      this.userValid
    );

    if (this.currentUser.id) {
      if (this.userChanged && this.userValid) {
        this.authService.updateUser(this.currentUser).subscribe((user) => {
          this.currentUser = user;
        });
        this.userChanged = false;
      }
      if (this.rolesChanged) {
        this.userService
          .updateRoles(this.currentUser, this.assignedRoles)
          .subscribe((user) => {
            this.currentUser = user;
            this.reloadRoles(this.currentUser);
          });
        this.rolesChanged = false;
      }
      this.wrChanged = true;
      if (this.wrChanged) {
        this.userService
          .updateWertungsrichter(this.currentUser.id, this._wertungsrichter)
          .subscribe((value) => (this._wertungsrichter = value));
      }
    } else {
      this.authService.createUser(this.currentUser).subscribe((user) => {
        this.currentUser = user;
        if (this.rolesChanged) {
          this.userService
            .updateRoles(this.currentUser, this.assignedRoles)
            .subscribe((user) => {
              this.currentUser = user;
              this.reloadRoles(this.currentUser);
            });
          this.rolesChanged = false;
        }
        this.wrChanged = true;
        if (this.wrChanged) {
          this.userService
            .updateWertungsrichter(this.currentUser.id, this._wertungsrichter)
            .subscribe((value) => (this._wertungsrichter = value));
        }
      });
    }
  }
}
