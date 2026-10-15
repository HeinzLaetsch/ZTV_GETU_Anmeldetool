import { createFeatureSelector, createSelector, type MemoizedSelector } from '@ngrx/store';
import type { IUser } from '../../model/IUser';
import { UserState } from './user.state';
import { userFeature } from './user.reducer';
import * as fromUser from './user.reducer';

export const selectUserState = createFeatureSelector<UserState>(userFeature.name);

export const selectAllUser = createSelector(selectUserState, fromUser.selectAll);
export const selectAktiveUser = (): MemoizedSelector<object, IUser[]> =>
  createSelector(selectAllUser, (users) => users.filter((userEntry) => userEntry.aktiv));
export const selectDirtyUser = (): MemoizedSelector<object, IUser[]> =>
  createSelector(selectAllUser, (users) => users.filter((userEntry) => userEntry.dirty));

export const selectUserById = (id: string): MemoizedSelector<object, IUser | undefined> =>
  createSelector(selectUserState, (userState) => {
    return userState.ids.length ? userState.entities[id] : undefined;
  });

export const selectUserByBenutzername = (name: string): MemoizedSelector<object, IUser[]> =>
  createSelector(selectAllUser, (users) => users.filter((userEntry) => userEntry.benutzername === name));

export const selectUserByName = (name: string): MemoizedSelector<object, IUser[]> =>
  createSelector(selectAllUser, (users) => users.filter((userEntry) => userEntry.name === name));

export const selectAktivUser = (): MemoizedSelector<object, IUser[]> =>
  createSelector(selectAllUser, (users: IUser[]) => users);

export const selectUser = (): MemoizedSelector<object, IUser[]> =>
  createSelector(selectAllUser, (users) => users.filter((userEntry) => userEntry.pal === undefined));
