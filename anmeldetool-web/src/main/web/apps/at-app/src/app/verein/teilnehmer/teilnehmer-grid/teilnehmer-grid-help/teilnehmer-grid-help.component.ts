import { Component, inject } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  standalone: true,
  imports: [MaterialModule],
  selector: 'ztv-teilnehmer-grid-help',
  templateUrl: 'teilnehmer-grid-help.component.html',
  styleUrls: ['teilnehmer-grid-help.component.scss'],
})
export class TeilnehmerGridHelpComponent {
  readonly dialogRef = inject(MatDialogRef<TeilnehmerGridHelpComponent>);

  onCloseClick(): void {
    this.dialogRef.close();
  }
}
