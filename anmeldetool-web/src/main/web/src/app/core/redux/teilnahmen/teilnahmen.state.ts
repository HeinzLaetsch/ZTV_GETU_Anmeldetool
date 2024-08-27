import { EntityAdapter, EntityState, createEntityAdapter } from "@ngrx/entity";
import { ITeilnahmen } from "../../model/ITeilnahmen";

export const teilnahmenAdapter: EntityAdapter<ITeilnahmen> =
  createEntityAdapter<ITeilnahmen>({
    selectId: selectTeilnahmenId,
    sortComparer: sortByTeilnehmer,
  });

export function sortByTeilnehmer(a: ITeilnahmen, b: ITeilnahmen): any {
  return a.teilnehmer.name.localeCompare(b.teilnehmer.name);
}

export interface TeilnahmenState extends EntityState<ITeilnahmen> {}

export const initialState: TeilnahmenState =
  teilnahmenAdapter.getInitialState();

export function selectTeilnahmenId(a: ITeilnahmen): string {
  //In this case this would be optional since primary key is id
  return a.teilnehmer.id;
}
