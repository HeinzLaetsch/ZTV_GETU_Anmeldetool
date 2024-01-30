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

/*
export const selectTeilnahmenByAnlass = (anlassId: string) =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => {
    const ret = teilnahmenState.filter((x) => x.anlass.id === anlassId);

    return ret;
  });
*/
/*
export const selectTeilnahmenByAnlassAndTeilnehmer = (
  anlassId: string,
  teilehmerId: string
) =>
  createSelector(selectAllTeilnahmen, (teilnahmenState) => {
    const anlassTeilnahmen = selectTeilnahmenByAnlass(anlassId);
    const filtered = anlassTeilnahmen[0].anlassLinks.filter(
      (x) => x.teilnehmerId === teilehmerId
    );
    const ret: IAnlassLinks = {
      dirty: false,
      anlass: null,
      anlassLinks: filtered,
    };
    return ret;
  });
*/

// Old
/*
export const teilnahmeFeatureStateName = "teilnahmeFeature";

export const selectTeilnahme = createFeatureSelector<TeilnahmeState>(
  teilnahmeFeatureStateName
);

export const selectAllItems = createSelector(
  selectTeilnahme,
  (state: TeilnahmeState) => state.items
);

export const selectLoadStatus = createSelector(
  selectTeilnahme,
  (state: TeilnahmeState) => state.loadStatus
);

export const selectTeilnehmerForAnlassEntries = (anlassId: string) =>
  createSelector(selectTeilnahme, (state: TeilnahmeState) =>
    state.items.filter(
      (x) => x.anlassId === anlassId && x.kategorie !== "keine Teilnahme"
    )
  );
export const getTeilnahmenForKategorie = (
  anlassId: string,
  kategorie: KategorieEnum
) =>
  createSelector(selectTeilnahme, (state: TeilnahmeState) =>
    state.items.filter(
      (x) =>
        x.anlassId === anlassId &&
        KategorieEnumFunction.equals(
          KategorieEnumFunction.parse(kategorie),
          KategorieEnumFunction.parse(x.kategorie)
        )
    )
  );

export const getBrevet1Entries = (anlassId: string) =>
  createSelector(selectTeilnahme, (state: TeilnahmeState) =>
    state.items.filter(
      (x) =>
        x.anlassId === anlassId &&
        KategorieEnumFunction.isBrevet1(
          KategorieEnumFunction.parse(x.kategorie)
        )
    )
  );

export const getBrevet2Entries = (anlassId: string) =>
  createSelector(selectTeilnahme, (state: TeilnahmeState) =>
    state.items.filter(
      (x) =>
        x.anlassId === anlassId &&
        KategorieEnumFunction.isBrevet2(
          KategorieEnumFunction.parse(x.kategorie)
        )
    )
  );
*/
