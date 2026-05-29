import { BusyIndicatorProgressBarEffects } from '../core/component/busy-indicator-progress-bar/store/busy-indicator-progress-bar.effects';
import { AnlassEffects } from '../core/redux/anlass/anlass.effects';
import { AnlassSummaryEffects } from '../core/redux/anlass-summary/anlass-summary.effects';
import { OalEffects } from '../core/redux/organisation-anlass/oal.effects';
import { OtsEffects } from '../core/redux/organisation-teilnahmen/ots.effects';
import { TeilnahmenEffects } from '../core/redux/teilnahmen/teilnahmen.effects';
import { TeilnehmerEffects } from '../core/redux/teilnehmer/teilnehmer.effects';
import { UserEffects } from '../core/redux/user/user.effects';
import { VereinEffects } from '../core/redux/verein/verein.effects';

export const appEffects = [
  AnlassEffects,
  AnlassSummaryEffects,
  BusyIndicatorProgressBarEffects,
  OalEffects,
  OtsEffects,
  TeilnahmenEffects,
  TeilnehmerEffects,
  UserEffects,
  VereinEffects,
];
