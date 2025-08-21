import { Component, Inject } from "@angular/core";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";

@Component({
  selector: "app-teilnehmer-dialog",
  templateUrl: "./teilnehmer-dialog.component.html",
  styleUrls: ["./teilnehmer-dialog.component.css"],
})
export class TeilnehmerDialog {
  constructor(
    public dialogRef: MatDialogRef<TeilnehmerDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) {}

  onCancelClick() {
    console.log("Cancel");
    this.dialogRef.close();
  }
}
