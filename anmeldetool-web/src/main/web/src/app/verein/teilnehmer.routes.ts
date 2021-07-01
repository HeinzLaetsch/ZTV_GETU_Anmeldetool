import { AuthRouteActivatorService } from '../core/routing/auth-route-activator.service';
import { TeilnehmerComponent } from './teilnehmer/teilnehmer.component';

export const TeilnehmerRoutes = [
    {path: 'teilnehmer', component: TeilnehmerComponent, canActivate: [ AuthRouteActivatorService] },
]
