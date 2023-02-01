import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";

export interface OalState {
  items: ReadonlyArray<IOrganisationAnlassLink>;
  loadStatus: "NOT_LOADED" | "LOADING" | "LOADED";
}

export const initialState: OalState = {
  items: [],
  loadStatus: "NOT_LOADED",
};
