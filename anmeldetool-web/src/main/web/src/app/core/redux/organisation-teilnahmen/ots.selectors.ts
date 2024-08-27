import { createFeatureSelector, createSelector } from "@ngrx/store";
import { OtsState } from "./ots.state";
import { otsFeature } from "./ots.reducer";
import * as fromOts from "./ots.reducer";
import { KategorieEnum } from "../../model/KategorieEnum";

export const selectOtsState = createFeatureSelector<OtsState>(otsFeature.name);

export const selectAllOts = createSelector(selectOtsState, fromOts.selectAll);

export const selectOts = () =>
  createSelector(selectAllOts, (ots) => {
    return ots;
  });
export const selectOtsByAnlassId = (anlassId: string) =>
  createSelector(selectOtsState, (otsState) => {
    const ret = otsState.ids.length ? otsState.entities[anlassId] : undefined;
    return ret;
  });
/*
export const selectOtsForAnlassId = (anlassId: string) =>
  createSelector(selectAllOts, (otsState) => {
    const ret = otsState.filter((x) => anlassId === x.anlassId);
    return ret;
  });
*/
