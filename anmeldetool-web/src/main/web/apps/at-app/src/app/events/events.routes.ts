import { type Routes, type UrlTree } from '@angular/router';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../core/service/auth/auth.service';
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
        path: 'neu',
        loadComponent: () =>
          import('./create-event/create-event.component').then((module) => module.CreateEventComponent),
        canActivate: [
          (): boolean | UrlTree => {
            const authService = inject(AuthService);
            return (
              authService.isAdministratorSig() ||
              authService.isSekretariatSig() ||
              inject(Router).createUrlTree(['/page404'])
            );
          },
        ],
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
