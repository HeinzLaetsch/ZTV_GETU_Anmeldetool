import { inject, Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { CanDeactivate } from '@angular/router';
import { map, Observable, of } from 'rxjs';
import { ProfileComponent } from '../profile.component';
import { HasChangesComponent, type HasChangesDialogResult } from './has-changes.component';

@Injectable({
  providedIn: 'root',
})
export class CanDeactivateProfileGuard implements CanDeactivate<ProfileComponent> {
  private readonly dialog = inject(MatDialog);

  canDeactivate(component: ProfileComponent): Observable<boolean> {
    if (!component.disAllowTab()) {
      return of(true);
    }

    return this.openDialog();
  }

  private openDialog(): Observable<boolean> {
    const dialogRef = this.dialog.open(HasChangesComponent, {
      disableClose: true,
    });

    return dialogRef.afterClosed().pipe(map((result: HasChangesDialogResult | undefined) => result === 'leave'));
  }
}
