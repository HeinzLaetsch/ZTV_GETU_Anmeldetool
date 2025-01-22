import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IUser } from "../../model/IUser";

export const UserActions = createActionGroup({
  source: "User",
  events: {
    "Load All User INVOKED": emptyProps(),
    "Load All User SUCCESS": props<{ payload: IUser[] }>(),
    "Load All User ERROR": props<{ error: string }>(),

    "Add Dirty User": props<{ payload: IUser }>(),

    "Add User INVOKED": props<{ payload: IUser }>(),
    "Add User SUCCESS": props<{ payload: IUser }>(),
    "Add User ERROR": props<{ error: string }>(),

    "Update User INVOKED": props<{ payload: IUser }>(),
    "Update User SUCCESS": props<{ payload: IUser }>(),
    "Update User ERROR": props<{ error: string }>(),
  },
});
