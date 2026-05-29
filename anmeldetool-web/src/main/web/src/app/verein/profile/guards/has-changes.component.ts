import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'lxt-has-changes',
  templateUrl: './has-changes.component.html',
  styleUrls: ['./has-changes.component.css'],
  standalone: true,
  imports: [MaterialModule],
})
export class HasChangesComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<HasChangesComponent>,
  ) {}
  cancel(): void {
    console.log('Cancel');
    this.dialogRef.close('Cancel');
  }
  save(): void {
    console.log('Save');
    this.dialogRef.close('Save');
  }
}
