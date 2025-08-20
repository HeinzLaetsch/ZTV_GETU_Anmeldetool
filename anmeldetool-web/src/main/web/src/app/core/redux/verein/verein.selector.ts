import { createFeatureSelector, createSelector } from "@ngrx/store";

import * as fromVerein from "./verein.reducer";
import { VereinState } from "./verein.state";

export const selectVereinState = createFeatureSelector<VereinState>(
  fromVerein.vereinFeature.name
);

export const selectAlleVereine = createSelector(
  selectVereinState,
  fromVerein.selectAll
);

export const selectVereineSorted = () =>
  createSelector(selectAlleVereine, (vereine) => {
    return [...vereine.values()].sort((v1, v2) =>
      sortVereinsname(v1.name, v2.name)
    );
  });

export const selectVereinById = (id: string) =>
  createSelector(selectVereinState, (vereinState) => {
    const ret = vereinState.ids.length ? vereinState.entities[id] : undefined;
    return ret;
  });

export const selectVereinByName = (name: string) =>
  createSelector(selectAlleVereine, (vereine) =>
    vereine.filter((verein) => verein.name === name)
  );


const strip = (org: string, pattern: string) => {
  const hasGetuA = org.indexOf(pattern);
  if (hasGetuA >= 0) {
    return org.substring(hasGetuA + pattern.length);
  }
  return org;
};

const sortVereinsname = (aName: String, bName: String) => {
  let strippedA = aName.toUpperCase();
  let strippedB = bName.toUpperCase();
  if (strippedA === "ZTV") {
    return 1;
  }
  if (strippedB === "ZTV") {
    return -1;
  }
  strippedA = strip(strippedA, "GR ");
  strippedB = strip(strippedB, "GR ");
  strippedA = strip(strippedA, "GETU ");
  strippedB = strip(strippedB, "GETU ");
  strippedA = strip(strippedA, "DTV ");
  strippedB = strip(strippedB, "DTV ");
  strippedA = strip(strippedA, "STU ");
  strippedB = strip(strippedB, "STU ");
  strippedA = strip(strippedA, "TG ");
  strippedB = strip(strippedB, "TG ");
  strippedA = strip(strippedA, "TV ");
  strippedB = strip(strippedB, "TV ");
  strippedA = strip(strippedA, "TSV ");
  strippedB = strip(strippedB, "TSV ");
  strippedA = strip(strippedA, "GERÄTERIEGE JUGI ");
  strippedB = strip(strippedB, "GERÄTERIEGE JUGI ");
  strippedA = strip(strippedA, "GERÄTERIEGE ");
  strippedB = strip(strippedB, "GERÄTERIEGE ");
  strippedA = strip(strippedA, "TURNVEREIN ");
  strippedB = strip(strippedB, "TURNVEREIN ");
  strippedA = strip(strippedA, "TURNSPORT ");
  strippedB = strip(strippedB, "TURNSPORT ");
  strippedA = strip(strippedA, "GERÄTETURNEN ");
  strippedB = strip(strippedB, "GERÄTETURNEN ");
  strippedA = strip(strippedA, "SATUS ");
  strippedB = strip(strippedB, "SATUS ");
  strippedA = strip(strippedA, "NEUE SEKTION ");
  strippedB = strip(strippedB, "NEUE SEKTION ");

  if (strippedA < strippedB) {
    return -1;
  }
  if (strippedA > strippedB) {
    return 1;
  }
  return 0;
};
