import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { catchError, mergeMap, of, switchMap } from "rxjs";
import { VereinService } from "../../service/verein/verein.service";
import { VereinActions } from "./verein.actions";

@Injectable()
export class VereinEffects {
  constructor(
    private actions$: Actions,
    private vereinService: VereinService
  ) {}

  loadVereine$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(VereinActions.loadAllVereineInvoked),
      mergeMap((action) => {
        return this.vereinService.getVereine().pipe(
          switchMap((vereine) => [
            VereinActions.loadAllVereineSuccess({ payload: vereine }),
          ]),
          catchError((error) => {
            return of(VereinActions.loadAllVereineError({ error: error }));
          })
        );
      })
    );
  });
}
