import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassSummariesState } from "./anlass-summary.state";
import { anlassSummariesFeature } from "./anlass-summary.reducer";
import * as fromAnlassSummaries from "./anlass-summary.reducer";

export const selectAnlassSummariesState =
  //createFeatureSelector<AnlassSummariesState>(anlassSummariesFeature.name);
  createFeatureSelector<AnlassSummariesState>(anlassSummariesFeature.name);

export const selectAllAnlassSummaries = createSelector(
  selectAnlassSummariesState,
  fromAnlassSummaries.selectAll
);

export const selectAnlassSummaryByAnlassId = (id: string) =>
  createSelector(selectAnlassSummariesState, (anlassSummariesState) => {
    const ret = anlassSummariesState.ids.length
      ? anlassSummariesState.entities[id]
      : undefined;
    return ret;
  });

export const selectAnlassSummaries = () =>
  createSelector(selectAllAnlassSummaries, (anlassSummaries) => {
    return anlassSummaries;
  });
