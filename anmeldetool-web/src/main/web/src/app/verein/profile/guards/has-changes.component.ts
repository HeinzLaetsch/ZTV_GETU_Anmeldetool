import { Component, Inject } from "@angular/core";
import { MatDialogRef, MAT_DIALOG_DATA } from "@angular/material/dialog";

@Component({
  selector: "app-has-changes",
  templateUrl: "./has-changes.component.html",
  styleUrls: ["./has-changes.component.css"],
})
export class HasChangesComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<HasChangesComponent>
  ) {}
  cancel(): void {
    console.log("Cancel");
    this.dialogRef.close("Cancel");
  }
  save(): void {
    console.log("Save");
    this.dialogRef.close("Save");
  }
}
