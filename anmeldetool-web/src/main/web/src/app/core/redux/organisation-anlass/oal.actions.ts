import { Action, createAction, props } from "@ngrx/store";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";

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

/*
export class LoadAllOrganisationAnlassAction implements Action {
  readonly type = ActionTypes.LoadAllOrganisationAnlass;
}

export class LoadAllOrganisationAnlassFinishedAction implements Action {
  readonly type = ActionTypes.LoadAllOrganisationAnlassFinished;
  constructor(public payload: ReadonlyArray<IOrganisationAnlassLink>) {}
}

export type OrganisationAnlassActions =
  | LoadAllOrganisationAnlassAction
  | LoadAllOrganisationAnlassFinishedAction;
*/
