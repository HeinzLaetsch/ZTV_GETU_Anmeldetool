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
    canActivate: [EventRouteActivatorService],
  },
  // {path: 'events', component: EventListComponent, resolve: [{activated: AuthServiceResolverService}, {events: EventListResolverService}]},
  // {path: 'events/new', component: CreateEventComponent, canDeactivate: ['canDeactivateCreateEvent']},
  {
    path: "anlass/:id",
    component: EventsDetailComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: [] },
  },
  {
    path: "anlass/:id/anmeldung",
    component: EventRegisterSummaryComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: [] },
  },
  {
    path: "anlass/:id/startliste",
    component: EventStartListComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: [] },
  },
  {
    path: "anlass/:id/admin",
    component: EventAdminComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["SEKRETARIAT"] },
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
    path: "rechnungsbuero",
    loadChildren: () =>
      import("./rechnungsbuero/rechnungsbuero.module").then(
        (m) => m.RechnungsbueroModule
      ),
  },
  {
    path: "user",
    loadChildren: () =>
      import("./verein/user.module").then((m) => m.UserModule),
  },
  { path: "", redirectTo: "anlass", pathMatch: "full" },
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, {
      enableTracing: false,
      useHash: true,
      relativeLinkResolution: "legacy",
    }),
    // StoreModule.forFeature(anlassFeatureStateName, anlassReducers),
    // EffectsModule.forFeature([AnlassEffects]),
  ],
  exports: [RouterModule],
})
export class AppRoutingModule {}
