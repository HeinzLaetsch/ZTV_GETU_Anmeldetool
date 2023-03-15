import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { Store } from "@ngrx/store";
import {
  catchError,
  exhaustMap,
  filter,
  map,
  mergeMap,
  of,
  switchMap,
  withLatestFrom,
} from "rxjs";
import { IAnlass } from "../../model/IAnlass";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AnlassActions } from "./anlass.actions";
import { selectLoadStatus } from "./anlass.selector";

@Injectable()
export class AnlassEffects {
  constructor(
    private actions$: Actions,
    private anlassService: AnlassService,
    private store: Store
  ) {}

  loadAnlaesse$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(AnlassActions.loadAllAnlaesse),
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

  /*
  // @Effect()
  loadAnlaesse$ = createEffect(() =>
    this.actions$.pipe(
      ofType(AnlassActions.loadAllAnlaesse),
      withLatestFrom(this.store.select(selectLoadStatus)),
      filter(([_, loadStatus]) => loadStatus === "NOT_LOADED"),
      exhaustMap(() =>
        this.anlassService.getAnlaesse().pipe(
          map((anlaesse: ReadonlyArray<IAnlass>) =>
            AnlassActions.loadAllAnlaesseSuccess({ payload: anlaesse })
          ),
          catchError((error) =>
            of(AnlassActions.loadAllAnlaesseError({ error: error }))
          )
        )
      )
    )
  );
  */
}
