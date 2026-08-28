import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import type { IUser } from 'src/app/core/model/IUser';

@Component({
  selector: 'lxt-user-exists',
  templateUrl: './user-exists.component.html',
  styleUrls: ['./user-exists.component.css'],
  standalone: true,
  imports: [CommonModule, MatDialogModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UserExists {
  readonly data = inject<IUser>(MAT_DIALOG_DATA);
}
