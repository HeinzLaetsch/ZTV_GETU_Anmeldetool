import { Action, createFeature, createReducer, on } from "@ngrx/store";
import { initialState, otsAdapter, OtsState } from "./ots.state";
import { OtsActions } from "./ots.actions";

export const otsFeature = createFeature({
  name: "ots",
  reducer: createReducer(
    initialState,
    on(OtsActions.loadAllOtsSuccess, (state, action) => {
      const ots = action.payload;
      return otsAdapter.setAll(ots, state);
    })
  ),
});

export const { selectAll, selectEntities, selectIds, selectTotal } =
  otsAdapter.getSelectors();
