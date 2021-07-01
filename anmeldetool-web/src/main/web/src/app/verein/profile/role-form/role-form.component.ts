import { CdkDragDrop, moveItemInArray, transferArrayItem } from '@angular/cdk/drag-drop';
import { Component, EventEmitter, Input, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { Subscription } from 'rxjs';
import { IRolle } from 'src/app/core/model/IRolle';
import { IUser } from 'src/app/core/model/IUser';
import { CachingRoleService } from 'src/app/core/service/caching-services/caching.role.service';

@Component({
  selector: "app-role",
  templateUrl: "./role-form.component.html",
  styleUrls: ["./role-form.component.css"],
})
export class RoleFormComponent implements OnInit, OnChanges {
  @Input()
  currentUser: IUser;
  @Input()
  isVereinsAnmelder: boolean;
  @Input()
  isVereinsVerantwortlicher: boolean;
  @Input()
  assignedRoles: IRolle[];
  @Output()
  assignedRolesChange = new EventEmitter<IRolle[]>();

  appearance = "outline";
  userValid: boolean;

  _allRoles: IRolle[];

  assignedRolesDirty = false;
  assignedRolesChanged = false;

  constructor(private roleService: CachingRoleService) {
  }

  ngOnInit(): void {
    let localSubscription: Subscription = undefined;
    localSubscription =  this.roleService.loadRoles().subscribe( result => {
      this._allRoles = this.roleService.getRoles();
      // console.log('RoleFormComponent:: ngOnInit: ' , this._allRoles);
      if (localSubscription) {
        localSubscription.unsubscribe();
      }
    });
    // this.reloadRoles(this.currentUser);
    console.log('RoleFormComponent:: ngOnInit: ' , this.assignedRoles);
  }



  ngOnChanges(changes: SimpleChanges) {
    for (const propName in changes) {
      if (changes.currentUser) {
        // console.log('ngOnChanges: ' , changes.user.previousValue, ', ' , changes.user.currentValue);
        // this.reloadRoles(changes.currentUser.currentValue);
      }
    }
  }

  aktivChange(role: IRolle) {
    // console.log('Role: ', role);
    this.assignedRolesChanged = true;
    this.assignedRolesChange.emit(this.assignedRoles);
  }

  get allRoles(): IRolle[] {
    if (this.assignedRoles && this._allRoles) {
      return this._allRoles.filter( value => {
        if (!this.isVereinsVerantwortlicher && value.name === 'VEREINSVERANTWORTLICHER') {
          // console.log('this.isVereinsVerantwortlicher: ' , this.isVereinsVerantwortlicher , value, ' , ');
          return false;
        }
        const notFound =  this.assignedRoles.find(search => search.name === value.name ) === undefined;
        // console.log('this.isVereinsVerantwortlicher: ' , this.isVereinsVerantwortlicher ,'  notFound: ' , notFound , value, ' , ');
        return notFound;
      })
    }
    return this._allRoles;
  }
  set allRoles(value: IRolle[]) {
    this._allRoles = value;
  }

  disableRole(role: IRolle) {
    if (!this.isVereinsAnmelder) {
      return true;
    }
    if (role.name === 'VEREINSVERANTWORTLICHER' && !this.isVereinsVerantwortlicher) {
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
  drop(event: CdkDragDrop<string[]>) {
    console.log('Drop: ' , event);
    if (event.previousContainer === event.container) {
      console.log('move Drop: ' , event);
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
    } else {
      console.log('Transfer Drop: ' , event);
      this.assignedRolesDirty = true;
      transferArrayItem(event.previousContainer.data,
                        event.container.data,
                        event.previousIndex,
                        event.currentIndex);
      this.assignedRoles[event.currentIndex].aktiv = true;
      console.log('Current Index: ' , event.currentIndex, ' , Data: ' , event.container.data[event.currentIndex])
      this.assignedRolesChange.emit(this.assignedRoles);
    }
  }
}
