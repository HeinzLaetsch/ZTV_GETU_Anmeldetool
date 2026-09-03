import {
  PreloadAllModules,
  provideRouter,
  type Routes,
  withComponentInputBinding,
  withHashLocation,
  withInMemoryScrolling,
  withPreloading,
} from '@angular/router';

import { eventCanActivate } from './events/events-detail/event-route-activator.service';
import { Page404Component } from './error/page404/page404.component';
import { SmQualiViewerComponent } from './smquali/smquali-viewer/smquali-viewer.component';
import { TeilnehmerGridComponent } from './verein/teilnehmer/teilnehmer-grid/teilnehmer-grid';

export const AppRouting: Routes = [
  {
    path: 'anlaesse',
    loadChildren: () => import('./events/events.routes').then((m) => m.eventsRoutes),
  },
  {
    path: 'admin',
    loadChildren: () => import('./event-admin/events-admin.routes').then((m) => m.EventAdminRoutes),
  },
  {
    path: 'verein/teilnehmer',
    canActivate: [eventCanActivate],
    data: { breadcrumb: 'Teilnehmer' },
    component: TeilnehmerGridComponent,
  },
  {
    path: 'rechnungsbuero',
    loadChildren: () => import('./rechnungsbuero/rechnungsbuero.routes').then((m) => m.rechnungsbueroRoutes),
  },
  {
    path: 'user',
    loadChildren: () => import('./verein/user.routes').then((m) => m.UserRoutes),
  },
  {
    path: 'page404',
    component: Page404Component,
  },
  {
    path: '',
    redirectTo: 'anlaesse',
    pathMatch: 'full',
  },
  {
    path: 'smquali',
    component: SmQualiViewerComponent,
  },
  { path: '**', redirectTo: 'page404' },
];

export const routingProviders = provideRouter(
  AppRouting,
  withHashLocation(),
  withPreloading(PreloadAllModules),
  withComponentInputBinding(),
  withInMemoryScrolling({
    scrollPositionRestoration: 'enabled',
    anchorScrolling: 'enabled',
  }),
);
