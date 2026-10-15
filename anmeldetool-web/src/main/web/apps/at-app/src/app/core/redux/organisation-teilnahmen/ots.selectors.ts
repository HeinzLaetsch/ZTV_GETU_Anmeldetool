import { createFeatureSelector, createSelector, type MemoizedSelector } from '@ngrx/store';
import type { IOrganisationTeilnahmenStatistik } from '../../model/IOrganisationTeilnahmenStatistik';
import { OtsState } from './ots.state';
import { otsFeature } from './ots.reducer';
import * as fromOts from './ots.reducer';

export const selectOtsState = createFeatureSelector<OtsState>(otsFeature.name);

export const selectAllOts = createSelector(selectOtsState, fromOts.selectAll);

export const selectOts = (): MemoizedSelector<object, IOrganisationTeilnahmenStatistik[]> =>
  createSelector(selectAllOts, (ots: IOrganisationTeilnahmenStatistik[]) => ots);
export const selectOtsByAnlassId = (
  anlassId: string,
): MemoizedSelector<object, IOrganisationTeilnahmenStatistik | undefined> =>
  createSelector(selectOtsState, (otsState) => {
    return otsState.ids.length ? otsState.entities[anlassId] : undefined;
  });
/*
export const selectOtsForAnlassId = (anlassId: string) =>
  createSelector(selectAllOts, (otsState) => {
    const ret = otsState.filter((x) => anlassId === x.anlassId);
    return ret;
  });
*/
