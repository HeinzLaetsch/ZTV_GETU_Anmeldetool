import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import {
  EventAdminComponent,
  EventListComponent,
  EventRegisterSummaryComponent,
  EventRouteActivatorService,
  EventsDetailComponent,
  EventStartListComponent,
} from "./events/index";

const routes: Routes = [
  //   {path: 'newVerein', component: NewVereinComponent},
  //   {path: 'newAnmelder', component: NewAnmelderComponent},
  {
    path: "anlass",
    component: EventListComponent,
  },
  // {path: 'events', component: EventListComponent, resolve: [{activated: AuthServiceResolverService}, {events: EventListResolverService}]},
  // {path: 'events/new', component: CreateEventComponent, canDeactivate: ['canDeactivateCreateEvent']},
  {
    path: "anlass/:id",
    component: EventsDetailComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["Admin", "Anmelder"] },
  },
  {
    path: "anlass/:id/anmeldung",
    component: EventRegisterSummaryComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["Admin", "Anmelder"] },
  },
  {
    path: "anlass/:id/startliste",
    component: EventStartListComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["Admin", "Anmelder"] },
  },
  {
    path: "anlass/:id/admin",
    component: EventAdminComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["Admininistrator"] },
  },
  // {path: 'page404', component: Page404Component},
  {
    path: "teilnehmer",
    loadChildren: () =>
      import("./verein/teilnehmer.module").then((m) => m.TeilnehmerModule),
    canActivate: [EventRouteActivatorService],
    // resolve: [{ anzahlTeilnehmer: TeilnehmerResolverService }],
  },
  {
    path: "user",
    loadChildren: () =>
      import("./verein/user.module").then((m) => m.UserModule),
  },
  { path: "", redirectTo: "anlass", pathMatch: "full" },
];
// src\app\verein\teilnehmer.module.ts
// loadChildren: "./verein/teilnehmer.module#TeilnehmerModule",

@NgModule({
  imports: [
    RouterModule.forRoot(routes, {
      enableTracing: false,
      useHash: true,
      relativeLinkResolution: "legacy",
    }),
  ],
  exports: [RouterModule],
})
export class AppRoutingModule {}
