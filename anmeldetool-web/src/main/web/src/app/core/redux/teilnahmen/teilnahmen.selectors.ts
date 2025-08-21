import { createFeatureSelector, createSelector } from "@ngrx/store";
import { TeilnahmenState } from "./teilnahmen.state";
import { teilnahmenFeature } from "./teilnahmen.reducer";
import * as fromTeilnahmen from "./teilnahmen.reducer";
import { TiTuEnum } from "../../model/TiTuEnum";

export const selectTeilnahmenState = createFeatureSelector<TeilnahmenState>(
  teilnahmenFeature.name
);

export const selectAllTeilnahmen = createSelector(
  selectTeilnahmenState,
  fromTeilnahmen.selectAll
);

export const selectTeilnahmen = () =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => {
    return teilnahmenState;
  });

export const selectTuTeilnahmen = () =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => {
    const ret = teilnahmenState.filter((x) =>
      TiTuEnum.equals(TiTuEnum.Tu, x.teilnehmer.tiTu)
    );
    return ret;
  });

export const selectTiTeilnahmen = () =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => {
    const ret = teilnahmenState.filter((x) =>
      TiTuEnum.equals(TiTuEnum.Ti, x.teilnehmer.tiTu)
    );
    return ret;
  });

export const selectTeilnahmenByAnlassId = (anlassId: String) =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => {
    const ret = teilnahmenState
      .map((x) => {
        const tals = x.talDTOList.filter((y) => y.anlassId === anlassId);
        if (tals.length > 0) {
          return {
            ...x,
            talDTOList: tals,
          };
        }
      })
      .filter((x) => x !== undefined);
    return ret;
  });
