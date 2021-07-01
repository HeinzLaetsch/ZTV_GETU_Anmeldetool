import { AuthRouteActivatorService } from '../core/routing/auth-route-activator.service';
import { ProfileComponent } from './profile/profile.component';

export const UserRoutes = [
    {path: 'user', component: ProfileComponent, canActivate: [ AuthRouteActivatorService] }
]
