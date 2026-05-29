import { Component, Inject } from '@angular/core';
import { MatDialogModule, MAT_DIALOG_DATA } from '@angular/material/dialog';
import type { ILauflistenEintrag } from 'src/app/core/model/ILauflistenEintrag';

@Component({
  selector: 'lxt-delete-notenblatt',
  templateUrl: './delete-notenblatt.component.html',
  styleUrls: ['./delete-notenblatt.component.css'],
  standalone: true,
  imports: [MatDialogModule],
})
export class NotenBlattZurueckZiehen {
  readonly ABBRECHEN = 'abbrechen';
  readonly VERLETZT = 'verletzt';
  readonly NICHT_ANGETRETEN = 'nichtAngetreten';

  constructor(@Inject(MAT_DIALOG_DATA) public eintrag: ILauflistenEintrag) {}
}
