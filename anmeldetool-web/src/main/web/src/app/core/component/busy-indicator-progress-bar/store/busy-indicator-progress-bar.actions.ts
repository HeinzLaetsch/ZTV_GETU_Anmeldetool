import { createActionGroup, props } from "@ngrx/store";

export const LoadingActions = createActionGroup({
  source: "Loading",
  events: {
    "Is Loading": props<{
      isLoading: boolean;
      error: boolean;
      message: string;
    }>(),
  },
});
