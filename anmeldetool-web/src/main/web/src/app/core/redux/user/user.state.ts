import { createEntityAdapter, EntityAdapter, EntityState } from '@ngrx/entity';
import { IUser } from '../../model/IUser';

export const userAdapter: EntityAdapter<IUser> = createEntityAdapter<IUser>({
  sortComparer: sortByName,
});

export function sortByName(a: IUser, b: IUser): any {
  return a.benutzername.localeCompare(b.benutzername);
}

export type UserState = {} & EntityState<IUser>

export const initialState: UserState = userAdapter.getInitialState();
