import { routerReducer, RouterReducerState } from "@ngrx/router-store";
import { ActionReducerMap, MetaReducer } from "@ngrx/store";
import { environment } from "src/environments/environment";
import { loadingFeature } from "../component/busy-indicator-progress-bar/store/busy-indicator-progress-bar.reducers";
import { LoadingState } from "../component/busy-indicator-progress-bar/store/busy-indicator-progress-bar.state";
import { AnlassState } from "./anlass";
import { anlassFeature } from "./anlass/anlass.reducer";
import { debug } from "./meta-reducers/debug.reducer";
import { RouterStateUrl } from "./router/router.state";
import { vereinFeature } from "./verein/verein.reducer";
import { VereinState } from "./verein";
import { OalState } from "./organisation-anlass";
import { oalFeature } from "./organisation-anlass/oal.reducer";

export const reducers: ActionReducerMap<AppState> = {
  router: routerReducer,
  loading: loadingFeature.reducer,
  anlass: anlassFeature.reducer,
  verein: vereinFeature.reducer,
  oal: oalFeature.reducer,
};

export const metaReducers: MetaReducer<AppState>[] = [
  // Im Moment kein Localstorage initStateFromLocalStorage,
];

if (!environment.production) {
  metaReducers.unshift(debug);
}

export interface AppState {
  router: RouterReducerState<RouterStateUrl>;
  loading: LoadingState;
  anlass: AnlassState;
  verein: VereinState;
  oal: OalState;
}
