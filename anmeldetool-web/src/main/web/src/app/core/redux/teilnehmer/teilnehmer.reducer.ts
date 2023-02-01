import { ITeilnehmer } from "../../model/ITeilnehmer";
import { ActionTypes, TeilnehmerActions } from "./teilnehmer.actions";

export interface ReducerTeilnehmerState {
  items: ITeilnehmer[];
  areTeilnehmerLoaded: boolean;
}
export const initialState: ReducerTeilnehmerState = {
  items: [],
  areTeilnehmerLoaded: false,
};

export function teilnehmerReducer(
  state = initialState,
  action: TeilnehmerActions
): ReducerTeilnehmerState {
  switch (action.type) {
    case ActionTypes.AddTeilnehmerFinished: {
      return {
        ...state,
        items: [...state.items, action.payload],
      };
    }

    case ActionTypes.LoadAllTeilnehmerFinished: {
      return {
        ...state,
        items: [...action.payload],
      };
    }

    default:
      return state;
  }
}
