import { AnlassEffects } from './anlass/anlass.effects';
import { AnlassSummaryEffects } from './anlass-summary/anlass-summary.effects';
import { OalEffects } from './organisation-anlass/oal.effects';
import { OtsEffects } from './organisation-teilnahmen/ots.effects';
import { TeilnahmenEffects } from './teilnahmen/teilnahmen.effects';
import { TeilnehmerEffects } from './teilnehmer/teilnehmer.effects';
import { UserEffects } from './user/user.effects';
import { VereinEffects } from './verein/verein.effects';
import { BusyIndicatorProgressBarEffects } from './busy-indicator-progress-bar/busy-indicator-progress-bar.effects';

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
