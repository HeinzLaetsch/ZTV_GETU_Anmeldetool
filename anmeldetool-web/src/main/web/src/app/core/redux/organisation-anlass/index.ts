export * from "./oal.state";

export * from "./oal.actions";

export * from "./oal.selectors";

export * from "./oal.effects";

/*
export const organisationAnlassFeatureStateName = "organisationAnlassFeature";

export interface OrganisationAnlassState {
  organisationAnlass: ReducerOrganisationAnlassState;
}

export const organisationAnlassReducers: ActionReducerMap<OrganisationAnlassState> =
  {
    organisationAnlass: organisationAnlassReducer,
  };

export const getOrganisationAnlassFeatureSelector =
  createFeatureSelector<OrganisationAnlassState>(
    organisationAnlassFeatureStateName
  );

export const getAllItems = createSelector(
  getOrganisationAnlassFeatureSelector,
  (state: OrganisationAnlassState) => state.organisationAnlass.items
);

export const getLoadStatus = createSelector(
  getOrganisationAnlassFeatureSelector,
  (state: OrganisationAnlassState) => state.organisationAnlass.loadStatus
);

export const getOrganisationAnlassForKeys = (orgId: string, anlassId: string) =>
  createSelector(
    getOrganisationAnlassFeatureSelector,
    (state: OrganisationAnlassState) =>
      state.organisationAnlass.items.filter(
        (x) => orgId === x.organisationsId && anlassId === x.anlassId
      )
  );
*/
