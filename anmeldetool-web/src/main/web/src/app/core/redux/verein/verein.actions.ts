import { createActionGroup, emptyProps, props } from "@ngrx/store";
import type { IVerein } from "src/app/verein/verein";

export const VereinActions = createActionGroup({
	source: "Verein",
	events: {
		"Load All Vereine invoked": emptyProps(),
		"Load All Vereine success": props<{ payload: IVerein[] }>(),
		"Load All Vereine error": props<{ error: string }>(),
	},
});
