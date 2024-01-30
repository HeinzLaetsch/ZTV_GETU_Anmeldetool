import { Action, createFeature, createReducer, on } from "@ngrx/store";
import {
  initialState,
  teilnahmenAdapter,
  TeilnahmenState,
} from "./teilnahmen.state";
import { TeilnahmenActions } from "./teilnahmen.actions";

export const teilnahmenFeature = createFeature({
  name: "teilnahmen",
  reducer: createReducer(
    initialState,
    on(TeilnahmenActions.loadAllTeilnahmenSuccess, (state, action) => {
      const teilnahmen = action.payload;
      // teilnahmenAdapter.addMany(teilnahmen, state);
      return teilnahmenAdapter.setAll(teilnahmen, state);
    })
  ),
});

export const { selectAll, selectEntities, selectIds, selectTotal } =
  teilnahmenAdapter.getSelectors();

/*
const teilnahmeReducer = createReducer(
  initialState,
  on(loadAllTeilnahmenSuccess, (state, { payload }) => ({
    ...state,
    items: payload,
  }))
);

export function reducer(state: TeilnahmeState | undefined, action: Action) {
  return teilnahmeReducer(state, action);
}
*/
