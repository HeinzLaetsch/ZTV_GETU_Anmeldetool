import { createFeature, createReducer, createSelector, on } from "@ngrx/store";
import { initialState, teilnahmenAdapter } from "./teilnahmen.state";
import { TeilnahmenActions } from "./teilnahmen.actions";

export const teilnahmenFeature = createFeature({
  name: "teilnahmen",
  reducer: createReducer(
    initialState,
    on(TeilnahmenActions.loadAllTeilnahmenSuccess, (state, action) => {
      const teilnahmen = action.payload;
      // teilnahmenAdapter.addMany(teilnahmen, state);
      return teilnahmenAdapter.setAll(teilnahmen, state);
    }),
    on(TeilnahmenActions.updateTeilnahmenSuccess, (state, action) => {
      const teilnahme = action.payload;
      console.log("Store updated : true");
      return teilnahmenAdapter.updateOne(teilnahme, state);
      // return teilnahmenAdapter.setAll(teilnahmen, state);
    }),
    on(TeilnahmenActions.addTeilnehmerSuccess, (state, action) => {
      const teilnehmer = action.payload;
      const teilnahme = {
        jahr: 0,
        teilnehmer,
      };
      const newState = teilnahmenAdapter.addOne(teilnahme, state);
      return newState;
    }),
    on(TeilnahmenActions.deleteTeilnehmerSuccess, (state, action) => {
      const teilnehmerId = action.payload;
      const newState = teilnahmenAdapter.removeOne(teilnehmerId, state);
      return newState;
    })
  ),
});

export const { selectAll, selectEntities, selectIds, selectTotal } =
  teilnahmenAdapter.getSelectors();

export const selectEntityById = (id) =>
  createSelector(selectEntities, (entities) => entities[id]);
