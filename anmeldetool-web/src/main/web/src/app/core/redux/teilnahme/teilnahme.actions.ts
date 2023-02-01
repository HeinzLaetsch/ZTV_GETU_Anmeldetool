import { Action, createAction, props } from "@ngrx/store";
import { IAnlassLink } from "../../model/IAnlassLink";

export enum ActionTypes {
  LoadAllTeilnahmen = "[Teilnahmen] Load Teilnahmen",
  LoadAllTeilnahmenSuccess = "[Teilnahmen] Load Teilnahmen success",
  LoadAllTeilnahmeFailed = "[Teilnahmen] Load Teilnahmen failed",

  AddTeilnahme = "[Teilnahmen] Add Teilnahme",
  AddTeilnahmeSuccess = "[Teilnahmen] Add Teilnahme success",
  AddTeilnahmeFailed = "[Teilnahmen] Add Teilnahme failed",
}

export const loadAllTeilnahmenAction = createAction(
  ActionTypes.LoadAllTeilnahmen
);

export const loadAllTeilnahmenSuccess = createAction(
  ActionTypes.LoadAllTeilnahmenSuccess,
  props<{ payload: ReadonlyArray<IAnlassLink> }>()
);

export const loadAllAnlaesseFailed = createAction(
  ActionTypes.LoadAllTeilnahmeFailed,
  props<{ error: any }>()
);

export const addTeilnahmeAction = createAction(
  ActionTypes.AddTeilnahme,
  props<{ anlassLink: IAnlassLink }>()
);

export const addTeilnahmeSuccess = createAction(
  ActionTypes.AddTeilnahmeSuccess
);

export const addTeilnahmeFailed = createAction(
  ActionTypes.AddTeilnahmeFailed,
  props<{ error: any }>()
);

/*
export class LoadAllTeilnahmenAction implements Action {
  readonly type = ActionTypes.LoadAllTeilnahmen;
}

export class LoadAllTeilnahmenFinishedAction implements Action {
  readonly type = ActionTypes.LoadAllTeilnahmenFinished;
  constructor(public payload: IAnlassLink[]) {}
}

export class AddTeilnahmeAction implements Action {
  readonly type = ActionTypes.AddTeilnahme;
  constructor(public payload: IAnlassLink) {}
}

export class AddTeilnahmeFinishedAction implements Action {
  readonly type = ActionTypes.AddTeilnahmeFinished;
  constructor(public payload: IAnlassLink) {}
}

export type TeilnahmenActions =
  | AddTeilnahmeAction
  | AddTeilnahmeFinishedAction
  | LoadAllTeilnahmenAction
  | LoadAllTeilnahmenFinishedAction;
*/
