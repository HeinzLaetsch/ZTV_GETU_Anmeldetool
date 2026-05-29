import { Component, type OnInit, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import type { MatTabGroup } from '@angular/material/tabs';
import { select, Store } from '@ngrx/store';
import type { Observable } from 'rxjs';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import type { AppState } from 'src/app/core/redux/core.state';
import { selectAktivUser, selectDirtyUser, UserActions } from 'src/app/core/redux/user';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import { v4 as uuidv4 } from 'uuid';
import type { IVerein } from '../verein';
import type { IChangeEvent } from './IChangeEvent';
import { MaterialModule } from 'src/app/shared/material-module';
import { UserFormComponent } from '../user-form/user-form.component';

@Component({
  selector: 'lxt-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss'],
  standalone: true,
  imports: [CommonModule, MaterialModule, UserFormComponent],
})
export class ProfileComponent extends SubscriptionHelper implements OnInit {
  appearance = 'outline';
  user$!: Observable<IUser[]>;
  dirty$!: Observable<IUser[]>;
  currentUser!: IUser;
  vereinsUsers: IUser[] = [];
  dirtyUsers: IUser[] = [];
  _changeEvents: IChangeEvent[];

  @ViewChild('tabs') tabGroup!: MatTabGroup;

  constructor(
    private authService: AuthService,
    private store: Store<AppState>, // private userService: CachingUserService
  ) {
    super();
    this._changeEvents = [];
    this.store.dispatch(UserActions.loadAllUserInvoked());
  }

  ngOnInit() {
    // console.log("ProfileComponent::ngOnInit: ", this.authService.currentUser);
    this.currentUser = this.authService.currentUser;
    this.user$ = this.store.pipe(select(selectAktivUser()));
    this.dirty$ = this.store.pipe(select(selectDirtyUser()));
    this.registerSubscription(
      this.user$.subscribe((users) => {
        if (users.length > 0) {
          setTimeout(() => {
            this.processUsers(users);
          }, 100);
        }
      }),
    );

    this.registerSubscription(
      this.dirty$.subscribe((dirtyUsers) => {
        this.dirtyUsers = dirtyUsers;
      }),
    );

    //this._vereinsUser = this.userService.getUser();
    const index = 0;
  }

  processUsers(users: IUser[]) {
    let needSync = false;
    needSync = this.vereinsUsers.length !== users.length;
    if (needSync || !this.hasChanges()) {
      users.sort((a, b) => {
        if (a.password === null) {
          return a.benutzername.localeCompare(b.benutzername);
        } else {
          return -1;
        }
      });
      this._changeEvents = [];
      let index = 0;
      this.vereinsUsers = users.map((user) => {
        const asUString = JSON.stringify(user);
        this._changeEvents.push(this.getNewChangeEvent(index));
        index++;
        const newUser = JSON.parse(asUString);
        return newUser;
      });
    }
  }

  disAllowTab(): boolean {
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
  isValid(): boolean {
    let valid = true;
    this._changeEvents.forEach((ce) => {
      if (!ce.userValid) {
        valid = false;
      }
    });
    return valid;
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
    console.log('Index: ', this.vereinsUsers[this.vereinsUsers.length - 1].benutzername);
    if (this.vereinsUsers[this.vereinsUsers.length - 1].benutzername) {
      return 0;
    }
    return this.vereinsUsers.length - 1;
  }

  getTabName(name: string, tabIndex: number) {
    if (this.hasUnsafedWork(tabIndex)) {
      return name + ' *';
    } else {
      return name;
    }
  }
  hasUnsafedWork(tabIndex: number): boolean {
    const dirtyUser = this.dirtyUsers.filter((user) => user.id === this.vereinsUsers[tabIndex].id);
    return dirtyUser?.length > 0;
  }

  addUser(event: any) {
    const newUser = {
      id: uuidv4(),
      organisationids: [this.authService.currentVerein.id],
      benutzername: '',
      name: '',
      vorname: '',
      email: '',
      handy: '',
      aktiv: true,
      dirty: true,
      password: 'getu',
      rollen: [] as IRolle[],
      userAlreadyExists: false,
    };
    this.vereinsUsers.unshift(JSON.parse(JSON.stringify(newUser)));
    this.store.dispatch(UserActions.addDirtyUser({ payload: newUser }));
    this.tabGroup.selectedIndex = 0;
    this.tabGroup.realignInkBar();
  }
  cancelUser(event: any) {
    this.dirtyUsers.forEach((user) => {
      this.store.dispatch(UserActions.cancelUser({ payload: user }));
    });
  }
  saveUser(event: any) {
    console.log('Saving users: ', this.dirtyUsers);
    this.dirtyUsers.forEach((user) => {
      this.store.dispatch(UserActions.saveUserInvoked({ payload: user }));
    });
  }

  //TODD braucht es das noch?
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
}
