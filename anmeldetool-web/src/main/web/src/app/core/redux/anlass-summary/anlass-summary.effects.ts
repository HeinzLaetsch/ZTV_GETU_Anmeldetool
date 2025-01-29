import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { catchError, mergeMap, of, switchMap } from "rxjs";
import { AuthService } from "../../service/auth/auth.service";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AnlassSummaryActions } from "./anlass-summary.actions";

@Injectable()
export class AnlassSummaryEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private anlassService: AnlassService
  ) {}

  loadAnlassSummary$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(AnlassSummaryActions.loadAllAnlasssummaryInvoked),
      mergeMap((action) => {
        return this.anlassService
          .getAnlassOrganisationSummaries(this.authService.currentVerein)
          .pipe(
            switchMap((anlassSummaries) => [
              AnlassSummaryActions.loadAllAnlasssummarySuccess({
                payload: anlassSummaries,
              }),
            ]),
            catchError((error) => {
              return of(
                AnlassSummaryActions.loadAllAnlasssummaryError({ error: error })
              );
            })
          );
      })
    );
  });

  refreshSingleAnlassSummary$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(AnlassSummaryActions.refreshAnlasssummaryInvoked),
      mergeMap((action) => {
        return this.anlassService
          .getAnlassOrganisationSummary(
            action.payload.anlass,
            action.payload.verein
          )
          .pipe(
            switchMap((anlassSummary) => [
              AnlassSummaryActions.refreshAnlasssummarySuccess({
                payload: anlassSummary,
              }),
            ]),
            catchError((error) => {
              return of(
                AnlassSummaryActions.refreshAnlasssummaryError({ error: error })
              );
            })
          );
      })
    );
  });
}
