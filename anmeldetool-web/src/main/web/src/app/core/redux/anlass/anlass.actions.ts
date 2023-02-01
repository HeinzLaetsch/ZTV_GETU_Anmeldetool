import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IAnlass } from "../../model/IAnlass";

/*
export enum ActionTypes {
  LoadAllAnlaesse = "[Anlaesse] Load all Anlaesse",
  LoadAllAnlaesseSuccess = "[Anlaesse] Load all Anlaesse success",
  LoadAllAnlaesseFailed = "[Anlaesse] Load all Anlaesse failed",
}

export const loadAllAnlaesseAction = createAction(ActionTypes.LoadAllAnlaesse);

export const loadAllAnlaesseSuccess = createAction(
  ActionTypes.LoadAllAnlaesseSuccess,
  props<{ payload: ReadonlyArray<IAnlass> }>()
);

export const loadAllAnlaesseFailed = createAction(
  ActionTypes.LoadAllAnlaesseFailed,
  props<{ error: any }>()
);
*/
export const AnlassActions = createActionGroup({
  source: "Anlass",
  events: {
    "Load All Anlaesse": emptyProps(),
    "Load All Anlaesse success": props<{ payload: ReadonlyArray<IAnlass> }>(),
    "Load All Anlaesse error": props<{ error: string }>(),
  },
});
