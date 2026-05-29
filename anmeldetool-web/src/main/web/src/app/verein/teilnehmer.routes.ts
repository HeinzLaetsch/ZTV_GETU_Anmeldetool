import { AuthRouteActivatorService } from '../core/routing/auth-route-activator.service';
import { CanDeactivateGuard } from './teilnehmer/guards/can-deactivate.guard';
import { TeilnehmerGridComponent } from './teilnehmer/teilnehmer-grid/teilnehmer-grid';

//     component: TeilnehmerComponent,

export const TeilnehmerRoutes = [
  {
    path: '',
    component: TeilnehmerGridComponent,
    canActivate: [AuthRouteActivatorService],
    // canDeactivate: [CanDeactivateGuard],
    data: { roles: ['ANMELDER'] },
  },
];
