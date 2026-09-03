import { createActionGroup, emptyProps, props } from '@ngrx/store';
import type { IOrganisationTeilnahmenStatistik } from '../../model/IOrganisationTeilnahmenStatistik';

export const OtsActions = createActionGroup({
  source: 'ots',
  events: {
    'Load All ots invoked': props<{ payload: number }>(),
    'Load All ots success': props<{
      payload: IOrganisationTeilnahmenStatistik[];
    }>(),
    'Load All ots error': props<{ error: string }>(),
  },
});
/*

    "Update Vereins Start INVOKED": props<{
      payload: IOrganisationTeilnahmenStatistik;
    }>(),
    "Update Vereins Start  SUCCESS": props<{
      payload: IOrganisationTeilnahmenStatistik;
    }>(),
    "Update Vereins Start  ERROR": props<{ error: string }>(),
    */
