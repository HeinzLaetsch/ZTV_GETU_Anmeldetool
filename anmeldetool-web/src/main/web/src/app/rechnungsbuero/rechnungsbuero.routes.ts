import { AuthRouteActivatorService } from "../core/routing/auth-route-activator.service";
import { ErfassenComponent } from "./erfassen/erfassen.component";
import { RechnungsbueroComponent } from "./rechnungsbuero/rechnungsbuero.component";

export const RechnungsbueroRoutes = [
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
  },
  {
    path: ":id/:function",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
];
