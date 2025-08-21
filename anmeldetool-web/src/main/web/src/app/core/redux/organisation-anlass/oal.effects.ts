import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { catchError, map, mergeMap, of, switchMap } from "rxjs";
import { OalActions } from "./oal.actions";
import { VereinService } from "../../service/verein/verein.service";
import { AnlassService } from "../../service/anlass/anlass.service";

@Injectable()
export class OalEffects {
  constructor(
    private actions$: Actions,
    private vereinService: VereinService,
    private anlassService: AnlassService
  ) {}

  loadOal$ = createEffect(() => {
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
          })
        );
      })
    );
  });
}
