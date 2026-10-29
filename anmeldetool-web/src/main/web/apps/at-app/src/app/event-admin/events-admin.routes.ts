import { Routes } from '@angular/router';
import { eventCanActivate } from '../events/events-detail/event-route-activator.service';
import { EventAdminComponent } from './index';

export const EventAdminRoutes: Routes = [
  {
    path: ':id/bearbeiten',
    loadComponent: () => import('./event-form/event-form.component').then((module) => module.EventFormComponent),
    canActivate: [eventCanActivate],
    data: { roles: ['SEKRETARIAT'] },
  },
  {
    path: '',
    component: EventAdminComponent,
  },
  {
    path: ':id',
    component: EventAdminComponent,
  },
  {
    path: 'admin',
    component: EventAdminComponent,
    canActivate: [eventCanActivate],
    data: { roles: ['SEKRETARIAT'] },
  },
  {
    path: ':id/admin',
    component: EventAdminComponent,
    canActivate: [eventCanActivate],
    data: { roles: ['SEKRETARIAT'] },
  },
];

/*

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class EventsAdminRoutingModule {}
*/
