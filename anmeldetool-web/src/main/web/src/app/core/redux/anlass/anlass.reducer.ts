import { createFeature, createReducer, on } from "@ngrx/store";
import { AnlassActions } from "./anlass.actions";
import { anlassAdapter, initialState } from "./anlass.state";

export const anlassFeature = createFeature({
  name: "anlass",
  reducer: createReducer(
    initialState,
    on(AnlassActions.loadAllAnlaesseSuccess, (state, action) => {
      const anlaesse = action.payload;
      return anlassAdapter.setAll(anlaesse, state);
    })
  ),
  /*
    on(AnlassActions.loadAllAnlaesseSuccess, (state, action) => {
      const anlaesse = action.payload;
      return {
        items: anlaesse,
        loadStatus: "LOADED",
      };
    })
  ),
  */
});
// Spread         ...state,

export const { selectAll, selectEntities, selectIds, selectTotal } =
  anlassAdapter.getSelectors();
