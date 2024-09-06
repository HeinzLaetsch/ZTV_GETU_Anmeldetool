import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { ITeilnehmer } from "../../model/ITeilnehmer";

export const TeilnehmerActions = createActionGroup({
  source: "teilnehmer",
  events: {
    "Load All TEILNEHMER INVOKED": emptyProps(),
    "Load All TEILNEHMER SUCCESS": props<{
      payload: ITeilnehmer[];
    }>(),
    "Load All TEILNEHMER ERROR": props<{ error: string }>(),

    "Add TEILNEHMER INVOKED": props<{ payload: ITeilnehmer }>(),
    "Add TEILNEHMER SUCCESS": props<{ payload: ITeilnehmer }>(),
    "Add TEILNEHMER ERROR": props<{ error: string }>(),

    "Delete TEILNEHMER INVOKED": props<{ payload: ITeilnehmer }>(),
    "Delete TEILNEHMER SUCCESS": emptyProps(),
    "Delete TEILNEHMER ERROR": props<{ error: string }>(),
  },
});

/*
export enum ActionTypes {
  LoadAllTeilnehmer = "[Teilnehmer] Load Teilnehmer",
  LoadAllTeilnehmerFinished = "[Teilnehmer] Load Teilnehmer Finished",

  AddTeilnehmer = "[Teilnehmer] Add Teilnehmer",
  AddTeilnehmerFinished = "[Teilnehmer] Add Teilnehmer Finished",
}

export class LoadAllTeilnehmerAction implements Action {
  readonly type = ActionTypes.LoadAllTeilnehmer;
}

export class LoadAllTeilnehmerFinishedAction implements Action {
  readonly type = ActionTypes.LoadAllTeilnehmerFinished;
  constructor(public payload: ITeilnehmer[]) {}
}

export class AddTeilnehmerAction implements Action {
  readonly type = ActionTypes.AddTeilnehmer;
  constructor(public payload: TiTuEnum) {}
}

export class AddTeilnehmerFinishedAction implements Action {
  readonly type = ActionTypes.AddTeilnehmerFinished;
  constructor(public payload: ITeilnehmer) {}
}

export type TeilnehmerActions =
  | AddTeilnehmerAction
  | AddTeilnehmerFinishedAction
  | LoadAllTeilnehmerAction
  | LoadAllTeilnehmerFinishedAction;
*/
