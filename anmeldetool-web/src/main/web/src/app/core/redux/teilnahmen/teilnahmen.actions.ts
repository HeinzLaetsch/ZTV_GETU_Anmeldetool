import type { Update } from "@ngrx/entity";
import { Action, createActionGroup, emptyProps, props } from "@ngrx/store";
import type { ITeilnahmen } from "../../model/ITeilnahmen";
import type { ITeilnehmer } from "../../model/ITeilnehmer";

export const TeilnahmenActions = createActionGroup({
	source: "teilnahmen",
	events: {
		"Refresh all teilnahmen": props<{
			payload: number;
		}>(),
		"Load all teilnahmen invoked": props<{
			payload: number;
		}>(),
		"Load all teilnahmen success": props<{
			payload: ITeilnahmen[];
		}>(),
		"Load all teilnahmen error": props<{ error: string }>(),

		"Add teilnahmen invoked": props<{
			payload: ITeilnahmen;
		}>(),
		"Add teilnahmen success": props<{
			payload: ITeilnahmen;
		}>(),
		"Add teilnahmen error": props<{ error: string }>(),

		"Update teilnahmen invoked": props<{
			payload: ITeilnahmen;
		}>(),
		"Update teilnahmen success": props<{
			payload: Update<ITeilnahmen>;
		}>(),
		"Update teilnahmen error": props<{ error: string }>(),

		"Add teilnehmer invoked": props<{ payload: ITeilnehmer }>(),
		"Add teilnehmer success": props<{ payload: ITeilnehmer }>(),
		"Add teilnehmer error": props<{ error: string }>(),

		"Delete teilnehmer invoked": props<{ payload: ITeilnehmer }>(),
		"Delete teilnehmer success": props<{ payload: string }>(),
		"Delete teilnehmer error": props<{ error: string }>(),
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
