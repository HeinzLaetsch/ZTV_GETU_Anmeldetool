import { Routes } from '@angular/router';
import { provideEffects } from '@ngrx/effects';
import { provideState } from '@ngrx/store';
import { AnlassSummaryEffects } from '../core/redux/anlass-summary';
import { anlassSummariesFeature } from '../core/redux/anlass-summary/anlass-summary.reducer';
import { TeilnahmenEffects } from '../core/redux/teilnahmen';
import { teilnahmenFeature } from '../core/redux/teilnahmen/teilnahmen.reducer';
import {
  EventListComponent,
  EventRegisterSummaryComponent,
  EventsDetailComponent,
  EventStartListComponent,
} from './index';
import { eventCanActivate } from './events-detail/event-route-activator.service';

export const eventsRoutes: Routes = [
  {
    path: '',
    providers: [
      provideState(anlassSummariesFeature),
      provideState(teilnahmenFeature),
      provideEffects(AnlassSummaryEffects, TeilnahmenEffects),
    ],
    children: [
      {
        path: '',
        component: EventListComponent,
      },
      {
        path: ':id',
        component: EventsDetailComponent,
        canActivate: [eventCanActivate],
        data: { roles: [] },
      },
      {
        path: ':id/anmeldung',
        component: EventRegisterSummaryComponent,
        canActivate: [eventCanActivate],
        data: { roles: [] },
      },
      {
        path: ':id/startliste',
        component: EventStartListComponent,
        canActivate: [eventCanActivate],
        data: { roles: [] },
      },
    ],
  },
];
