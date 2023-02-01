import { AnlassState } from "./anlass";
import { OalState } from "./organisation-anlass";
import { TeilnahmeState } from "./teilnahme";

export interface AppState {
  anlaesse: AnlassState;
  // teilnahme: TeilnahmeState;
  // oal: OalState;
}
