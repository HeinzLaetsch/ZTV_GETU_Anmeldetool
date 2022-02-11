import { AuthRouteActivatorService } from "../core/routing/auth-route-activator.service";
import { ErfassenComponent } from "./erfassen/erfassen.component";

export const RechnungsbueroRoutes = [
  {
    path: "erfassen",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { function: "erfassen" },
  },
  {
    path: "check",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { function: "check" },
  },
];
