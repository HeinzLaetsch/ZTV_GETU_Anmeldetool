import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassState } from "./anlass.state";

export const anlassFeatureStateName = "anlassFeature";

export const selectAnlass = createFeatureSelector<AnlassState>(
  anlassFeatureStateName
);

export const selectAllItems = createSelector(
  selectAnlass,
  (state: AnlassState) => state?.items
);

export const selectLoadStatus = createSelector(
  selectAnlass,
  (state: AnlassState) => state?.loadStatus
);

export const selectAnlassForId = (id: string) =>
  createSelector(selectAnlass, (state: AnlassState) =>
    state.items.filter((x) => id === x.id)
  );
