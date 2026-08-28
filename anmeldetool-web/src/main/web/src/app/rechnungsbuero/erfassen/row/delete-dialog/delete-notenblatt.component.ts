import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { MatDialogModule, MAT_DIALOG_DATA } from '@angular/material/dialog';
import type { ILauflistenEintrag } from 'src/app/core/model/ILauflistenEintrag';

@Component({
  selector: 'lxt-delete-notenblatt',
  templateUrl: './delete-notenblatt.component.html',
  styleUrls: ['./delete-notenblatt.component.css'],
  standalone: true,
  imports: [MatDialogModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class NotenBlattZurueckZiehen {
  readonly eintrag = inject<ILauflistenEintrag>(MAT_DIALOG_DATA);

  readonly ABBRECHEN = 'abbrechen' as const;
  readonly VERLETZT = 'verletzt' as const;
  readonly NICHT_ANGETRETEN = 'nichtAngetreten' as const;
}
