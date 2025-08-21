import { createFeature, createReducer, on } from "@ngrx/store";
import { initialState, otsAdapter } from "./ots.state";
import { OtsActions } from "./ots.actions";

export const otsFeature = createFeature({
  name: "ots",
  reducer: createReducer(
    initialState,
    on(OtsActions.loadAllOtsSuccess, (state, action) => {
      if (action.payload) {
        const ots = action.payload;
        return otsAdapter.setAll(ots, state);
      }
      return state;
    })
  ),
});

export const { selectAll, selectEntities, selectIds, selectTotal } =
  otsAdapter.getSelectors();
