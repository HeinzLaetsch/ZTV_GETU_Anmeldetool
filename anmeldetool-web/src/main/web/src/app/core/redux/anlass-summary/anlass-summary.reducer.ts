import { createFeature, createReducer, on } from "@ngrx/store";
import { AnlassSummaryActions } from "./anlass-summary.actions";
import { anlassSummaryAdapter, initialState } from "./anlass-summary.state";

export const anlassSummaryFeature = createFeature({
  name: "AnlassSummary",
  reducer: createReducer(
    initialState,
    on(AnlassSummaryActions.loadAllAnlasssummarySuccess, (state, action) => {
      const anlassSummaries = action.payload;
      return anlassSummaryAdapter.setAll(anlassSummaries, state);
    }),
    on(AnlassSummaryActions.refreshAnlasssummarySuccess, (state, action) => {
      const anlassSummary = action.payload;
      return anlassSummaryAdapter.setOne(anlassSummary, state);
    })
  ),
});
// Spread         ...state,

export const { selectAll, selectEntities, selectIds, selectTotal } =
  anlassSummaryAdapter.getSelectors();
