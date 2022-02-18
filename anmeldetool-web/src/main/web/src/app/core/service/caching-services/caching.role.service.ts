import { Injectable } from "@angular/core";
import { BehaviorSubject, Observable } from "rxjs";
import { IRolle } from "../../model/IRolle";
import { IUser } from "../../model/IUser";
import { AuthService } from "../auth/auth.service";
import { RoleService } from "../role/role.service";

@Injectable({
  providedIn: "root",
})
export class CachingRoleService {
  private rolesLoaded: BehaviorSubject<boolean>;

  private _loadRunning = false;

  private loaded = false;

  private roles: IRolle[];

  constructor(
    private roleService: RoleService,
    private authService: AuthService
  ) {
    this.rolesLoaded = new BehaviorSubject<boolean>(undefined);
  }
  reset(): Observable<boolean> {
    this.loaded = false;
    return this.loadRoles();
  }

  isRolesLoaded(): Observable<boolean> {
    return this.rolesLoaded.asObservable();
  }

  loadRoles(): Observable<boolean> {
    // console.log('Roles loadRoles');
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      this.roleService.getRoles().subscribe((roles) => {
        this.roles = roles;
        this._loadRunning = false;
        this.loaded = true;
        this.rolesLoaded.next(true);
        // console.log('Roles Loaded');
      });
    } else {
      if (this.loaded) {
        this.rolesLoaded.next(true);
      }
    }
    return this.rolesLoaded.asObservable();
  }

  getRoles(): IRolle[] {
    if (this.loaded) {
      if (this.authService.isAdministrator()) {
        return this.roles.filter((role) => {
          // console.log('Rolle: ', role);
          return role.aktiv;
        });
      } else {
        return this.roles.filter((role) => {
          // console.log('Rolle: ', role);
          return role.publicAssignable && role.aktiv;
        });
      }
    }
    return undefined;
  }

  getRolesForUser(userId: IUser): Observable<IRolle[]> {
    return this.roleService.getRolesForUser(userId);
  }
  /*
  getRoleById(id: string) {
    if (this.loaded) {
      return this.roles.find( role => role.id = id);
    }
    return undefined;
  }
  */
}
