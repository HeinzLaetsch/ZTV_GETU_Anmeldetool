import { routerReducer, RouterReducerState } from '@ngrx/router-store';
import { ActionReducerMap, MetaReducer } from '@ngrx/store';
import { environment } from 'src/environments/environment';
import { AnlassState } from './anlass';
import { anlassFeature } from './anlass/anlass.reducer';
import { debug } from './meta-reducers/debug.reducer';
import { RouterStateUrl } from './router/router.state';
import { vereinFeature } from './verein/verein.reducer';
import { VereinState } from './verein';
import { OalState } from './organisation-anlass';
import { oalFeature } from './organisation-anlass/oal.reducer';
import { otsFeature } from './organisation-teilnahmen/ots.reducer';
import { OtsState } from './organisation-teilnahmen';
import { userFeature } from './user/user.reducer';
import { UserState } from './user';
import { loadingFeature } from './busy-indicator-progress-bar/busy-indicator-progress-bar.reducers';
import { LoadingState } from './busy-indicator-progress-bar/busy-indicator-progress-bar.state';

export const reducers: ActionReducerMap<AppState> = {
  router: routerReducer,
  loading: loadingFeature.reducer,
  anlass: anlassFeature.reducer,
  // anlassSummary: anlassSummariesFeature.reducer,
  verein: vereinFeature.reducer,
  user: userFeature.reducer,
  oal: oalFeature.reducer,
  ots: otsFeature.reducer,
};

export const metaReducers: MetaReducer<AppState>[] = [
  // Im Moment kein Localstorage initStateFromLocalStorage,
];

if (!environment.production) {
  metaReducers.unshift(debug);
}

export type AppState = {
  router: RouterReducerState<RouterStateUrl>;
  loading: LoadingState;
  anlass: AnlassState;
  // anlassSummary: AnlassSummariesState;
  verein: VereinState;
  user: UserState;
  oal: OalState;
  ots: OtsState;
};
