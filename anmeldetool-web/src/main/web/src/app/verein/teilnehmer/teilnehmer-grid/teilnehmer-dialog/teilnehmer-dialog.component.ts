import { CommonModule } from '@angular/common';
import { Component, Inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'lxt-teilnehmer-dialog',
  templateUrl: './teilnehmer-dialog.component.html',
  styleUrls: ['./teilnehmer-dialog.component.scss'],
  standalone: true,
  imports: [CommonModule, FormsModule, MatDialogModule, MaterialModule],
})
export class TeilnehmerDialog {
  constructor(
    public dialogRef: MatDialogRef<TeilnehmerDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
  ) {}

  onCancelClick() {
    console.log('Cancel');
    this.dialogRef.close();
  }
}
