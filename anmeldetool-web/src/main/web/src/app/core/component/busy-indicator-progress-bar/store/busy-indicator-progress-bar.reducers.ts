import { createFeature, createReducer, on } from "@ngrx/store";
import { LoadingActions } from "./busy-indicator-progress-bar.actions";
import {
  initialState,
  loadingAdapter,
} from "./busy-indicator-progress-bar.state";

export const loadingFeature = createFeature({
  name: "loading",
  reducer: createReducer(
    initialState,
    on(LoadingActions.loadingEventStartet, (state, action) => {
      console.log("LoadingEvent State created INVOKED: ", state, " ", action);
      const loadingState = action.payload;
      return loadingAdapter.addOne(loadingState, state);
    }),
    on(LoadingActions.loadingEventFinished, (state, action) => {
      console.log("LoadingEvent Store updated FINISHED : ", state, " ", action);
      const loadingState = action.payload;

      const upatedState = loadingAdapter.updateOne(loadingState, state);
      return upatedState;
    }),
    on(LoadingActions.loadingEventFehler, (state, action) => {
      console.log("LoadingEvent Store updated ERROR: ", state, " ", action);
      const loadingState = action.payload;

      const upatedState = loadingAdapter.updateOne(loadingState, state);
      return upatedState;
    }),
    on(LoadingActions.loadingEventProcessed, (state, action) => {
      console.log(
        "LoadingEvent Store element removed PROCESSED: ",
        state,
        " ",
        action
      );
      const loadingStateId = action.payload;

      // Hier später ein Log der Call's darum etwas komplizierter
      const newState = loadingAdapter.removeOne(loadingStateId, state);
      return newState;
    })
  ),
});

export const { selectAll, selectEntities, selectIds, selectTotal } =
  loadingAdapter.getSelectors();
