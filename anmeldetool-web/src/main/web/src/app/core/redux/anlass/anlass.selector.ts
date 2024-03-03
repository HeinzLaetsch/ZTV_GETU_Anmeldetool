import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassState } from "./anlass.state";
import { anlassFeature } from "./anlass.reducer";
import * as fromAnlass from "./anlass.reducer";
import { TiTuEnum } from "../../model/TiTuEnum";

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
export const selectAnlaesse = () =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    return anlaesse;
  });
export const selectAllAnlaesseTiTu = (tiTu: TiTuEnum) =>
  createSelector(selectAllAnlaesse, (anlaesse) =>
    anlaesse.filter((anlaess) => {
      if (TiTuEnum.equals(TiTuEnum.Ti, tiTu)) {
        return anlaess.tiAnlass;
      } else {
        return anlaess.tuAnlass;
      }
    })
  );
