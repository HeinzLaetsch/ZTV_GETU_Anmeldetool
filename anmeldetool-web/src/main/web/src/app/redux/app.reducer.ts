import { routerReducer } from '@ngrx/router-store';
import { loadingFeature } from '../core/component/busy-indicator-progress-bar/store/busy-indicator-progress-bar.reducers';
import { anlassFeature } from '../core/redux/anlass/anlass.reducer';
import { anlassSummariesFeature } from '../core/redux/anlass-summary/anlass-summary.reducer';
import { oalFeature } from '../core/redux/organisation-anlass/oal.reducer';
import { otsFeature } from '../core/redux/organisation-teilnahmen/ots.reducer';
import { teilnahmenFeature } from '../core/redux/teilnahmen/teilnahmen.reducer';
import { teilnehmerFeature } from '../core/redux/teilnehmer/teilnehmer.reducer';
import { userFeature } from '../core/redux/user/user.reducer';
import { vereinFeature } from '../core/redux/verein/verein.reducer';

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
