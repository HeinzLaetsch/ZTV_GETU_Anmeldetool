import { provideRouter, type Routes, withHashLocation } from '@angular/router';

import { Page404Component } from './error/page404/page404.component';
import { EventRouteActivatorService } from './events/index';
import { SmQualiViewerComponent } from './smquali/smquali-viewer/smquali-viewer.component';
import { TeilnehmerGridComponent } from './verein/teilnehmer/teilnehmer-grid/teilnehmer-grid';

export const AppRouting: Routes = [
  {
    path: 'anlaesse',
    loadChildren: () => import('./events/events.module').then((m) => m.EventsModule),
  },
  {
    path: 'admin',
    loadChildren: () => import('./event-admin/events-admin.module').then((m) => m.EventsAdminModule),
  },
  {
    path: 'verein/teilnehmer',
    canActivate: [EventRouteActivatorService],
    data: { breadcrumb: 'Teilnehmer' },
    component: TeilnehmerGridComponent,
  },
  {
    path: 'rechnungsbuero',
    loadChildren: () => import('./rechnungsbuero/rechnungsbuero.module').then((m) => m.RechnungsbueroModule),
  },
  {
    path: 'user',
    loadChildren: () => import('./verein/user.module').then((m) => m.UserModule),
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

export const routingProviders = provideRouter(AppRouting, withHashLocation());
