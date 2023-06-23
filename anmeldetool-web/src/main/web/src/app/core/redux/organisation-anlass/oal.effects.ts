import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { catchError, mergeMap, of, switchMap } from "rxjs";
import { OalActions } from "./oal.actions";
import { VereinService } from "../../service/verein/verein.service";

@Injectable()
export class OalEffects {
  constructor(
    private actions$: Actions,
    private vereinService: VereinService
  ) {}

  loadAnlaesse$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(OalActions.loadAllOalInvoked),
      mergeMap((action) => {
        return this.vereinService.getStarts().pipe(
          switchMap((oals) => [
            OalActions.loadAllOalSuccess({ payload: oals }),
          ]),
          catchError((error) => {
            return of(OalActions.loadAllOalError({ error: error }));
          })
        );
      })
    );
  });
}
