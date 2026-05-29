import { createEntityAdapter, EntityAdapter, EntityState } from '@ngrx/entity';
import { IOrganisationTeilnahmenStatistik } from '../../model/IOrganisationTeilnahmenStatistik';

export const otsAdapter: EntityAdapter<IOrganisationTeilnahmenStatistik> =
  createEntityAdapter<IOrganisationTeilnahmenStatistik>({
    sortComparer: sortByAnlassId,
    selectId: selectAnlassId,
  });
export function selectAnlassId(ots: IOrganisationTeilnahmenStatistik) {
  return ots.anlassId;
}

export function sortByAnlassId(a: IOrganisationTeilnahmenStatistik, b: IOrganisationTeilnahmenStatistik): any {
  return a.anlassId.localeCompare(b.anlassId);
}

export type OtsState = {} & EntityState<IOrganisationTeilnahmenStatistik>

export const initialState: OtsState = otsAdapter.getInitialState();
