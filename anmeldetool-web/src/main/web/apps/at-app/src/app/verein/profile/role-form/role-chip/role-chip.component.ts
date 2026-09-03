import { Component, EventEmitter, Input, type OnInit, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import type { IRolle } from 'src/app/core/model/IRolle';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'lxt-role-chip',
  templateUrl: './role-chip.component.html',
  styleUrls: ['./role-chip.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule, MaterialModule],
})
export class RoleChipComponent implements OnInit {
  @Input()
  isVereinsAnmelder: boolean;
  @Input()
  isVereinsVerantwortlicher: boolean;
  @Input()
  role: IRolle;
  @Output()
  roleChange: EventEmitter<IRolle>;

  constructor() {
    this.roleChange = new EventEmitter();
  }

  @Input()
  isAllRolesList: boolean;

  ngOnInit(): void {
    // console.log("Oninit: ", this.role?.name);
  }
  aktivChange(role: IRolle) {
    this.roleChange.emit(role);
  }
}
