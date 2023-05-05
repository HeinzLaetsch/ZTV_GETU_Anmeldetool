import { createFeatureSelector, createSelector } from "@ngrx/store";

import * as fromVerein from "./verein.reducer";
import { VereinState } from "./verein.state";

export const selectVereinState = createFeatureSelector<VereinState>(
  fromVerein.vereinFeature.name
);

export const selectAlleVereine = createSelector(
  selectVereinState,
  fromVerein.selectAll
);

export const selectVereinById = (id: string) =>
  createSelector(selectVereinState, (vereinState) =>
    vereinState.entities.length ? vereinState.entities[id] : undefined
  );

export const selectVereinByName = (name: string) =>
  createSelector(selectAlleVereine, (vereine) =>
    vereine.filter((verein) => verein.name === name)
  );
