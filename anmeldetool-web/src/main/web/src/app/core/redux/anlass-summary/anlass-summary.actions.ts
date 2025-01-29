import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IAnlassSummary } from "../../model/IAnlassSummary";
import { IAnlass } from "../../model/IAnlass";
import { IVerein } from "src/app/verein/verein";

export const AnlassSummaryActions = createActionGroup({
  source: "AnlassSummary",
  events: {
    "Load All AnlassSummary INVOKED": emptyProps(),
    "Load All AnlassSummary SUCCESS": props<{ payload: IAnlassSummary[] }>(),
    "Load All AnlassSummary ERROR": props<{ error: string }>(),

    "Refresh AnlassSummary INVOKED": props<{
      payload: { anlass: IAnlass; verein: IVerein };
    }>(),
    "Refresh AnlassSummary SUCCESS": props<{ payload: IAnlassSummary }>(),
    "Refresh AnlassSummary ERROR": props<{ error: string }>(),
  },
});
