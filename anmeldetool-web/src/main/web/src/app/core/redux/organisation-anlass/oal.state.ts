import { EntityAdapter, EntityState, createEntityAdapter } from "@ngrx/entity";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";

export const oalAdapter: EntityAdapter<IOrganisationAnlassLink> =
  createEntityAdapter<IOrganisationAnlassLink>({
    sortComparer: sortByAnlassId,
  });

export function sortByAnlassId(
  a: IOrganisationAnlassLink,
  b: IOrganisationAnlassLink
): any {
  return a.anlassId.localeCompare(b.anlassId);
}

export interface OalState extends EntityState<IOrganisationAnlassLink> {}

export const initialState: OalState = oalAdapter.getInitialState();

/*
export interface OalState {
  items: ReadonlyArray<IOrganisationAnlassLink>;
  loadStatus: "NOT_LOADED" | "LOADING" | "LOADED";
}

export const initialState: OalState = {
  items: [],
  loadStatus: "NOT_LOADED",
};
*/
