import { Injectable, inject } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { CanDeactivate } from '@angular/router';
import { Observable, map, of } from 'rxjs';
import { HasChangesComponent, type HasChangesDialogResult } from './has-changes.component';

type HasUnsavedTeilnehmerChanges = {
  disAllowTab: () => boolean;
};

@Injectable({
  providedIn: 'root',
})
export class CanDeactivateGuard implements CanDeactivate<HasUnsavedTeilnehmerChanges> {
  private readonly dialog = inject(MatDialog);

  canDeactivate(component: HasUnsavedTeilnehmerChanges): Observable<boolean> {
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
