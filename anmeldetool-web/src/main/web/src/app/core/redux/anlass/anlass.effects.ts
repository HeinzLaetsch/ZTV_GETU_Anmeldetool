import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { catchError, mergeMap, of, switchMap } from "rxjs";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AnlassActions } from "./anlass.actions";

@Injectable()
export class AnlassEffects {
  constructor(
    private actions$: Actions,
    private anlassService: AnlassService
  ) {}

  loadAnlaesse$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(AnlassActions.loadAllAnlaesseInvoked),
      mergeMap((action) => {
        return this.anlassService.getAnlaesse().pipe(
          switchMap((anlaesse) => [
            AnlassActions.loadAllAnlaesseSuccess({ payload: anlaesse }),
          ]),
          catchError((error) => {
            return of(AnlassActions.loadAllAnlaesseError({ error: error }));
          })
        );
      })
    );
  });
}
