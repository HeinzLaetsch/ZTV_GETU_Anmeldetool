import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassState } from "./anlass.state";
import { anlassFeature } from "./anlass.reducer";
import * as fromAnlass from "./anlass.reducer";

export const selectAnlasseState = createFeatureSelector<AnlassState>(
  anlassFeature.name
);

export const selectAllAnlaesse = createSelector(
  selectAnlasseState,
  fromAnlass.selectAll
);

export const selectAnlassById = (id: string) =>
  createSelector(selectAnlasseState, (anlaesseState) =>
    anlaesseState.entities.length ? anlaesseState.entities[id] : undefined
  );

export const selectAnlassByName = (anlassBezeichnung: string) =>
  createSelector(selectAllAnlaesse, (anlaesse) =>
    anlaesse.filter(
      (anlaess) => anlaess.anlassBezeichnung === anlassBezeichnung
    )
  );
