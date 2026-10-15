import {
  ChangeDetectionStrategy,
  Component,
  computed,
  effect,
  inject,
  signal,
  untracked,
  viewChild,
} from '@angular/core';
import type { MatTabGroup } from '@angular/material/tabs';
import { Store } from '@ngrx/store';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import type { AppState } from 'src/app/core/redux/core.state';
import { selectAktivUser, selectDirtyUser, UserActions } from 'src/app/core/redux/user';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { v4 as uuidv4 } from 'uuid';
import type { IVerein } from '../verein';
import type { IChangeEvent } from './IChangeEvent';
import { MaterialModule } from 'src/app/shared/material-module';
import { UserFormComponent } from '../user-form/user-form.component';

@Component({
  selector: 'ztv-profile',
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [MaterialModule, UserFormComponent],
})
export class ProfileComponent {
  private readonly authService = inject(AuthService);
  private readonly store = inject<Store<AppState>>(Store);

  protected readonly tabGroup = viewChild<MatTabGroup>('tabs');
  protected readonly users = this.store.selectSignal(selectAktivUser());
  protected readonly dirtyUsers = this.store.selectSignal(selectDirtyUser());
  protected readonly verein = computed<IVerein>(() => this.authService.currentVerein);
  protected readonly vereinsUsers = signal<IUser[]>([]);
  private readonly changeEvents = signal<IChangeEvent[]>([]);

  protected readonly hasChanges = computed(() => this.dirtyUsers().length > 0);
  protected readonly isValid = computed(() => this.changeEvents().every((changeEvent) => changeEvent.userValid));

  constructor() {
    this.store.dispatch(UserActions.loadAllUserInvoked());

    effect(() => {
      const users = this.users();
      const needSync = untracked(() => this.vereinsUsers().length !== users.length);

      if (users.length > 0 && (needSync || !this.hasChanges())) {
        this.processUsers(users);
      }
    });
  }

  protected readonly getTabName = (name: string, tabIndex: number): string =>
    this.hasUnsavedWork(tabIndex) ? `${name} *` : name;

  protected readonly hasUnsavedWork = (tabIndex: number): boolean => {
    const user = this.vereinsUsers()[tabIndex];
    return user ? this.dirtyUsers().some((dirtyUser) => dirtyUser.id === user.id) : false;
  };

  disAllowTab(): boolean {
    return this.hasChanges();
  }

  private processUsers(users: IUser[]): void {
    const sortedUsers = [...users].sort((firstUser, secondUser) => {
      if (firstUser.password === null) {
        return firstUser.benutzername.localeCompare(secondUser.benutzername);
      }

      return -1;
    });

    this.changeEvents.set(sortedUsers.map((_user, index) => this.getNewChangeEvent(index)));
    this.vereinsUsers.set(sortedUsers.map((user) => structuredClone(user)));
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

  protected addUser(): void {
    const newUser: IUser = {
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
    this.vereinsUsers.update((users) => [structuredClone(newUser), ...users]);
    this.changeEvents.update((events) => [
      this.getNewChangeEvent(0),
      ...events.map((event) => ({ ...event, tabIndex: event.tabIndex + 1 })),
    ]);
    this.store.dispatch(UserActions.addDirtyUser({ payload: newUser }));
    const tabGroup = this.tabGroup();
    if (tabGroup) {
      tabGroup.selectedIndex = 0;
      tabGroup.realignInkBar();
    }
  }
  protected cancelUser(): void {
    this.dirtyUsers().forEach((user) => {
      this.store.dispatch(UserActions.cancelUser({ payload: user }));
    });
  }
  protected saveUser(): void {
    this.dirtyUsers().forEach((user) => {
      this.store.dispatch(UserActions.saveUserInvoked({ payload: user }));
    });
  }

  protected userChange(changeEvent: IChangeEvent): void {
    this.changeEvents.update((events) => {
      const nextEvents = [...events];
      nextEvents[changeEvent.tabIndex] = changeEvent;
      return nextEvents;
    });

    if (changeEvent.saved) {
      return;
    }

    const user = this.vereinsUsers()[changeEvent.tabIndex];
    if (changeEvent.canceled && !user?.id) {
      this.vereinsUsers.update((users) => users.filter((_item, index) => index !== changeEvent.tabIndex));
      this.changeEvents.update((events) => events.filter((_event, index) => index !== changeEvent.tabIndex));
    }
  }
}
