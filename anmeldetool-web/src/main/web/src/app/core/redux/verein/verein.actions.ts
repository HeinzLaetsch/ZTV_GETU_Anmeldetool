import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IVerein } from "src/app/verein/verein";

export const VereinActions = createActionGroup({
  source: "Verein",
  events: {
    "Load All Vereine INVOKED": emptyProps(),
    "Load All Vereine SUCCESS": props<{ payload: IVerein[] }>(),
    "Load All Vereine ERROR": props<{ error: string }>(),
  },
});
