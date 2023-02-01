import { createFeatureSelector, createSelector } from "@ngrx/store";
import {
  KategorieEnum,
  KategorieEnumFunction,
} from "../../model/KategorieEnum";
import { TeilnahmeState } from "./teilnahme.state";

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

/*
export const selectAnlassForId = (id: string) =>
  createSelector(selectAnlaesss, (state: AnlassState) =>
    state.items.filter((x) => id === x.id)
  );

export const getTeilnahmenFeatureSelector =
  createFeatureSelector<TeilnahmenState>(featureStateName);

export const getAllEntries = createSelector(
  getTeilnahmenFeatureSelector,
  (state: TeilnahmenState) => state.teilnahmen.items
);

export const getTeilnehmerForAnlassEntries = (anlassId: string) =>
  createSelector(getTeilnahmenFeatureSelector, (state: TeilnahmenState) =>
    state.teilnahmen.items.filter(
      (x) => x.anlassId === anlassId && x.kategorie !== "keine Teilnahme"
    )
  );

export const getBrevet1Entries = (anlassId: string) =>
  createSelector(getTeilnahmenFeatureSelector, (state: TeilnahmenState) =>
    state.teilnahmen.items.filter(
      (x) =>
        x.anlassId === anlassId &&
        KategorieEnumFunction.isBrevet1(
          KategorieEnumFunction.parse(x.kategorie)
        )
    )
  );

export const getBrevet2Entries = (anlassId: string) =>
  createSelector(getTeilnahmenFeatureSelector, (state: TeilnahmenState) =>
    state.teilnahmen.items.filter(
      (x) =>
        x.anlassId === anlassId &&
        KategorieEnumFunction.isBrevet2(
          KategorieEnumFunction.parse(x.kategorie)
        )
    )
  );
1;

*/
