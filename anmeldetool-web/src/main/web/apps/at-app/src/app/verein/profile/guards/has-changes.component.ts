import { Component, inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MaterialModule } from 'src/app/shared/material-module';

export type HasChangesDialogResult = 'leave' | 'stay';

@Component({
  selector: 'ztv-has-changes',
  templateUrl: './has-changes.component.html',
  styleUrls: ['./has-changes.component.css'],
  standalone: true,
  imports: [MaterialModule],
})
export class HasChangesComponent {
  readonly data = inject(MAT_DIALOG_DATA);
  readonly dialogRef = inject(MatDialogRef<HasChangesComponent>);

  cancel(): void {
    console.log('Cancel');
    this.dialogRef.close('Cancel');
  }
  save(): void {
    console.log('Save');
    this.dialogRef.close('Save');
  }
}
