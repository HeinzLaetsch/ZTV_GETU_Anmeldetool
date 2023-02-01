import { Action, createReducer, on } from "@ngrx/store";
import { loadAllTeilnahmenSuccess } from "./teilnahme.actions";
import { initialState, TeilnahmeState } from "./teilnahme.state";

/*
export interface ReducerTeilnahmenState {
  items: IAnlassLink[];
  areTeilnahmenLoaded: boolean;
}
export const initialState: ReducerTeilnahmenState = {
  items: [],
  areTeilnahmenLoaded: false,
};

export function teilnahmenReducer(
  state = initialState,
  action: TeilnahmenActions
): ReducerTeilnahmenState {
  switch (action.type) {
    case ActionTypes.AddTeilnahmeFinished: {
      return {
        ...state,
        items: [...state.items, action.payload],
      };
    }

    case ActionTypes.LoadAllTeilnahmenFinished: {
      return {
        ...state,
        items: [...action.payload],
      };
    }

    default:
      return state;
  }
}
*/

const teilnahmeReducer = createReducer(
  initialState,
  on(loadAllTeilnahmenSuccess, (state, { payload }) => ({
    ...state,
    items: payload,
  }))
);

export function reducer(state: TeilnahmeState | undefined, action: Action) {
  return teilnahmeReducer(state, action);
}
