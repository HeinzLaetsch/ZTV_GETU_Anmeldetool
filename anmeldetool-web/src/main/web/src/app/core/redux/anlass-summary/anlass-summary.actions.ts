import type { Update } from "@ngrx/entity";
import { createActionGroup, emptyProps, props } from "@ngrx/store";
import type { IVerein } from "src/app/verein/verein";
import type { IAnlass } from "../../model/IAnlass";
import type { IAnlassSummary } from "../../model/IAnlassSummary";

export const AnlassSummariesActions = createActionGroup({
	source: "anlasssummaries",
	events: {
		"Load all anlasssummaries invoked": emptyProps(),
		"Load all anlasssummaries success": props<{ payload: IAnlassSummary[] }>(),
		"Load all anlasssummaries error": props<{ error: string }>(),

		"Update anlasssummary invoked": props<{
			payload: Update<IAnlassSummary>;
		}>(),
		"Update anlasssummary success": props<{
			payload: Update<IAnlassSummary>;
		}>(),
		"Update anlasssummary error": props<{ error: string }>(),

		"Refresh anlasssummary invoked": props<{
			payload: { anlass: IAnlass; verein: IVerein };
		}>(),
		"Refresh anlasssummary success": props<{ payload: IAnlassSummary }>(),
		"Refresh anlasssummary error": props<{ error: string }>(),
	},
});
