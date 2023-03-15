import { createFeature, createReducer, on } from "@ngrx/store";
import { AnlassActions } from "./anlass.actions";
import { initialState } from "./anlass.state";

export const anlassFeature = createFeature({
  name: "anlass",
  reducer: createReducer(
    initialState,
    on(AnlassActions.loadAllAnlaesse, (state, action) => ({
      loadStatus: "LOADING",
      items: null,
    })),
    on(AnlassActions.loadAllAnlaesseSuccess, (state, action) => {
      const anlaesse = action.payload;
      return {
        items: anlaesse,
        loadStatus: "LOADED",
      };
    })
  ),
});
// Spread         ...state,
