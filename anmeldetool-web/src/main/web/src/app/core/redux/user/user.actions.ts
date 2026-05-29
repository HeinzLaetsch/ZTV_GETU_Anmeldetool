import type { Update } from "@ngrx/entity";
import { createActionGroup, emptyProps, props } from "@ngrx/store";
import type { IUser } from "../../model/IUser";

export const UserActions = createActionGroup({
	source: "user",
	events: {
		"Add dirty user": props<{ payload: IUser }>(),
		"Update user": props<{ payload: Update<IUser> }>(),
		"Cancel user": props<{ payload: IUser }>(),

		"Load all user invoked": emptyProps(),
		"Load all user success": props<{ payload: IUser[] }>(),
		"Load all user error": props<{ error: string }>(),

		"Add no user invoked": props<{ payload: IUser }>(),
		"Add no user success": props<{ payload: IUser }>(),
		"Add no user error": props<{ error: string }>(),

		"Save user invoked": props<{ payload: IUser }>(),
		"Save user success": props<{ payload: IUser }>(),
		"Save user error": props<{ error: string }>(),

		"Update user invoked": props<{ payload: IUser }>(),
		"Update user success": props<{ payload: IUser }>(),
		"Update user error": props<{ error: string }>(),
	},
});
