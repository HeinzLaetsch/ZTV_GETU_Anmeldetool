import { createFeatureSelector, createSelector, type MemoizedSelector } from '@ngrx/store';
import type { IAnlassSummary } from '../../model/IAnlassSummary';
import { AnlassSummariesState } from './anlass-summary.state';
import { anlassSummariesFeature } from './anlass-summary.reducer';
import * as fromAnlassSummaries from './anlass-summary.reducer';

export const selectAnlassSummariesState =
  //createFeatureSelector<AnlassSummariesState>(anlassSummariesFeature.name);
  createFeatureSelector<AnlassSummariesState>(anlassSummariesFeature.name);

export const selectAllAnlassSummaries = createSelector(selectAnlassSummariesState, fromAnlassSummaries.selectAll);

export const selectAnlassSummaryByAnlassId = (id: string): MemoizedSelector<object, IAnlassSummary | undefined> =>
  createSelector(selectAnlassSummariesState, (anlassSummariesState) => {
    return anlassSummariesState.ids.length ? anlassSummariesState.entities[id] : undefined;
  });

export const selectAnlassSummaries = (): MemoizedSelector<object, IAnlassSummary[]> =>
  createSelector(selectAllAnlassSummaries, (anlassSummaries: IAnlassSummary[]) => anlassSummaries);
