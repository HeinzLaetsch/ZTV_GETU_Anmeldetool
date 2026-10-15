import { createFeatureSelector, createSelector, type MemoizedSelector } from '@ngrx/store';
import { teilnehmerFeature } from './teilnehmer.reducer';
import * as fromTeilnehmer from './teilnehmer.reducer';
import { TeilnehmerState } from './teilnehmer.state';
import { isTiTuEnumEqual, TiTuEnum } from '../../model/TiTuEnum';
import { ITeilnehmer } from '../../model/ITeilnehmer';

export const selectTeilnehmerState = createFeatureSelector<TeilnehmerState>(teilnehmerFeature.name);

export const selectAllTeilnehmer = createSelector(selectTeilnehmerState, fromTeilnehmer.selectAll);

export const selectTeilnehmerById = (id: string): MemoizedSelector<object, ITeilnehmer | undefined> =>
  createSelector(selectTeilnehmerState, (teilnehmerState) => {
    return teilnehmerState.ids.length ? teilnehmerState.entities[id] : undefined;
  });

export const selectTuTeilnehmer = (): MemoizedSelector<object, ITeilnehmer[]> =>
  createSelector(selectAllTeilnehmer, (teilnehmerState) =>
    teilnehmerState.filter((item) => isTiTuEnumEqual(TiTuEnum.Tu, item.tiTu)),
  );

export const selectTiTeilnehmer = (): MemoizedSelector<object, ITeilnehmer[]> =>
  createSelector(selectAllTeilnehmer, (teilnehmerState) =>
    teilnehmerState.filter((item) => isTiTuEnumEqual(TiTuEnum.Ti, item.tiTu)),
  );

export const selectTeilnehmerForAnlass = (anlassId: string): MemoizedSelector<object, ITeilnehmer[]> =>
  createSelector(selectAllTeilnehmer, (teilnehmerState) => {
    return teilnehmerState.map((teilnehmer) => {
      const anlassLinks = (teilnehmer.teilnahmen?.anlassLinks ?? []).filter((link) => link.anlassId === anlassId);
      const result: ITeilnehmer = {
        name: teilnehmer.name,
        vorname: teilnehmer.vorname,
        jahrgang: teilnehmer.jahrgang,
        tiTu: teilnehmer.tiTu,
        teilnahmen: teilnehmer.teilnahmen
          ? {
              ...teilnehmer.teilnahmen,
              anlassLinks,
            }
          : undefined,
      };
      return result;
    });
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
