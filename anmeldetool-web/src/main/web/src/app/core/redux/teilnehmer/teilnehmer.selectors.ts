import { createFeatureSelector, createSelector } from "@ngrx/store";
import { teilnehmerFeature } from "./teilnehmer.reducer";
import * as fromTeilnehmer from "./teilnehmer.reducer";
import { TeilnehmerState } from "./teilnehmer.state";
import { TiTuEnum } from "../../model/TiTuEnum";

export const selectTeilnehmerState = createFeatureSelector<TeilnehmerState>(
  teilnehmerFeature.name
);

export const selectAllTeilnehmer = createSelector(
  selectTeilnehmerState,
  fromTeilnehmer.selectAll
);

export const selectTeilnehmerById = (id: string) =>
  createSelector(selectTeilnehmerState, (teilnehmerState) => {
    const ret = teilnehmerState.ids.length
      ? teilnehmerState.entities[id]
      : undefined;
    return ret;
  });

export const selectTuTeilnehmer = () =>
  createSelector(selectAllTeilnehmer, (teilnehmerState) => {
    const ret = teilnehmerState.filter((x) =>
      TiTuEnum.equals(TiTuEnum.Tu, x.tiTu)
    );
    return ret;
  });

export const selectTiTeilnehmer = () =>
  createSelector(selectAllTeilnehmer, (teilnehmerState) => {
    const ret = teilnehmerState.filter((x) =>
      TiTuEnum.equals(TiTuEnum.Ti, x.tiTu)
    );
    return ret;
  });
/*
export const selectOalForKeys = (orgId: string, anlassId: string) =>
  createSelector(selectAllAnlaesse, (oalState) => {
    const ret = oalState.filter(
      (x) => orgId === x.organisationsId && anlassId === x.anlassId
    );
    return ret;
  });
  */