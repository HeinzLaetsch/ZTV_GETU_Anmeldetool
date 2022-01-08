import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { IRolle } from "src/app/core/model/IRolle";

@Component({
  selector: "app-role-chip",
  templateUrl: "./role-chip.component.html",
  styleUrls: ["./role-chip.component.css"],
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
