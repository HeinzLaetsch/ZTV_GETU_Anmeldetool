import { Routes } from '@angular/router';
import { authCanActivate } from '../core/routing/auth-route-activator.service';
import { RechnungsbueroComponent } from './rechnungsbuero.component';

export const rechnungsbueroRoutes: Routes = [
  {
    path: ':id',
    component: RechnungsbueroComponent,
    canActivate: [authCanActivate],
    data: { roles: ['RECHNUNGSBUERO'] },
  },
  {
    path: '',
    component: RechnungsbueroComponent,
    canActivate: [authCanActivate],
    data: { roles: ['RECHNUNGSBUERO'] },
  },
  /*
  {
    path: ":id/ranglisten",
    component: RechnungsbueroComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
  {
    path: ":id/:function",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },*/
  /*
  {
    path: ":id/:function",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
  */
];
