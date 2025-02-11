import { createFeatureSelector, createSelector } from "@ngrx/store";
import { AnlassState } from "./anlass.state";
import { anlassFeature } from "./anlass.reducer";
import * as fromAnlass from "./anlass.reducer";
import { TiTuEnum } from "../../model/TiTuEnum";
import * as moment from "moment";
import { IAnlass } from "../../model/IAnlass";
import { AuthService } from "../../service/auth/auth.service";
import { AnzeigeStatusEnum } from "../../model/AnzeigeStatusEnum";

export const selectAnlaesseState = createFeatureSelector<AnlassState>(
  anlassFeature.name
);

export const selectAllAnlaesse = createSelector(
  selectAnlaesseState,
  fromAnlass.selectAll
);

export const selectAnlaesseAdmin = (
  aktiv: boolean,
  admin: boolean,
  anlaesse: IAnlass[]
) => {
  return anlaesse.filter((anlass) => {
    if (admin) {
      if (aktiv) {
        return anlass.aktiv;
      }
      return true;
    } else {
      return (
        anlass.aktiv &&
        anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.PUBLISHED)
      );
    }
  });
};
export const selectAktiveAnlaesse = (admin: boolean) =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    const filtered = selectAnlaesseAdmin(true, admin, anlaesse);
    return filtered;
  });
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
export const selectAnlaesse = (admin: boolean) =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    const filtered = selectAnlaesseAdmin(true, admin, anlaesse);
    return filtered;
  });
export const selectAnlaesseSortedNew = (admin: boolean) =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    const filtered = selectAnlaesseAdmin(true, admin, anlaesse);
    return [...filtered.values()].sort(
      //(a1, a2) => moment(a2.endDatum).valueOf() - moment(a1.endDatum).valueOf()
      (a1, a2) => moment(a1.endDatum).diff(moment(a2.endDatum))
    );
  });
export const selectAllAnlaesseTiTu = (admin: boolean, tiTu: TiTuEnum) =>
  createSelector(selectAllAnlaesse, (anlaesse) => {
    const filtered = selectAnlaesseAdmin(true, admin, anlaesse);
    return filtered.filter((anlass) => {
      if (TiTuEnum.equals(TiTuEnum.Ti, tiTu)) {
        return anlass.tiAnlass;
      } else {
        return anlass.tuAnlass;
      }
    });
  });
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
