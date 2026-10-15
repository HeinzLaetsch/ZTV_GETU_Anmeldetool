import { createFeatureSelector, createSelector, type MemoizedSelector } from '@ngrx/store';
import { loadingFeature } from './busy-indicator-progress-bar.reducers';
import { type ILoading, LoadingState } from './busy-indicator-progress-bar.state';
import * as fromLoading from './busy-indicator-progress-bar.reducers';

export const selectLoadingState = createFeatureSelector<LoadingState>(loadingFeature.name);

export const selectAllLoading = createSelector(selectLoadingState, fromLoading.selectAll);
export const selectAllLoadings = (): MemoizedSelector<object, ILoading[]> =>
  createSelector(selectAllLoading, (loadingState: ILoading[]) => loadingState);

export const selectLoading = (): MemoizedSelector<object, ILoading[]> =>
  createSelector(selectAllLoading, (loadingState) => loadingState.filter((item) => item.isLoading && !item.isFinished));
export const selectFinished = (): MemoizedSelector<object, ILoading[]> =>
  createSelector(selectAllLoading, (loadingState) => loadingState.filter((item) => item.isFinished));
// Muss noch definiert werden falls Log Funktion
export const selectProcessed = (): MemoizedSelector<object, ILoading[]> =>
  createSelector(selectAllLoading, (loadingState) => loadingState.filter((item) => item.isFinished));
// Muss noch definiert werden falls Log Funktion
export const selectTransactions = (): MemoizedSelector<object, ILoading[]> =>
  createSelector(selectAllLoading, (loadingState) => loadingState.filter((item) => item.isLoading || item.isFinished));
export const selectErrors = (): MemoizedSelector<object, ILoading[]> =>
  createSelector(selectAllLoading, (loadingState) => loadingState.filter((item) => item.hasError));
