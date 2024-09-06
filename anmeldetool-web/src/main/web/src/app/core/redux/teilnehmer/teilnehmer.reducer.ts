import { createFeature, createReducer, on } from "@ngrx/store";
import { TeilnehmerActions } from "./teilnehmer.actions";
import { initialState, teilnehmerAdapter } from "./teilnehmer.state";

export const teilnehmerFeature = createFeature({
  name: "teilnehmer",
  reducer: createReducer(
    initialState,
    on(TeilnehmerActions.loadAllTeilnehmerSuccess, (state, action) => {
      const teilnehmer = action.payload;
      return teilnehmerAdapter.setAll(teilnehmer, state);
    }),
    on(TeilnehmerActions.addTeilnehmerSuccess, (state, action) => {
      const teilnehmer = action.payload;
      const newState = teilnehmerAdapter.addOne(teilnehmer, state);
      return newState;
    })
  ),
});

export const { selectAll, selectEntities, selectIds, selectTotal } =
  teilnehmerAdapter.getSelectors();

/*
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
*/
