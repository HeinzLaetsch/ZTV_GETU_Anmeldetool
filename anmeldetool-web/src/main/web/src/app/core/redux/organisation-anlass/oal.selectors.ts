import { createFeatureSelector, createSelector } from "@ngrx/store";
import { OalState } from "./oal.state";

export const oalFeatureStateName = "oalFeature";

export const selectOal = createFeatureSelector<OalState>(oalFeatureStateName);

export const selectAllItems = createSelector(
  selectOal,
  (state: OalState) => state.items
);

export const selectLoadStatus = createSelector(
  selectOal,
  (state: OalState) => state.loadStatus
);

export const selectOalForAnlassId = (anlassId: string) =>
  createSelector(selectOal, (state: OalState) =>
    state.items.filter((x) => anlassId === x.anlassId)
  );

export const selectOalForKeys = (orgId: string, anlassId: string) =>
  createSelector(selectOal, (state: OalState) =>
    state.items.filter(
      (x) => orgId === x.organisationsId && anlassId === x.anlassId
    )
  );
