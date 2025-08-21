import { createFeature, createReducer, on } from "@ngrx/store";
import { anlassSummariesAdapter, initialState } from "./anlass-summary.state";
import { AnlassSummariesActions } from "./anlass-summary.actions";

export const anlassSummariesFeature = createFeature({
  name: "anlasssummaries",
  reducer: createReducer(
    initialState,
    on(
      AnlassSummariesActions.loadAllAnlasssummariesSuccess,
      (state, action) => {
        const anlassSummaries = action.payload;
        return anlassSummariesAdapter.setAll(anlassSummaries, state);
      }
    ),
    on(AnlassSummariesActions.updateAnlasssummarySuccess, (state, action) => {
      const anlassSummary = action.payload;
      const newState = anlassSummariesAdapter.updateOne(anlassSummary, state);
      return newState;
    }),
    on(AnlassSummariesActions.refreshAnlasssummarySuccess, (state, action) => {
      const anlassSummary = action.payload;
      return anlassSummariesAdapter.setOne(anlassSummary, state);
    })
  ),
});
// Spread         ...state,

export const { selectAll, selectEntities, selectIds, selectTotal } =
  anlassSummariesAdapter.getSelectors();
