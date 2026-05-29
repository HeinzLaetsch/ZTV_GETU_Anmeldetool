import type { Update } from "@ngrx/entity";
import { createActionGroup, emptyProps, props } from "@ngrx/store";
import type { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";

export const OalActions = createActionGroup({
	source: "oal",
	events: {
		"Load All oal invoked": emptyProps(),
		"Load All oal success": props<{ payload: IOrganisationAnlassLink[] }>(),
		"Load All oal error": props<{ error: string }>(),

		"Update oal invoked": props<{ payload: Update<IOrganisationAnlassLink> }>(),
		"Update oal success": props<{ payload: Update<IOrganisationAnlassLink> }>(),
		"Update oal error": props<{ error: string }>(),

		"Update vereins start invoked": props<{
			payload: IOrganisationAnlassLink;
		}>(),
		"Update vereins start success": props<{
			payload: IOrganisationAnlassLink;
		}>(),
		"Update vereins start error": props<{ error: string }>(),
	},
});
