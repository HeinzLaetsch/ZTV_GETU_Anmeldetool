import { Action, createFeature, createReducer, on } from "@ngrx/store";
import { OalActions } from "./oal.actions";
import { initialState, oalAdapter, OalState } from "./oal.state";

export const oalFeature = createFeature({
  name: "oal",
  reducer: createReducer(
    initialState,
    on(OalActions.loadAllOalSuccess, (state, action) => {
      const oals = action.payload;
      console.log("Oals loaded: ", oals?.length);

      return oalAdapter.setAll(oals, state);
    })
  ),
});

export const { selectAll, selectEntities, selectIds, selectTotal } =
  oalAdapter.getSelectors();
