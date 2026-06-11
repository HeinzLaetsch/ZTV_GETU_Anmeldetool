import { routerReducer } from '@ngrx/router-store';
import { anlassFeature } from './anlass/anlass.reducer';
import { anlassSummariesFeature } from './anlass-summary/anlass-summary.reducer';
import { oalFeature } from './organisation-anlass/oal.reducer';
import { otsFeature } from './organisation-teilnahmen/ots.reducer';
import { teilnahmenFeature } from './teilnahmen/teilnahmen.reducer';
import { teilnehmerFeature } from './teilnehmer/teilnehmer.reducer';
import { userFeature } from './user/user.reducer';
import { vereinFeature } from './verein/verein.reducer';
import { loadingFeature } from './busy-indicator-progress-bar/busy-indicator-progress-bar.reducers';

export const appReducers = {
  router: routerReducer,
  loading: loadingFeature.reducer,
  anlass: anlassFeature.reducer,
  anlasssummary: anlassSummariesFeature.reducer,
  verein: vereinFeature.reducer,
  user: userFeature.reducer,
  oal: oalFeature.reducer,
  ots: otsFeature.reducer,
  teilnehmer: teilnehmerFeature.reducer,
  teilnahmen: teilnahmenFeature.reducer,
};
