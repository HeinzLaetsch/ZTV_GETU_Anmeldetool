import { createActionGroup, props } from "@ngrx/store";
import { ITeilnahmen } from "../../model/ITeilnahmen";

export const TeilnahmenActions = createActionGroup({
  source: "teilnahmen",
  events: {
    "Load All TEILNAHMEN INVOKED": props<{
      payload: number;
    }>(),
    "Load All TEILNAHMEN SUCCESS": props<{
      payload: ITeilnahmen[];
    }>(),
    "Load All TEILNAHMEN ERROR": props<{ error: string }>(),

    "Add TEILNAHMEN INVOKED": props<{
      payload: ITeilnahmen;
    }>(),
    "Add TEILNAHMEN SUCCESS": props<{
      payload: ITeilnahmen;
    }>(),
    "Add TEILNAHMEN ERROR": props<{ error: string }>(),

    "Update TEILNAHMEN INVOKED": props<{
      payload: ITeilnahmen;
    }>(),
    "Update TEILNAHMEN SUCCESS": props<{
      payload: ITeilnahmen;
    }>(),
    "Update TEILNAHMEN ERROR": props<{ error: string }>(),
  },
});

/*
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
*/
