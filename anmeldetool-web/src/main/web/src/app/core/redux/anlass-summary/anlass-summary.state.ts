import { EntityAdapter, EntityState, createEntityAdapter } from "@ngrx/entity";
import { IAnlassSummary } from "../../model/IAnlassSummary";

export const anlassSummariesAdapter: EntityAdapter<IAnlassSummary> =
  createEntityAdapter<IAnlassSummary>({
    selectId: (model: IAnlassSummary) => model.anlassId, // Muss wohl ein Zusammengesetzte ID aus Org+Anlass sein
    // sortComparer: sortByName,
  });
/*
export function sortByName(a: IAnlassSummary, b: IAnlassSummary): any {
  return a. .startDatum.getTime() - b.startDatum.getTime();
}
*/
export interface AnlassSummariesState extends EntityState<IAnlassSummary> {}

export const initialState: AnlassSummariesState =
  anlassSummariesAdapter.getInitialState();
