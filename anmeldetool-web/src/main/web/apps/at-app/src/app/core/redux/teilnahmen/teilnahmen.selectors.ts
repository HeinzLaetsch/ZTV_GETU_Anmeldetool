import { createFeatureSelector, createSelector, type MemoizedSelector } from '@ngrx/store';
import type { ITeilnahmen } from '../../model/ITeilnahmen';
import { TeilnahmenState } from './teilnahmen.state';
import { teilnahmenFeature } from './teilnahmen.reducer';
import * as fromTeilnahmen from './teilnahmen.reducer';
import { isTiTuEnumEqual, TiTuEnum } from '../../model/TiTuEnum';

export const selectTeilnahmenState = createFeatureSelector<TeilnahmenState>(teilnahmenFeature.name);

export const selectAllTeilnahmen = createSelector(selectTeilnahmenState, fromTeilnahmen.selectAll);

export const selectTeilnahmen = (): MemoizedSelector<object, ITeilnahmen[]> =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => teilnahmenState);

export const selectTuTeilnahmen = (): MemoizedSelector<object, ITeilnahmen[]> =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) =>
    teilnahmenState.filter((item) => isTiTuEnumEqual(TiTuEnum.Tu, item.teilnehmer.tiTu)),
  );

export const selectTiTeilnahmen = (): MemoizedSelector<object, ITeilnahmen[]> =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) =>
    teilnahmenState.filter((item) => isTiTuEnumEqual(TiTuEnum.Ti, item.teilnehmer.tiTu)),
  );

export const selectTeilnahmenByAnlassId = (anlassId: string): MemoizedSelector<object, ITeilnahmen[]> =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => {
    return teilnahmenState
      .map((item) => {
        const tals = (item.talDTOList ?? []).filter((link) => link.anlassId === anlassId);
        if (tals.length > 0) {
          const teilnahmenForAnlass: ITeilnahmen = {
            ...item,
            talDTOList: tals,
          };
          return teilnahmenForAnlass;
        }
        return undefined;
      })
      .filter((item): item is ITeilnahmen => item !== undefined);
  });
