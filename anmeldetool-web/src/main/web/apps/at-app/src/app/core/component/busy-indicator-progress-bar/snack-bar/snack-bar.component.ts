import { CommonModule } from '@angular/common';
import { Component, inject } from '@angular/core';
import { MAT_SNACK_BAR_DATA, MatSnackBarModule } from '@angular/material/snack-bar';

@Component({
  selector: 'lxt-snack-bar-component',
  templateUrl: './snack-bar.component.html',
  standalone: true,
  imports: [CommonModule, MatSnackBarModule],
  styles: [
    `
      .error-message {
        color: white;
      }
    `,
  ],
})
export class SnackBarComponent {
  private readonly _data = inject(MAT_SNACK_BAR_DATA);
  message = this._data;
}
