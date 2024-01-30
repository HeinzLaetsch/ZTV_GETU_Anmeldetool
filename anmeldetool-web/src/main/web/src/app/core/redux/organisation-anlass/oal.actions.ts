import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";

export const OalActions = createActionGroup({
  source: "oal",
  events: {
    "Load All OAL INVOKED": emptyProps(),
    "Load All OAL SUCCESS": props<{ payload: IOrganisationAnlassLink[] }>(),
    "Load All OAL ERROR": props<{ error: string }>(),
    "Update Vereins Start INVOKED": props<{
      payload: IOrganisationAnlassLink;
    }>(),
    "Update Vereins Start  SUCCESS": props<{
      payload: IOrganisationAnlassLink;
    }>(),
    "Update Vereins Start  ERROR": props<{ error: string }>(),
  },
});
