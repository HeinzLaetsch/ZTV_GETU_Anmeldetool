export * from "./anlass.state";

export * from "./anlass.actions";

export * from "./anlass.selector";

export * from "./anlass.effects";

/*
export const anlassReducers: ActionReducerMap<AnlassState> = {
  anlaesse: anlassReducer,
};

export const getAnlassFeatureSelector = createFeatureSelector<AnlassState>(
  anlassFeatureStateName
);

export const getAllItems = createSelector(
  getAnlassFeatureSelector,
  (state: AnlassState) => state.anlaesse.items
);

export const getLoadStatus = createSelector(
  getAnlassFeatureSelector,
  (state: AnlassState) => state.anlaesse.loadStatus
);

export const getAnlassForId = (id: string) =>
  createSelector(getAnlassFeatureSelector, (state: AnlassState) =>
    state.anlaesse.items.filter((x) => id === x.id)
  );
*/
