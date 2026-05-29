import { createEntityAdapter, EntityAdapter, EntityState } from '@ngrx/entity';
import { ITeilnehmer } from '../../model/ITeilnehmer';

export const teilnehmerAdapter: EntityAdapter<ITeilnehmer> = createEntityAdapter<ITeilnehmer>({
  sortComparer: sortByName,
});

export function sortByName(a: ITeilnehmer, b: ITeilnehmer): any {
  if (a.name.localeCompare(b.name) === 0) {return a.vorname.localeCompare(b.vorname);}
  return a.name.localeCompare(b.name);
}

export type TeilnehmerState = {} & EntityState<ITeilnehmer>

export const initialState: TeilnehmerState = teilnehmerAdapter.getInitialState();
