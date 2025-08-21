import { createFeatureSelector, createSelector } from "@ngrx/store";
import { loadingFeature } from "./busy-indicator-progress-bar.reducers";
import { LoadingState } from "./busy-indicator-progress-bar.state";
import * as fromLoading from "./busy-indicator-progress-bar.reducers";

export const selectLoadingState = createFeatureSelector<LoadingState>(
  loadingFeature.name
);

export const selectAllLoading = createSelector(
  selectLoadingState,
  fromLoading.selectAll
);
export const selectAllLoadings = () =>
  createSelector(selectAllLoading, (loadingState) => {
    return loadingState;
  });

export const selectLoading = () =>
  createSelector(selectAllLoading, (loadingState) => {
    const ret = loadingState.filter((x) => x.isLoading && !x.isFinished);
    return ret;
  });
export const selectFinished = () =>
  createSelector(selectAllLoading, (loadingState) => {
    const ret = loadingState.filter((x) => x.isFinished);
    return ret;
  });
// Muss noch definiert werden falls Log Funktion
export const selectProcessed = () =>
  createSelector(selectAllLoading, (loadingState) => {
    const ret = loadingState.filter((x) => x.isFinished);
    return ret;
  });
// Muss noch definiert werden falls Log Funktion
export const selectTransactions = () =>
  createSelector(selectAllLoading, (loadingState) => {
    const ret = loadingState.filter((x) => x.isLoading || x.isFinished);
    return ret;
  });
export const selectErrors = () =>
  createSelector(selectAllLoading, (loadingState) => {
    const ret = loadingState.filter((x) => x.hasError);
    return ret;
  });
