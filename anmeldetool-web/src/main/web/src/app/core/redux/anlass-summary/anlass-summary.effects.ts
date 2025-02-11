import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { catchError, map, mergeMap, of, switchMap } from "rxjs";
import { AuthService } from "../../service/auth/auth.service";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AnlassSummariesActions } from "./anlass-summary.actions";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";

@Injectable()
export class AnlassSummaryEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private anlassService: AnlassService
  ) {}

  loadAnlassSummaries$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(AnlassSummariesActions.loadAllAnlasssummariesInvoked),
      mergeMap((action) => {
        return this.anlassService
          .getAnlassOrganisationSummaries(this.authService.currentVerein)
          .pipe(
            switchMap((anlassSummaries) => [
              AnlassSummariesActions.loadAllAnlasssummariesSuccess({
                payload: anlassSummaries,
              }),
            ]),
            catchError((error) => {
              return of(
                AnlassSummariesActions.loadAllAnlasssummariesError({
                  error: error,
                })
              );
            })
          );
      })
    );
  });

  updateAnlassSummary$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(AnlassSummariesActions.updateAnlasssummaryInvoked),
      mergeMap((action) => {
        const newOal: IOrganisationAnlassLink = {
          anlassId: String(action.payload.id),
          organisationsId: this.authService.currentVerein.id,
          verlaengerungsDate: action.payload.changes.verlaengerungsDate,
          startet: action.payload.changes.startet,
        };
        return this.anlassService.updateVereinsStart(newOal).pipe(
          map(() => {
            return AnlassSummariesActions.updateAnlasssummarySuccess({
              payload: action.payload,
            });
          }),
          catchError((error) => {
            return of(
              AnlassSummariesActions.updateAnlasssummaryError({ error: error })
            );
          })
        );
      })
    );
  });

  refreshSingleAnlassSummary$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(AnlassSummariesActions.refreshAnlasssummaryInvoked),
      mergeMap((action) => {
        return this.anlassService
          .getAnlassOrganisationSummary(
            action.payload.anlass,
            action.payload.verein
          )
          .pipe(
            switchMap((anlassSummary) => [
              AnlassSummariesActions.refreshAnlasssummarySuccess({
                payload: anlassSummary,
              }),
            ]),
            catchError((error) => {
              // 401 handlen
              if (error.status === 401) {
              }
              return of(
                AnlassSummariesActions.refreshAnlasssummaryError({
                  error: error,
                })
              );
            })
          );
      })
    );
  });
}
