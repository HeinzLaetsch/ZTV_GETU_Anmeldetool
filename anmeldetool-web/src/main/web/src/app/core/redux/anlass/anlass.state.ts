import { EntityAdapter, EntityState, createEntityAdapter } from "@ngrx/entity";
import { IAnlass } from "../../model/IAnlass";

export const anlassAdapter: EntityAdapter<IAnlass> =
  createEntityAdapter<IAnlass>({
    sortComparer: sortByStartDatum,
  });

export function sortByStartDatum(a: IAnlass, b: IAnlass): any {
  return a.startDatum.getTime() - b.startDatum.getTime();
}

export interface AnlassState extends EntityState<IAnlass> {}

export const initialState: AnlassState = anlassAdapter.getInitialState();
