import { Injectable } from "@angular/core";
import { Actions, createEffect } from "@ngrx/effects";
import { filter, map } from "rxjs/operators";
import { LoadingActions } from "./busy-indicator-progress-bar.actions";

@Injectable()
export class BusyIndicatorProgressBarEffects {
  constructor(private actions$: Actions) {}

  loadingProcessRunning$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes("INVOKED"); // Service Aufruf Action muss INVOKED beinhalten um Progressbar zu starten
      }),
      map(() => {
        // console.log("Action set isLoading : true");
        return LoadingActions.isLoading({ isLoading: true });
      })
    );
  });

  loadingProcessStopped$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes("SUCCESS") || action.type.includes("ERROR"); // Service Aufruf Action muss SUCCESS oder ERROR beinhalten um Progressbar zu stoppen
      }),
      map(() => {
        // console.log("Action set isLoading : false");
        return LoadingActions.isLoading({ isLoading: false });
      })
    );
  });
}
