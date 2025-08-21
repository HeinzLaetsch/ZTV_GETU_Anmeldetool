import { createActionGroup, emptyProps, props } from "@ngrx/store";
import { IUser } from "../../model/IUser";
import { Update } from "@ngrx/entity";

export const UserActions = createActionGroup({
  source: "User",
  events: {
    "Add Dirty User": props<{ payload: IUser }>(),
    "Update User": props<{ payload: Update<IUser> }>(),
    "Cancel User": props<{ payload: IUser }>(),

    "Load All User INVOKED": emptyProps(),
    "Load All User SUCCESS": props<{ payload: IUser[] }>(),
    "Load All User ERROR": props<{ error: string }>(),

    "Add No User INVOKED": props<{ payload: IUser }>(),
    "Add No User SUCCESS": props<{ payload: IUser }>(),
    "Add No User ERROR": props<{ error: string }>(),

    "Save User INVOKED": props<{ payload: IUser }>(),
    "Save User SUCCESS": props<{ payload: IUser }>(),
    "Save User ERROR": props<{ error: string }>(),
  },
});
