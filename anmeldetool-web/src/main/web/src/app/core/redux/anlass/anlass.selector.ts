import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassState } from "./anlass.state";
import { anlassFeature } from "./anlass.reducer";
import * as fromAnlass from "./anlass.reducer";
import { TiTuEnum } from "../../model/TiTuEnum";
import * as moment from "moment";
import { IAnlass } from "../../model/IAnlass";

export const selectAnlaesseState = createFeatureSelector<AnlassState>(
  anlassFeature.name
);

export const selectAllAnlaesse = createSelector(
  selectAnlaesseState,
  fromAnlass.selectAll
);
export const selectAktiveAnlaesse = () =>
  createSelector(selectAllAnlaesse, (anlaesse) =>
    anlaesse.filter((anlass) => anlass.aktiv)
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
    anlaesse.filter((anlass) => anlass.anlassBezeichnung === anlassBezeichnung)
  );
export const selectAnlaesse = () =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    return anlaesse;
  });
export const selectAnlaesseSortedNew = () =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    return [...anlaesse.values()].sort(
      (a1, a2) => moment(a2.endDatum).valueOf() - moment(a1.endDatum).valueOf()
    );
  });
export const selectAllAnlaesseTiTu = (tiTu: TiTuEnum) =>
  createSelector(selectAllAnlaesse, (anlaesse) =>
    anlaesse.filter((anlass) => {
      if (TiTuEnum.equals(TiTuEnum.Ti, tiTu)) {
        return anlass.tiAnlass;
      } else {
        return anlass.tuAnlass;
      }
    })
  );
export const selectJahre = () =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    const hashMap = new Map<number, IAnlass>();
    anlaesse.forEach((anlass) => {
      hashMap.set(moment(anlass.endDatum).year(), anlass);
    });

    return [...hashMap.values()].sort(
      (a1, a2) => moment(a1.endDatum).valueOf() - moment(a2.endDatum).valueOf()
    );
  });
