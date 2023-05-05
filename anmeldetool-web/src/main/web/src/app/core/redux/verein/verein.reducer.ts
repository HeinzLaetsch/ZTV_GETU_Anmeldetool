import { createFeature, createReducer, on } from "@ngrx/store";
import { VereinActions } from "./verein.actions";
import { initialState, vereinAdapter } from "./verein.state";

export const vereinFeature = createFeature({
  name: "verein",
  reducer: createReducer(
    initialState,
    on(VereinActions.loadAllVereineSuccess, (state, action) => {
      const vereine = action.payload;
      return vereinAdapter.setAll(vereine, state);
    })
  ),
});
// Spread         ...state,

export const { selectAll, selectEntities, selectIds, selectTotal } =
  vereinAdapter.getSelectors();
