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
/*
export enum ActionTypes {
  LoadAllOal = "[Oal] Load OrganisationAnlassLink",
  LoadAllOalSuccess = "[Oal] Load OrganisationAnlassLink success",
  LoadAllOalFailed = "[Oal] Load OrganisationAnlassLink failed",

  UpdateVereinsStart = "[Oal] Update Vereins Start",
  UpdateVereinsStartSuccess = "[Oal] Update Vereins Start success",
  UpdateVereinsStartFailed = "[Oal] Update Vereins Start failed",
}

export const loadAllOalAction = createAction(ActionTypes.LoadAllOal);

export const loadAllOalSuccess = createAction(
  ActionTypes.LoadAllOalSuccess,
  props<{ payload: ReadonlyArray<IOrganisationAnlassLink> }>()
);

export const loadAllOalFailed = createAction(
  ActionTypes.LoadAllOalFailed,
  props<{ error: any }>()
);

export const updateVereinsStart = createAction(
  ActionTypes.UpdateVereinsStart,
  props<{ payload: IOrganisationAnlassLink }>()
);

export const updateVereinsStartSuccess = createAction(
  ActionTypes.UpdateVereinsStartSuccess
);

export const updateVereinsStartFailed = createAction(
  ActionTypes.UpdateVereinsStartFailed,
  props<{ error: any }>()
);
*/
