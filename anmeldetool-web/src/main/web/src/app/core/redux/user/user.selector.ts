import { createFeatureSelector, createSelector } from "@ngrx/store";
import { UserState } from "./user.state";
import { userFeature } from "./user.reducer";
import * as fromUser from "./user.reducer";

export const selectUserState = createFeatureSelector<UserState>(
  userFeature.name
);

export const selectAllUser = createSelector(
  selectUserState,
  fromUser.selectAll
);
export const selectAktiveUser = () =>
  createSelector(selectAllUser, (user) => user.filter((user) => user.aktiv));
export const selectDirtyUser = () =>
  createSelector(selectAllUser, (user) => user.filter((user) => user.dirty));

export const selectUserById = (id: string) =>
  createSelector(selectUserState, (userState) => {
    const ret = userState.ids.length ? userState.entities[id] : undefined;
    return ret;
  });

export const selectUserByBenutzername = (name: string) =>
  createSelector(selectAllUser, (user) =>
    user.filter((user) => user.benutzername === name)
  );

export const selectUserByName = (name: string) =>
  createSelector(selectAllUser, (user) =>
    user.filter((user) => user.name === name)
  );

export const selectUser = () =>
  createSelector(selectAllUser, (user) => {
    return user;
  });
