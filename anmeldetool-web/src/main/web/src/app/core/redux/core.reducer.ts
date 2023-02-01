import { ActionReducerMap, MetaReducer } from "@ngrx/store";
import { environment } from "src/environments/environment";
import { anlassFeature } from "./anlass/anlass.reducer";
import { AppState } from "./core.state";

/*
export const reducers: ActionReducerMap<State> = {
  anlaesse: AnlassReducer.reducer,
  teilnahme: TeilnahmeReducer.reducer,
  oal: OalReducer.reducer,
};
*/

export const metaReducers: MetaReducer<AppState>[] = [];

/*
if (!environment.production) {
  metaReducers.unshift(debug);
}
*/

export const reducers: ActionReducerMap<AppState> = {
  anlaesse: anlassFeature.reducer,
  // router: routerReducer,
  // loading: loadingFeature.reducer,
};
