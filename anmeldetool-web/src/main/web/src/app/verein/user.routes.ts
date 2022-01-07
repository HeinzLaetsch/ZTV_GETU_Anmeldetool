import { AuthRouteActivatorService } from "../core/routing/auth-route-activator.service";
import { CanDeactivateProfileGuard } from "./profile/guards/can-deactivate-profile.guard";
import { ProfileComponent } from "./profile/profile.component";

export const UserRoutes = [
  {
    path: "user",
    component: ProfileComponent,
    canActivate: [AuthRouteActivatorService],
    canDeactivate: [CanDeactivateProfileGuard],
  },
];
