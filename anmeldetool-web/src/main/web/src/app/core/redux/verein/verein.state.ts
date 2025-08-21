import { EntityAdapter, EntityState, createEntityAdapter } from "@ngrx/entity";
import { IVerein } from "src/app/verein/verein";

export const vereinAdapter: EntityAdapter<IVerein> =
  createEntityAdapter<IVerein>({
    sortComparer: sortByName,
  });

export function sortByName(a: IVerein, b: IVerein): any {
  return a.name.localeCompare(b.name);
}

export interface VereinState extends EntityState<IVerein> {}

export const initialState: VereinState = vereinAdapter.getInitialState();
