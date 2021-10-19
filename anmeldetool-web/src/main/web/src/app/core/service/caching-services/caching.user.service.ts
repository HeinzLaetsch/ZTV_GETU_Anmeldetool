import { Injectable } from "@angular/core";
import { Observable, BehaviorSubject } from "rxjs";
import { skip } from "rxjs/operators";
import { UserService } from "../user/user.service";
import { IUser } from "../../model/IUser";
import { IRolle } from "../../model/IRolle";
import { IWertungsrichter } from "../../model/IWertungsrichter";

@Injectable({
  providedIn: "root",
})
export class CachingUserService {
  private usersLoaded: BehaviorSubject<boolean>;

  private _loadRunning = false;

  private loaded = false;

  private users: IUser[];
  private orgUsers: IUser[];

  constructor(private userService: UserService) {
    this.usersLoaded = new BehaviorSubject<boolean>(undefined);
  }
  reset(): Observable<boolean> {
    this.loaded = false;
    return this.loadUser();
  }

  isUserLoaded(): Observable<boolean> {
    return this.usersLoaded.asObservable();
  }

  loadUser(): Observable<boolean> {
    // console.log('User loadUser');
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      this.userService.getUser().subscribe((users) => {
        this.orgUsers = users;
        this.users = this.deepCopy(users);
        this._loadRunning = false;
        this.loaded = true;
        this.usersLoaded.next(true);
        console.log("User Loaded");
      });
    } else {
      if (this.loaded) {
        this.usersLoaded.next(true);
      }
    }
    return this.usersLoaded.asObservable();
  }

  private copyUsers(users: IUser[]): IUser[] {
    return users.map((user) => {
      console.log("Orginal 1: ", user);
      const userCopy: IUser = Object.assign(user);
      userCopy.benutzername = userCopy.benutzername + "_copy";
      console.log("Clone: ", userCopy);
      console.log("Orginal 2: ", user);
      if (user.rollen) {
        const rolesCopy = user.rollen.map((role) => {
          const roleCopy = Object.assign(role);
          return roleCopy;
        });
        userCopy.rollen = rolesCopy;
      }
      return userCopy;
    });
  }
  //public static
  private deepCopy<T>(source: T): T {
    return Array.isArray(source)
      ? source.map((item) => this.deepCopy(item))
      : source instanceof Date
      ? new Date(source.getTime())
      : source && typeof source === "object"
      ? Object.getOwnPropertyNames(source).reduce((o, prop) => {
          Object.defineProperty(
            o,
            prop,
            Object.getOwnPropertyDescriptor(source, prop)
          );
          o[prop] = this.deepCopy(source[prop]);
          return o;
        }, Object.create(Object.getPrototypeOf(source)))
      : (source as T);
  }

  getUser(): IUser[] {
    if (this.loaded) {
      // console.log('Vereins User: ' , this.users);
      return this.users;
    }
    return undefined;
  }

  getAllWertungsrichter(brevet: number): IUser[] {
    if (this.loaded) {
      // console.log('Vereins User: ' , this.users);
      this.users.map((user) => {
        this.getWertungsrichter(user.id).subscribe((wr) => {
          console.log("WR: ", wr);
        });
      });
    }
    return undefined;
  }

  updateRoles(user: IUser, roles: IRolle[]): Observable<IUser> {
    return this.userService.updateRoles(user, roles);
  }

  getUserById(id: string) {
    if (this.loaded) {
      const newUser = this.orgUsers.find((user) => user.id === id);
      // console.log('Org: ' , newUser, ' , alle: ' , this.orgUsers);
      const copy = this.deepCopy(newUser);
      // console.log('Copy: ' , copy);
      return copy;
    }
    return undefined;
  }

  getWertungsrichter(id: string): Observable<IWertungsrichter> {
    return this.userService.getWertungsrichter(id);
  }
  updateWertungsrichter(id: string, wertungsrichter: IWertungsrichter) {
    if (wertungsrichter.id) {
      return this.userService.updateWertungsrichter(id, wertungsrichter);
    } else {
      return this.userService.updateWertungsrichter(id, wertungsrichter);
    }
  }
}
