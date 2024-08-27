import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IOrganisationTeilnahmenStatistik } from "../../model/IOrganisationTeilnahmenStatistik";

export const OtsActions = createActionGroup({
  source: "ots",
  events: {
    "Load All OTS INVOKED": props<{ payload: number }>(),
    "Load All OTS SUCCESS": props<{
      payload: IOrganisationTeilnahmenStatistik[];
    }>(),
    "Load All OTS ERROR": props<{ error: string }>(),
  },
});
/*

    "Update Vereins Start INVOKED": props<{
      payload: IOrganisationTeilnahmenStatistik;
    }>(),
    "Update Vereins Start  SUCCESS": props<{
      payload: IOrganisationTeilnahmenStatistik;
    }>(),
    "Update Vereins Start  ERROR": props<{ error: string }>(),
    */
