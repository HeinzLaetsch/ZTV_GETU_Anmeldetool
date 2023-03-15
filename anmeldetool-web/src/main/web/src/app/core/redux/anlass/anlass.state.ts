import { IAnlass } from "../../model/IAnlass";

export interface AnlassState {
  items: IAnlass[];
  loadStatus: "NOT_LOADED" | "LOADING" | "LOADED";
}

export const initialState: AnlassState = {
  items: [],
  loadStatus: "NOT_LOADED",
};
