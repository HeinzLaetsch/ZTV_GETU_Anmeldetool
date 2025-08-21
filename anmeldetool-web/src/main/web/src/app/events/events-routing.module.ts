import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import {
  EventListComponent,
  EventRegisterSummaryComponent,
  EventRouteActivatorService,
  EventsDetailComponent,
  EventStartListComponent,
} from "./index";

export const routes: Routes = [
  {
    path: "",
    component: EventListComponent,
    // canActivate: [EventRouteActivatorService],
  },
  {
    path: ":id",
    component: EventsDetailComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: [] },
  },
  {
    path: ":id/anmeldung",
    component: EventRegisterSummaryComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: [] },
  },
  {
    path: ":id/startliste",
    component: EventStartListComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: [] },
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class EventsRoutingModule {}
