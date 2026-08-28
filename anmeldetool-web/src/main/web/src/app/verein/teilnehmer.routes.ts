import { authCanActivate } from '../core/routing/auth-route-activator.service';
import { TeilnehmerGridComponent } from './teilnehmer/teilnehmer-grid/teilnehmer-grid';

//     component: TeilnehmerComponent,

export const TeilnehmerRoutes = [
  {
    path: '',
    component: TeilnehmerGridComponent,
    canActivate: [authCanActivate],
    // canDeactivate: [CanDeactivateGuard],
    data: { roles: ['ANMELDER'] },
  },
];
