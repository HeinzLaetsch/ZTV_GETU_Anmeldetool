import { Injectable, inject } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { catchError, map, mergeMap, of } from 'rxjs';
import { OalActions } from './oal.actions';
import { VereinService } from '../../service/verein/verein.service';
import { AnlassService } from '../../service/anlass/anlass.service';

@Injectable({ providedIn: 'root' })
export class OalEffects {
  private actions$ = inject(Actions);
  private vereinService = inject(VereinService);
  private anlassService = inject(AnlassService);

  loadOal$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(OalActions.loadAllOalInvoked),
      mergeMap(() => {
        return this.vereinService.getStarts().pipe(
          map((oals) => OalActions.loadAllOalSuccess({ payload: oals })),
          catchError((error) => {
            return of(OalActions.loadAllOalError({ error: error }));
          }),
        );
      }),
    );
  });

  updateOal$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(OalActions.updateVereinsStartInvoked),
      mergeMap((action) => {
        return this.anlassService.updateVereinsStart(action.payload).pipe(
          map((oal) => {
            return OalActions.updateVereinsStartSuccess({
              payload: oal,
            });
          }),
          catchError((error) => {
            return of(OalActions.updateVereinsStartError({ error: error }));
          }),
        );
      }),
    );
  });
}
