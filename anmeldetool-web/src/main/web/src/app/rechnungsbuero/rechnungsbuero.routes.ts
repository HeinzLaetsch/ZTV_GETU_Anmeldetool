import { RouterModule, Routes } from "@angular/router";
import { AuthRouteActivatorService } from "../core/routing/auth-route-activator.service";
import { RechnungsbueroComponent } from "./rechnungsbuero.component";
import { NgModule } from "@angular/core";

export const rechnungsbueroRoutes: Routes = [
  {
    path: ":id",
    component: RechnungsbueroComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
  {
    path: "",
    component: RechnungsbueroComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
  /*
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
  },*/
  /*
  {
    path: ":id/:function",
    component: ErfassenComponent,
    canActivate: [AuthRouteActivatorService],
    data: { roles: ["RECHNUNGSBUERO"] },
  },
  */
];

@NgModule({
  imports: [RouterModule.forChild(rechnungsbueroRoutes)],
  exports: [RouterModule],
})
export class RechnungsbueroRoutingModule {}
