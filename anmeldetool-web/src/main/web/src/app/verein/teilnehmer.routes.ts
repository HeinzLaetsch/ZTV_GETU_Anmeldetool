import { AuthRouteActivatorService } from "../core/routing/auth-route-activator.service";
import { CanDeactivateGuard } from "./teilnehmer/guards/can-deactivate.guard";
import { TeilnehmerComponent } from "./teilnehmer/teilnehmer.component";

export const TeilnehmerRoutes = [
  {
    path: "",
    component: TeilnehmerComponent,
    canActivate: [AuthRouteActivatorService],
    canDeactivate: [CanDeactivateGuard],
  },
];
