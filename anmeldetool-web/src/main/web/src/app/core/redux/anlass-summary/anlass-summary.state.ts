import { EntityAdapter, EntityState, createEntityAdapter } from "@ngrx/entity";
import { IAnlassSummary } from "../../model/IAnlassSummary";

export const anlassSummaryAdapter: EntityAdapter<IAnlassSummary> =
  createEntityAdapter<IAnlassSummary>({
    // sortComparer: sortByName,
  });
/*
export function sortByName(a: IAnlassSummary, b: IAnlassSummary): any {
  return a. .startDatum.getTime() - b.startDatum.getTime();
}
*/
export interface AnlassSummaryState extends EntityState<IAnlassSummary> {}

export const initialState: AnlassSummaryState =
  anlassSummaryAdapter.getInitialState();
