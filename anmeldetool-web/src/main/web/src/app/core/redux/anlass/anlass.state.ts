import { IAnlass } from "../../model/IAnlass";
import { AppState } from "../core.state";

export interface AnlassState {
  items: ReadonlyArray<IAnlass>;
  loadStatus: "NOT_LOADED" | "LOADING" | "LOADED";
}

export const initialState: AnlassState = {
  items: [],
  loadStatus: "NOT_LOADED",
};

export interface State extends AppState {
  anlass: AnlassState;
}
