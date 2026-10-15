import { createFeatureSelector, createSelector, type MemoizedSelector } from '@ngrx/store';
import type { IOrganisationAnlassLink } from '../../model/IOrganisationAnlassLink';
import { OalState } from './oal.state';
import { oalFeature } from './oal.reducer';
import * as fromOal from './oal.reducer';

export const selectOalState = createFeatureSelector<OalState>(oalFeature.name);

export const selectAllAnlaesse = createSelector(selectOalState, fromOal.selectAll);

export const selectOalByAnlassId = (
  anlassId: string,
): MemoizedSelector<object, IOrganisationAnlassLink | undefined> =>
  createSelector(selectOalState, (oalState) => {
    return oalState.ids.length ? oalState.entities[anlassId] : undefined;
  });

export const selectOalForKeys = (
  orgId: string,
  anlassId: string,
): MemoizedSelector<object, IOrganisationAnlassLink[]> =>
  createSelector(selectAllAnlaesse, (oalState) => {
    const matches = oalState.filter((item) => orgId === item.organisationsId && anlassId === item.anlassId);
    if (matches.length === 0) {
      return [
        {
          organisationsId: orgId,
          anlassId: anlassId,
          startet: false,
          verlaengerungsDate: undefined,
        },
      ];
    }
    return matches;
  });
