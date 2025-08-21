import { Injectable } from "@angular/core";
import { Actions, Effect, createEffect, ofType } from "@ngrx/effects";
import { catchError, map, mergeMap, of, switchMap } from "rxjs";
import { TeilnehmerService } from "../../service/teilnehmer/teilnehmer.service";
import { TeilnehmerActions } from "./teilnehmer.actions";
import { AuthService } from "../../service/auth/auth.service";

@Injectable()
export class TeilnehmerEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private teilnehmerService: TeilnehmerService
  ) {}

  loadAllTeilnehmer$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(TeilnehmerActions.loadAllTeilnehmerInvoked),
      mergeMap((action) => {
        return this.teilnehmerService
          .getTeilnehmer(this.authService.currentVerein)
          .pipe(
            switchMap((teilnehmer) => [
              TeilnehmerActions.loadAllTeilnehmerSuccess({
                payload: teilnehmer,
              }),
            ]),
            catchError((error) => {
              return of(
                TeilnehmerActions.loadAllTeilnehmerError({ error: error })
              );
            })
          );
      })
    );
  });

  addTeilnehmer$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(TeilnehmerActions.addTeilnehmerInvoked),
      mergeMap((action) => {
        return this.teilnehmerService
          .addTeilnehmer(this.authService.currentVerein, action.payload)
          .pipe(
            switchMap((teilnehmer) => [
              TeilnehmerActions.addTeilnehmerSuccess({
                payload: teilnehmer,
              }),
            ]),
            catchError((error) => {
              return of(TeilnehmerActions.addTeilnehmerError({ error: error }));
            })
          );
      })
    );
  });
}

/*
@Injectable()
export class TeilnehmerEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private teilnehmerService: TeilnehmerService
  ) {}

  @Effect()
  loadTeilnehmer$ = this.actions$.pipe(
    ofType(ActionTypes.LoadAllTeilnehmer),
    switchMap(() =>
      this.teilnehmerService
        .getTeilnehmer(this.authService.currentVerein)
        .pipe(
          map(
            (teilnehmer: ITeilnehmer[]) =>
              new LoadAllTeilnehmerFinishedAction(teilnehmer)
          )
        )
    )
  );

  @Effect()
  addTeilnehmer$ = this.actions$.pipe(
    ofType(ActionTypes.AddTeilnehmer),
    switchMap((action: AddTeilnehmerAction) =>
      this.teilnehmerService
        .add(this.authService.currentVerein, action.payload)
        .pipe(
          map(
            (teilnehmer: ITeilnehmer) =>
              new AddTeilnehmerFinishedAction(teilnehmer)
          )
        )
    )
  );
}
*/
