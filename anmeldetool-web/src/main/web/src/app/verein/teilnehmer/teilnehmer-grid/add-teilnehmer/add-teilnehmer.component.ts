import { Component, Inject } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { MAT_DIALOG_DATA, MatDialogModule } from "@angular/material/dialog";
import { MatFormFieldModule } from "@angular/material/form-field";
import { MatInputModule } from "@angular/material/input";
import { MatSelectModule } from "@angular/material/select";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";

@Component({
  selector: "app-add-teilnehmer",
  templateUrl: "./add-teilnehmer.component.html",
  styleUrls: ["./add-teilnehmer.component.css"],
  standalone: true,
  imports: [
    MatDialogModule,
    MatFormFieldModule,
    MatSelectModule,
    MatInputModule,
    FormsModule,
  ],
})
export class AddTeilnehmer {
  constructor(@Inject(MAT_DIALOG_DATA) public data: ITeilnehmer) {}

  onCancelClick() {}
}
