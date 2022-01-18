import { Component, Inject } from "@angular/core";
import { MAT_DIALOG_DATA } from "@angular/material/dialog";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { IUser } from "src/app/core/model/IUser";

@Component({
  selector: "app-delete-user",
  templateUrl: "./delete-user.component.html",
  styleUrls: ["./delete-user.component.css"],
})
export class DeleteUser {
  constructor(@Inject(MAT_DIALOG_DATA) public data: ITeilnehmer) {}
}
