import { createFeature, createReducer, on } from "@ngrx/store";
import { UserActions } from "./user.actions";
import { userAdapter, initialState } from "./user.state";
import { Update } from "@ngrx/entity";
import { IUser } from "../../model/IUser";

export const userFeature = createFeature({
  name: "user",
  reducer: createReducer(
    initialState,

    on(UserActions.addDirtyUser, (state, action) => {
      const user = action.payload;
      const newState = userAdapter.addOne(user, state);
      return newState;
    }),
    on(UserActions.updateUser, (state, action) => {
      const user = action.payload;
      const newState = userAdapter.updateOne(user, state);
      return newState;
    }),
    on(UserActions.loadAllUserSuccess, (state, action) => {
      const user = action.payload;
      return userAdapter.setAll(user, state);
    }),
    on(UserActions.cancelUser, (state, action) => {
      const user = action.payload;
      const newState = userAdapter.removeOne(user.id, state);
      return newState;
    }),
    on(UserActions.saveUserSuccess, (state, action) => {
      const user: Update<IUser> = {
        id: action.payload.id,
        changes: {
          dirty: false,
          password: null,
          benutzername: action.payload.benutzername,
          name: action.payload.name,
          vorname: action.payload.vorname,
          handy: action.payload.handy,
          email: action.payload.email,
        },
      };
      // const user = action.payload;
      const newState = userAdapter.updateOne(user, state);
      return newState;
    })
  ),
});
// Spread         ...state,

export const { selectAll, selectEntities, selectIds, selectTotal } =
  userAdapter.getSelectors();
