import { inject, Inject, Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { catchError, mergeMap, of, switchMap } from 'rxjs';
import { AnlassService } from '../../service/anlass/anlass.service';
import { OtsActions } from './ots.actions';
import { AuthService } from '../../service/auth/auth.service';

@Injectable({ providedIn: 'root' })
export class OtsEffects {
  private actions$ = inject(Actions);
  private authService = inject(AuthService);
  private anlassService = inject(AnlassService);

  loadOts$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(OtsActions.loadAllOtsInvoked),
      mergeMap((action) => {
        return this.anlassService
          .getOrganisationTeilnahmenStatistik(this.authService.currentVerein, action.payload)
          .pipe(
            switchMap((otss) => [OtsActions.loadAllOtsSuccess({ payload: otss })]),
            catchError((error) => {
              return of(OtsActions.loadAllOtsError({ error: error }));
            }),
          );
      }),
    );
  });
}
