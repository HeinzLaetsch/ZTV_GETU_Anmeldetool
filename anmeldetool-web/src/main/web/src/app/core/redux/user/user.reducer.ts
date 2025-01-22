import { createFeature, createReducer, on } from "@ngrx/store";
import { UserActions } from "./user.actions";
import { userAdapter, initialState } from "./user.state";

export const userFeature = createFeature({
  name: "user",
  reducer: createReducer(
    initialState,
    on(UserActions.loadAllUserSuccess, (state, action) => {
      const user = action.payload;
      return userAdapter.setAll(user, state);
    }),
    on(UserActions.addDirtyUser, (state, action) => {
      const user = action.payload;
      const newState = userAdapter.addOne(user, state);
      return newState;
    }),
    on(UserActions.updateUserSuccess, (state, action) => {
      const user = action.payload;
      const newState = userAdapter.addOne(user, state);
      return newState;
    }),
    on(UserActions.addUserSuccess, (state, action) => {
      const user = action.payload;
      const newState = userAdapter.addOne(user, state);
      return newState;
    })
  ),
});
// Spread         ...state,

export const { selectAll, selectEntities, selectIds, selectTotal } =
  userAdapter.getSelectors();
