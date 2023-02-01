import {
  ActionReducerMap,
  createFeatureSelector,
  createSelector,
} from "@ngrx/store";
import { IAnlassLink } from "../../model/IAnlassLink";
import {
  KategorieEnum,
  KategorieEnumFunction,
} from "../../model/KategorieEnum";

export * from "./teilnahme.state";
export * from "./teilnahme.actions";
export * from "./teilnahme.selectors";
export * from "./teilnahme.effects";

/*
export const featureStateName = "teilnahmenFeature";

export interface TeilnahmenState {
  teilnahmen: ReducerTeilnahmenState;
}

export const teilnahmenReducers: ActionReducerMap<TeilnahmenState> = {
  teilnahmen: teilnahmenReducer,
};


*/
