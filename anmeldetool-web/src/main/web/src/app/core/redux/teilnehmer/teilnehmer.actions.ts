import { createActionGroup, emptyProps, props } from "@ngrx/store";
import type { ITeilnehmer } from "../../model/ITeilnehmer";

export const TeilnehmerActions = createActionGroup({
	source: "teilnehmer",
	events: {
		"Load All teilnehmer invoked": emptyProps(),
		"Load All teilnehmer success": props<{
			payload: ITeilnehmer[];
		}>(),
		"Load All teilnehmer error": props<{ error: string }>(),

		"Add teilnehmer invoked": props<{ payload: ITeilnehmer }>(),
		"Add teilnehmer success": props<{ payload: ITeilnehmer }>(),
		"Add teilnehmer error": props<{ error: string }>(),

		"Delete teilnehmer invoked": props<{ payload: ITeilnehmer }>(),
		"Delete teilnehmer success": emptyProps(),
		"Delete teilnehmer error": props<{ error: string }>(),
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
