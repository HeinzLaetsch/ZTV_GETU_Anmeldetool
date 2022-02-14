import { AuthRouteActivatorService } from "../core/routing/auth-route-activator.service";
import { ErfassenComponent } from "./erfassen/erfassen.component";

export const RechnungsbueroRoutes = [
  {
    path: ":id/:function",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
  {
    path: ":id/:function",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
];
