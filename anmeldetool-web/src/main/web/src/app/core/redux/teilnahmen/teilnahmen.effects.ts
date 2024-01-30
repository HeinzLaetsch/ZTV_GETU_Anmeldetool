import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AuthService } from "../../service/auth/auth.service";
import { TeilnahmenActions } from "./teilnahmen.actions";
import { catchError, mergeMap, of, switchMap } from "rxjs";

@Injectable()
export class TeilnahmenEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private anlassService: AnlassService
  ) {}

  loadTeilnahmen$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(TeilnahmenActions.loadAllTeilnahmenInvoked),
      mergeMap((action) => {
        return this.anlassService
          .getTeilnahmen(this.authService.currentVerein, action.payload)
          .pipe(
            switchMap((teilnahmen) => [
              TeilnahmenActions.loadAllTeilnahmenSuccess({
                payload: teilnahmen,
              }),
            ]),
            catchError((error) => {
              return of(
                TeilnahmenActions.loadAllTeilnahmenError({ error: error })
              );
            })
          );
      })
    );
  });

  /*
  @Effect()
  loadTodos$ = this.actions$.pipe(
    ofType(ActionTypes.LoadAllTeilnahmen),
    switchMap((action: AddTeilnahmeAction) =>
      this.anlassService getTeilnehmer(action.payload, this.authService.currentVerein);

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
  */
}
