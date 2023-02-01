import { IAnlassLink } from "../../model/IAnlassLink";

export interface TeilnahmeState {
  items: ReadonlyArray<IAnlassLink>;
  loadStatus: "NOT_LOADED" | "LOADING" | "LOADED";
}

export const initialState: TeilnahmeState = {
  items: [],
  loadStatus: "NOT_LOADED",
};
