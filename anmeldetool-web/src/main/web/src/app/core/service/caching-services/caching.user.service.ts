import { Injectable } from '@angular/core';
import { BehaviorSubject, forkJoin, Observable, of } from 'rxjs';
import { IVerein } from 'src/app/verein/verein';
import { IRolle } from '../../model/IRolle';
import { IUser } from '../../model/IUser';
import { IWertungsrichter } from '../../model/IWertungsrichter';
import { UserService } from '../user/user.service';

@Injectable({
  providedIn: 'root',
})
export class CachingUserService {
  private usersLoaded: BehaviorSubject<boolean>;

  private _loadRunning = false;

  private loaded = false;

  private users: IUser[] = [];
  private orgUsers: IUser[] = [];

  constructor(private userService: UserService) {
    this.usersLoaded = new BehaviorSubject<boolean>(false);
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
        this.users.sort((a, b) => {
          if (a.benutzername < b.benutzername) {
            return -1;
          }
          if (a.benutzername > b.benutzername) {
            return 1;
          }
          return 0;
        });
        this._loadRunning = false;
        this.loaded = true;
        this.usersLoaded.next(true);
        // console.log("User Loaded");
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
      // console.log("Orginal 1: ", user);
      const userCopy: IUser = Object.assign(user);
      userCopy.benutzername = userCopy.benutzername + '_copy';
      // console.log("Clone: ", userCopy);
      // console.log("Orginal 2: ", user);
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
    if (source === null || source === undefined) {
      return source;
    }

    if (Array.isArray(source)) {
      return source.map((item) => this.deepCopy(item)) as unknown as T;
    }

    if (source instanceof Date) {
      return new Date(source.getTime()) as unknown as T;
    }

    if (typeof source === 'object') {
      const sourceObject = source as Record<string, unknown>;
      const target = Object.create(Object.getPrototypeOf(sourceObject)) as Record<string, unknown>;

      Object.getOwnPropertyNames(sourceObject).forEach((prop) => {
        const descriptor = Object.getOwnPropertyDescriptor(sourceObject, prop);
        if (descriptor) {
          Object.defineProperty(target, prop, descriptor);
        }
        target[prop] = this.deepCopy(sourceObject[prop]);
      });

      return target as T;
    }

    return source;
  }

  getUser(): IUser[] {
    if (this.loaded) {
      // console.log('Vereins User: ' , this.users);
      return this.users;
    }
    return [];
  }

  getUserByBenutzername(benutzername: string): Observable<IUser> {
    return this.userService.getUserByBenutzername(benutzername);
  }
  getAllWertungsrichter(brevet: number): Observable<IWertungsrichter[]> {
    const observables = new Array<Observable<IWertungsrichter>>();
    if (this.loaded) {
      // console.log('Vereins User: ' , this.users);
      this.users.map((user) => {
        if (user.id) {
          observables.push(this.getWertungsrichter(user.id));
        }
      });
      return forkJoin(observables);
    }
    return of([]);
  }

  updateRoles(user: IUser, verein: IVerein, roles: IRolle[]): Observable<IUser> {
    return this.userService.updateRoles(user, verein, roles);
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
    return this.userService.updateWertungsrichter(id, wertungsrichter);
  }
  deleteWertungsrichterForUserId(id: string) {
    return this.userService.deleteWertungsrichterForUserId(id);
  }
}
