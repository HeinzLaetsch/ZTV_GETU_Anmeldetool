import { createEntityAdapter, EntityAdapter, EntityState } from '@ngrx/entity';
import { IAnlass } from '../../model/IAnlass';

export const anlassAdapter: EntityAdapter<IAnlass> = createEntityAdapter<IAnlass>({
  sortComparer: sortByStartDatum,
});

export function sortByStartDatum(a: IAnlass, b: IAnlass): any {
  return a.startDatum.getTime() - b.startDatum.getTime();
}

export type AnlassState = {} & EntityState<IAnlass>

export const initialState: AnlassState = anlassAdapter.getInitialState();
