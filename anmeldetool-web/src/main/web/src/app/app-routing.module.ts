import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { AuthRouteActivatorService } from "./core/routing/auth-route-activator.service";
import { EventRouteActivatorService } from "./events/index";

const routes: Routes = [
  {
    path: "anlaesse",
    loadChildren: () =>
      import("./events/events.module").then((m) => m.EventsModule),
    // canActivate: [AuthRouteActivatorService],
  },
  {
    path: "anlaesse-admin",
    loadChildren: () =>
      import("./event-admin/events-admin.module").then(
        (m) => m.EventsAdminModule
      ),
    // canActivate: [AuthRouteActivatorService],
  },

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
  {
    path: "",
    redirectTo: "anlaesse",
    pathMatch: "full",
    // canActivate: [AuthRouteActivatorService],
  },
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, {
      enableTracing: false,
      useHash: true,
      relativeLinkResolution: "legacy",
    }),
    // RouterModule.forRoot(routes),
  ],
  exports: [RouterModule],
})
export class AppRoutingModule {}
