import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { EventRouteActivatorService } from "../events";
import { EventAdminComponent } from "./index";

export const EventAdminRoutes: Routes = [
  {
    path: "",
    component: EventAdminComponent,
  },
  {
    path: ":id",
    component: EventAdminComponent,
  },
  {
    path: "admin",
    component: EventAdminComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["SEKRETARIAT"] },
  },
  {
    path: ":id/admin",
    component: EventAdminComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["SEKRETARIAT"] },
  },
];

/*

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class EventsAdminRoutingModule {}
*/
