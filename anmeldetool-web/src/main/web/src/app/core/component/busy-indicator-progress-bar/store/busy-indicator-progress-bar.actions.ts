import { createActionGroup, props } from "@ngrx/store";
import { ILoading } from "./busy-indicator-progress-bar.state";
import { Update } from "@ngrx/entity";

export const LoadingActions = createActionGroup({
  source: "loading",
  events: {
    "Loading Event STARTET": props<{ payload: ILoading }>(),
    "Loading Event FINISHED": props<{ payload: Update<ILoading> }>(),
    "Loading Event FEHLER": props<{ payload: Update<ILoading> }>(),
    "Loading Event PROCESSED": props<{ payload: string }>(),
  },
});
