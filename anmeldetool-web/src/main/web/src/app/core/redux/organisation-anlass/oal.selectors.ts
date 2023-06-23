import { createFeatureSelector, createSelector } from "@ngrx/store";
import { OalState } from "./oal.state";
import { oalFeature } from "./oal.reducer";
import * as fromOal from "./oal.reducer";

export const selectOalState = createFeatureSelector<OalState>(oalFeature.name);

export const selectAllAnlaesse = createSelector(
  selectOalState,
  fromOal.selectAll
);

export const selectOalByAnlassId = (anlassId: string) =>
  createSelector(selectOalState, (oalState) => {
    const ret = oalState.ids.length ? oalState.entities[anlassId] : undefined;
    return ret;
  });

export const selectOalForKeys = (orgId: string, anlassId: string) =>
  createSelector(selectAllAnlaesse, (oalState) => {
    const ret = oalState.filter(
      (x) => orgId === x.organisationsId && anlassId === x.anlassId
    );
    return ret;
  });
