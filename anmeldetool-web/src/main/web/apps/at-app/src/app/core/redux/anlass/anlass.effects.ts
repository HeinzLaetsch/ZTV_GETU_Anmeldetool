import { inject, Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { catchError, mergeMap, of, switchMap } from 'rxjs';
import { AnlassService } from '../../service/anlass/anlass.service';
import { AnlassActions } from './anlass.actions';

@Injectable({ providedIn: 'root' })
export class AnlassEffects {
  private actions$ = inject(Actions);
  private anlassService = inject(AnlassService);

  loadAnlaesse$ = createEffect(() => {
    console.log('loadAnlaesse$ effect created');
    return this.actions$.pipe(
      ofType(AnlassActions.loadAllAnlaesseInvoked),
      mergeMap((action) => {
        return this.anlassService.getAnlaesse(false).pipe(
          switchMap((anlaesse) => [AnlassActions.loadAllAnlaesseSuccess({ payload: anlaesse })]),
          catchError((error) => {
            return of(AnlassActions.loadAllAnlaesseError({ error: error }));
          }),
        );
      }),
    );
  });
}
