import { ChangeDetectionStrategy, Component, computed, effect, inject, input, output, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { DestroyRef } from '@angular/core';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import type { IWertungsrichter } from 'src/app/core/model/IWertungsrichter';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingRoleService } from 'src/app/core/service/caching-services/caching.role.service';
import { CachingUserService } from 'src/app/core/service/caching-services/caching.user.service';
import { UserComponent } from 'src/app/shared/component/user/user.component';
import type { IChangeEvent } from '../profile/IChangeEvent';
import { RoleFormComponent } from '../profile/role-form/role-form.component';
import { WertungsrichterFormComponent } from '../profile/wertungsrichter-form/wertungsrichter-form.component';

@Component({
  selector: 'ztv-user-form',
  templateUrl: './user-form.component.html',
  styleUrl: './user-form.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [UserComponent, RoleFormComponent, WertungsrichterFormComponent],
})
export class UserFormComponent {
  protected readonly currentUser = input.required<IUser>();
  protected readonly tabIndex = input.required<number>();
  protected readonly userDirty = input(false);
  protected readonly userChange = output<IChangeEvent>();

  private readonly authService = inject(AuthService);
  private readonly userService = inject(CachingUserService);
  private readonly roleService = inject(CachingRoleService);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly assignedRoles = signal<IRolle[]>([]);
  protected readonly wertungsrichter = signal<IWertungsrichter>(this.getEmptyWertungsrichter());
  private readonly changeEvent = signal<IChangeEvent>(this.getNewChangeEvent(-1));

  protected readonly isVereinsAnmelder = computed(
    () => this.authService.isAdministratorSig() || this.authService.isVereinsAnmmelderSig(),
  );
  protected readonly isVereinsVerantwortlicher = computed(
    () => this.authService.isAdministratorSig() || this.authService.isVereinsVerantwortlicherSig(),
  );
  protected readonly isWertungsrichter = computed(() =>
    this.assignedRoles().some((role) => role.name === 'WERTUNGSRICHTER' && role.aktiv),
  );
  protected readonly isOwner = computed(
    () =>
      this.authService.isAdministratorSig() ||
      this.currentUser().benutzername === this.authService.currentUser?.benutzername,
  );

  constructor() {
    effect((onCleanup) => {
      const user = this.currentUser();
      if (!user.id) {
        this.assignedRoles.set([]);
        this.updateChangeEvent({ userValid: false });
        return;
      }

      const rolesSubscription = this.roleService.getRolesForUser(user).subscribe((roles) => {
        this.assignedRoles.set(roles);
        this.updateChangeEvent({ hasWr: this.isWertungsrichter() });
      });
      const wertungsrichterSubscription = this.userService.getWertungsrichter(user.id).subscribe((value) => {
        if (value) {
          this.wertungsrichter.set(value);
        }
      });

      onCleanup(() => {
        rolesSubscription.unsubscribe();
        wertungsrichterSubscription.unsubscribe();
      });
    });
  }

  protected readonly isReadOnly = computed(
    () => !(this.isOwner() || this.isVereinsAnmelder() || this.isVereinsVerantwortlicher()),
  );

  private getEmptyWertungsrichter(): IWertungsrichter {
    return {
      id: '',
      brevet: 1,
      gueltig: false,
      letzterFK: new Date(),
      aktiv: false,
    };
  }
  protected isUserDirty(): boolean {
    return this.userDirty();
  }

  protected readonly userHasChanged = computed(() => this.changeEvent().userHasChanged);

  protected onUserChange(user: IUser): void {
    Object.assign(this.currentUser(), user);
    this.updateChangeEvent({ userHasChanged: true });
  }

  protected onAssignedRolesChange(roles: IRolle[]): void {
    const hasWr = roles.some((role) => role.name === 'WERTUNGSRICHTER' && role.aktiv);
    this.assignedRoles.set(roles);
    this.updateChangeEvent({
      rolesChanged: true,
      wrChanged: this.changeEvent().hasWr !== hasWr,
      hasWr,
    });
    this.saveRolesChanged(roles);
    this.checkWrChanged();
  }

  protected onWertungsrichterChange(value: IWertungsrichter): void {
    this.wertungsrichter.set(value);
    this.updateChangeEvent({ wrChanged: true });
    this.checkWrChanged();
  }

  protected updateUserValid(valid: boolean): void {
    this.updateChangeEvent({ userValid: valid });
  }

  private updateChangeEvent(changes: Partial<IChangeEvent>): void {
    const nextChangeEvent = { ...this.changeEvent(), ...changes, tabIndex: this.tabIndex() };
    this.changeEvent.set(nextChangeEvent);
    this.userChange.emit(nextChangeEvent);
  }

  private getNewChangeEvent(index: number): IChangeEvent {
    return {
      tabIndex: index,
      hasWr: false,
      rolesChanged: false,
      userHasChanged: false,
      userValid: true,
      wrChanged: false,
      canceled: false,
      saved: false,
    };
  }

  private saveRolesChanged(roles: IRolle[]): void {
    this.userService
      .updateRoles(this.currentUser(), this.authService.currentVerein, roles)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((user) => {
        Object.assign(this.currentUser(), user);
        this.updateChangeEvent({ saved: true, rolesChanged: false });
      });
  }

  private checkWrChanged(): void {
    const changeEvent = this.changeEvent();
    const userId = this.currentUser().id;
    if (!changeEvent.wrChanged || !userId) {
      return;
    }

    if (changeEvent.hasWr) {
      const newWertungsrichter = { ...structuredClone(this.wertungsrichter()), personId: userId };
      this.userService
        .updateWertungsrichter(userId, newWertungsrichter)
        .pipe(takeUntilDestroyed(this.destroyRef))
        .subscribe((value) => {
          if (value) {
            this.wertungsrichter.set(value);
          }
          this.updateChangeEvent({ wrChanged: false });
        });
      return;
    }

    this.userService
      .deleteWertungsrichterForUserId(userId)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(() => {
        this.wertungsrichter.set(this.getEmptyWertungsrichter());
        this.updateChangeEvent({ wrChanged: false });
      });
  }
}
