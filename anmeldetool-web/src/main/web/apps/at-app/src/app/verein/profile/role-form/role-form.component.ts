import { type CdkDragDrop, moveItemInArray, transferArrayItem } from '@angular/cdk/drag-drop';
import { DragDropModule } from '@angular/cdk/drag-drop';
import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, inject, input, type OnInit, output } from '@angular/core';
import type { Subscription } from 'rxjs';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import { CachingRoleService } from 'src/app/core/service/caching-services/caching.role.service';
import { RoleChipComponent } from './role-chip/role-chip.component';

@Component({
  selector: 'ztv-role',
  templateUrl: './role-form.component.html',
  styleUrls: ['./role-form.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, DragDropModule, RoleChipComponent],
})
export class RoleFormComponent implements OnInit {
  readonly currentUser = input.required<IUser>();
  readonly isVereinsAnmelder = input.required<boolean>();
  readonly isVereinsVerantwortlicher = input.required<boolean>();
  readonly assignedRoles = input.required<IRolle[]>();
  readonly assignedRolesChange = output<IRolle[]>();

  appearance = 'outline';
  userValid: boolean;

  _allRoles: IRolle[];

  assignedRolesDirty = false;
  assignedRolesChanged = false;

  private readonly roleService = inject(CachingRoleService);

  ngOnInit(): void {
    const localSubscription: Subscription = this.roleService.loadRoles().subscribe(() => {
      this._allRoles = this.roleService.getRoles();
      // console.log('RoleFormComponent:: ngOnInit: ' , this._allRoles);
      if (localSubscription) {
        localSubscription.unsubscribe();
      }
    });
    // this.reloadRoles(this.currentUser);
    // console.log('RoleFormComponent:: ngOnInit: ' , this.assignedRoles);
  }

  aktivChange(_role: IRolle): void {
    // console.log('Role: ', role);
    this.assignedRolesChanged = true;
    this.assignedRolesChange.emit(this.assignedRoles());
  }

  get allRoles(): IRolle[] {
    if (this.assignedRoles() && this._allRoles) {
      return this._allRoles.filter((value) => {
        if (!this.isVereinsVerantwortlicher() && value.name === 'VEREINSVERANTWORTLICHER') {
          // console.log('this.isVereinsVerantwortlicher: ' , this.isVereinsVerantwortlicher , value, ' , ');
          return false;
        }
        const notFound = this.assignedRoles().find((search) => search.name === value.name) === undefined;
        // console.log('this.isVereinsVerantwortlicher: ' , this.isVereinsVerantwortlicher ,'  notFound: ' , notFound , value, ' , ');
        return notFound;
      });
    }
    return this._allRoles;
  }
  set allRoles(value: IRolle[]) {
    this._allRoles = value;
  }

  disableRole(role: IRolle): boolean {
    if (!this.isVereinsAnmelder()) {
      return true;
    }
    if (role.name === 'VEREINSVERANTWORTLICHER' && !this.isVereinsVerantwortlicher()) {
      return true;
    }
    return false;
  }

  /*
  get assignedRoles(): IRolle[] {
    return this._assignedRoles;
  }
  set assignedRoles(value: IRolle[]) {
    this._assignedRoles = value;
  }
*/
  drop(event: CdkDragDrop<IRolle[]>): void {
    console.log('Drop: ', event);
    if (event.previousContainer === event.container) {
      console.log('move Drop: ', event);
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
    } else {
      console.log('Transfer Drop: ', event);
      this.assignedRolesDirty = true;
      transferArrayItem(event.previousContainer.data, event.container.data, event.previousIndex, event.currentIndex);
      if (this.assignedRoles()[event.currentIndex]) {
        this.assignedRoles()[event.currentIndex].aktiv = true;
      }
      console.log('Current Index: ', event.currentIndex, ' , Data: ', event.container.data[event.currentIndex]);
      this.assignedRolesChange.emit(this.assignedRoles());
    }
  }
}
