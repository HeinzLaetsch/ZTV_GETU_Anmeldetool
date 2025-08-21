import { Injectable } from "@angular/core";
import { Actions, createEffect } from "@ngrx/effects";
import { filter, map } from "rxjs/operators";
import { LoadingActions } from "./busy-indicator-progress-bar.actions";
import { ILoading } from "./busy-indicator-progress-bar.state";
import { Update } from "@ngrx/entity";

@Injectable()
export class BusyIndicatorProgressBarEffects {
  constructor(private actions$: Actions) {}

  loadingProcessRunning$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes("INVOKED"); // Service Aufruf Action muss INVOKED beinhalten um Progressbar zu starten
      }),
      map((action) => {
        console.log(
          "Action set isLoading : true: ",
          action.type.substring(0, action.type.indexOf("INVOKED"))
        );
        return LoadingActions.loadingEventStartet({
          payload: {
            id: action.type
              .toUpperCase()
              .substring(0, action.type.indexOf("INVOKED")),
            creationDate: new Date(),
            finishedDate: null,
            isLoading: true,
            isFinished: false,
            hasError: false,
            message: "invoked",
          },
        });
      })
    );
  });

  loadingProcessStopped$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes("SUCCESS"); // Service Aufruf Action muss SUCCESS oder ERROR beinhalten um Progressbar zu stoppen
      }),
      map((action) => {
        // console.log("Action set isLoading : false");
        const updatedLoadingState: Update<ILoading> = {
          id: action.type
            .toUpperCase()
            .substring(0, action.type.indexOf("SUCCESS")),
          changes: {
            finishedDate: new Date(),
            isLoading: false,
            isFinished: true,
            hasError: false,
            message: "success",
          },
        };
        return LoadingActions.loadingEventFinished({
          payload: updatedLoadingState,
        });
      })
    );
  });

  loadingProcessError$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes("ERROR"); // Service Aufruf Action muss SUCCESS oder ERROR beinhalten um Progressbar zu stoppen
      }),
      map((action: any) => {
        console.log("Action ", action);
        const updatedLoadingState: Update<ILoading> = {
          id: action.type
            .toUpperCase()
            .substring(0, action.type.indexOf("ERROR")),
          changes: {
            finishedDate: new Date(),
            isLoading: false,
            isFinished: false,
            hasError: true,
            message: action.error?.message,
          },
        };
        return LoadingActions.loadingEventFehler({
          payload: updatedLoadingState,
        });
      })
    );
  });
}
