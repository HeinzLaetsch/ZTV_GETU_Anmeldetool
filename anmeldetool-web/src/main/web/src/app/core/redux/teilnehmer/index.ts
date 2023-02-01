import {
  ActionReducerMap,
  createFeatureSelector,
  createSelector,
} from "@ngrx/store";
import { TiTuEnum } from "../../model/TiTuEnum";
import {
  ReducerTeilnehmerState,
  teilnehmerReducer,
} from "./teilnehmer.reducer";

export const teilnehmerFeatureStateName = "teilnehmerFeature";

export interface TeilnehmerState {
  teilnehmer: ReducerTeilnehmerState;
}

export const teilnehmerReducers: ActionReducerMap<TeilnehmerState> = {
  teilnehmer: teilnehmerReducer,
};

export const getTeilnehmerFeatureSelector =
  createFeatureSelector<TeilnehmerState>(teilnehmerFeatureStateName);

export const getAllTiEntries = createSelector(
  getTeilnehmerFeatureSelector,
  (state: TeilnehmerState) =>
    state.teilnehmer.items.filter((x) => TiTuEnum.equals(TiTuEnum.Ti, x.tiTu))
);

export const getAllTuEntries = createSelector(
  getTeilnehmerFeatureSelector,
  (state: TeilnehmerState) =>
    state.teilnehmer.items.filter((x) => TiTuEnum.equals(TiTuEnum.Tu, x.tiTu))
);

export const getAllEntries = createSelector(
  getTeilnehmerFeatureSelector,
  (state: TeilnehmerState) => state.teilnehmer.items
);
