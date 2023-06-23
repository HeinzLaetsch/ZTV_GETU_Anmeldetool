import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassState } from "./anlass.state";
import { anlassFeature } from "./anlass.reducer";
import * as fromAnlass from "./anlass.reducer";

export const selectAnlaesseState = createFeatureSelector<AnlassState>(
  anlassFeature.name
);

export const selectAllAnlaesse = createSelector(
  selectAnlaesseState,
  fromAnlass.selectAll
);

export const selectAnlassById = (id: string) =>
  createSelector(selectAnlaesseState, (anlaesseState) => {
    const ret = anlaesseState.ids.length
      ? anlaesseState.entities[id]
      : undefined;
    return ret;
  });

export const selectAnlassByName = (anlassBezeichnung: string) =>
  createSelector(selectAllAnlaesse, (anlaesse) =>
    anlaesse.filter(
      (anlaess) => anlaess.anlassBezeichnung === anlassBezeichnung
    )
  );
