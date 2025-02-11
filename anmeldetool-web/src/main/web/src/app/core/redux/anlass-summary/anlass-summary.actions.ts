import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IAnlassSummary } from "../../model/IAnlassSummary";
import { IAnlass } from "../../model/IAnlass";
import { IVerein } from "src/app/verein/verein";
import { Update } from "@ngrx/entity";

export const AnlassSummariesActions = createActionGroup({
  source: "anlasssummaries",
  events: {
    "Load All AnlassSummaries INVOKED": emptyProps(),
    "Load All AnlassSummaries SUCCESS": props<{ payload: IAnlassSummary[] }>(),
    "Load All AnlassSummaries ERROR": props<{ error: string }>(),

    "Update AnlassSummary INVOKED": props<{
      payload: Update<IAnlassSummary>;
    }>(),
    "Update AnlassSummary SUCCESS": props<{
      payload: Update<IAnlassSummary>;
    }>(),
    "Update AnlassSummary ERROR": props<{ error: string }>(),

    "Refresh AnlassSummary INVOKED": props<{
      payload: { anlass: IAnlass; verein: IVerein };
    }>(),
    "Refresh AnlassSummary SUCCESS": props<{ payload: IAnlassSummary }>(),
    "Refresh AnlassSummary ERROR": props<{ error: string }>(),
  },
});
