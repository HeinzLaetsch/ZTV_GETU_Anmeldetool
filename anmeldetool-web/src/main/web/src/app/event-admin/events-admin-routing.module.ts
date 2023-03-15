import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { EventRouteActivatorService } from "../events";
import { EventAdminComponent } from "./index";

const routes: Routes = [
  {
    path: ":id/admin",
    component: EventAdminComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["SEKRETARIAT"] },
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class EventsAdminRoutingModule {}
