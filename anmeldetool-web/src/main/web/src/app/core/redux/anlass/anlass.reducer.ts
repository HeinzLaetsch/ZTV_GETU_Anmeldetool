import { createFeature, createReducer, on } from "@ngrx/store";
import { AnlassActions } from "./anlass.actions";
import { initialState } from "./anlass.state";

/*
const anlassReducer = createReducer(
  initialState,
  on(loadAllAnlaesseSuccess, (state, { payload }) => ({
    ...state,
    items: payload,
  }))
);

export function reducer(state: AnlassState = initialState, action: Action) {
  return anlassReducer(state, action);
}
*/

export const anlassFeature = createFeature({
  name: "anlass",
  reducer: createReducer(
    initialState,
    on(AnlassActions.loadAllAnlaesseSuccess, (state, action) => ({
      ...state,
      items: action.payload,
    }))
  ),
});
