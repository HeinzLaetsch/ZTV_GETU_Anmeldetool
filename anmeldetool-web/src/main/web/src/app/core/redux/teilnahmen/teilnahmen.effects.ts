import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AuthService } from "../../service/auth/auth.service";
import { TeilnahmenActions } from "./teilnahmen.actions";
import { catchError, map, mergeMap, of, switchMap } from "rxjs";
import { AnlassActions } from "../anlass";
import { TeilnehmerService } from "../../service/teilnehmer/teilnehmer.service";
import { ITeilnahmen } from "../../model/ITeilnahmen";
import { Update } from "@ngrx/entity";

@Injectable()
export class TeilnahmenEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private anlassService: AnlassService,
    private teilnehmerService: TeilnehmerService
  ) {}

  loadTeilnahmen$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(TeilnahmenActions.loadAllTeilnahmenInvoked),
      mergeMap((action) => {
        return this.anlassService
          .getTeilnahmen(this.authService.currentVerein, action.payload)
          .pipe(
            map((teilnahmen) =>
              //switchMap((teilnahmen) => [
              TeilnahmenActions.loadAllTeilnahmenSuccess({
                payload: teilnahmen,
              })
            ),
            catchError((error) => {
              return of(
                TeilnahmenActions.loadAllTeilnahmenError({ error: error })
              );
            })
          );
      })
    );
  });

  updateTeilnahmen$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(TeilnahmenActions.updateTeilnahmenInvoked),
      mergeMap((action) => {
        // Hier gesamte Teilnahmen übergeben
        return this.anlassService
          .saveTeilnahme(this.authService.currentVerein, action.payload)
          .pipe(
            map((teilnahmen) => {
              //switchMap((teilnahmen) => [
              const updatedTeilnahme: Update<ITeilnahmen> = {
                id: teilnahmen.teilnehmer.id,
                changes: teilnahmen,
              };
              return TeilnahmenActions.updateTeilnahmenSuccess({
                payload: updatedTeilnahme,
              });
            }),
            catchError((error) => {
              return of(
                TeilnahmenActions.updateTeilnahmenError({ error: error })
              );
            })
          );
      })
    );
  });

  addTeilnehmer$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(TeilnahmenActions.addTeilnehmerInvoked),
      mergeMap((action) => {
        return this.teilnehmerService
          .addTeilnehmer(this.authService.currentVerein, action.payload)
          .pipe(
            switchMap((teilnehmer) => [
              TeilnahmenActions.addTeilnehmerSuccess({
                payload: teilnehmer,
              }),
            ]),
            catchError((error) => {
              return of(TeilnahmenActions.addTeilnehmerError({ error: error }));
            })
          );
      })
    );
  });

  deleteTeilnehmer$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(TeilnahmenActions.deleteTeilnehmerInvoked),
      mergeMap((action) => {
        return this.teilnehmerService
          .delete(this.authService.currentVerein, action.payload)
          .pipe(
            switchMap((teilnehmerId) => [
              TeilnahmenActions.deleteTeilnehmerSuccess({
                payload: teilnehmerId,
              }),
            ]),
            catchError((error) => {
              return of(
                TeilnahmenActions.deleteTeilnehmerError({ error: error })
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
