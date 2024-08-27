import { Action, createActionGroup, props } from "@ngrx/store";
import { ITeilnahmen } from "../../model/ITeilnahmen";
import { Update } from "@ngrx/entity";

export const TeilnahmenActions = createActionGroup({
  source: "Teilnahmen",
  events: {
    "Refresh All TEILNAHMEN": props<{
      payload: number;
    }>(),
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
      payload: Update<ITeilnahmen>;
    }>(),
    "Update TEILNAHMEN ERROR": props<{ error: string }>(),
  },
});

/*
Check if this is needed !!
export class UpdateTeilnahme implements Action {
  readonly type = TeilnahmenActions.updateTeilnahmenSuccess.type;

  constructor(public payload: Update<ITeilnahmen>) {}
}
*/

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
