import { Action, createReducer, on } from "@ngrx/store";
import { loadAllOalSuccess } from "./oal.actions";
import { initialState, OalState } from "./oal.state";

const oalReducer = createReducer(
  initialState,
  on(loadAllOalSuccess, (state, { payload }) => ({
    ...state,
    items: payload,
  }))
);

export function reducer(state: OalState | undefined, action: Action) {
  return oalReducer(state, action);
}

/*
export interface ReducerOrganisationAnlassState {
  items: ReadonlyArray<IOrganisationAnlassLink>;
  loadStatus: "NOT_LOADED" | "LOADING" | "LOADED";
}
export const initialState: ReducerOrganisationAnlassState = {
  items: [],
  loadStatus: "NOT_LOADED",
};

export function oalReducer(
  state = initialState,
  action: OrganisationAnlassActions
): ReducerOrganisationAnlassState {
  switch (action.type) {
    case ActionTypes.LoadAllOrganisationAnlassFinished: {
      return {
        ...state,
        items: [...action.payload],
        loadStatus: "LOADED",
      };
    }
    default:
      return state;
  }
}
*/
