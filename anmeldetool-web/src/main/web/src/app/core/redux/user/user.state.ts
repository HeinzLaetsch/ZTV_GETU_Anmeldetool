import { EntityAdapter, EntityState, createEntityAdapter } from "@ngrx/entity";
import { IUser } from "../../model/IUser";

export const userAdapter: EntityAdapter<IUser> = createEntityAdapter<IUser>({
  sortComparer: sortByName,
});

export function sortByName(a: IUser, b: IUser): any {
  return a.name.localeCompare(b.name);
}

export interface UserState extends EntityState<IUser> {}

export const initialState: UserState = userAdapter.getInitialState();
