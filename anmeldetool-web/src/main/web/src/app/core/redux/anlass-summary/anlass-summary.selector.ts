import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassSummaryState } from "./anlass-summary.state";
import { anlassSummaryFeature } from "./anlass-summary.reducer";
import * as fromAnlassSummary from "./anlass-summary.reducer";

export const selectAnlassSummaryState =
  createFeatureSelector<AnlassSummaryState>(anlassSummaryFeature.name);

export const selectAllAnlassSummary = createSelector(
  selectAnlassSummaryState,
  fromAnlassSummary.selectAll
);

export const selectAnlassSummaryByAnlassId = (id: string) =>
  createSelector(selectAnlassSummaryState, (anlassSummaryState) => {
    const ret = anlassSummaryState.ids.length
      ? anlassSummaryState.entities[id]
      : undefined;
    return ret;
  });

export const selectAnlassSummary = () =>
  createSelector(selectAllAnlassSummary, (anlassSummary) => {
    return anlassSummary;
  });
