import { Component, Inject } from "@angular/core";
import { MAT_DIALOG_DATA } from "@angular/material/dialog";
import { IUser } from "src/app/core/model/IUser";

@Component({
  selector: "app-user-exists",
  templateUrl: "./user-exists.component.html",
  styleUrls: ["./user-exists.component.css"],
})
export class UserExists {
  constructor(@Inject(MAT_DIALOG_DATA) public data: IUser) {}
}
