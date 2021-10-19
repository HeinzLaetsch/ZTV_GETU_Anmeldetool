import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { Page404Component } from "./error/page404/page404.component";

import {
  EventListComponent,
  EventsDetailComponent,
  CreateEventComponent,
  EventRouteActivatorService,
  EventListResolverService,
} from "./events/index";
import { AuthServiceResolverService } from "./core/routing/authService-resolver.service";
import { NewAnmelderComponent } from "./verein/new-anmelder/new-anmelder.component";
import { NewVereinComponent } from "./verein/new-verein/new-verein.component";

const routes: Routes = [
  //   {path: 'newVerein', component: NewVereinComponent},
  //   {path: 'newAnmelder', component: NewAnmelderComponent},
  { path: "anlass", component: EventListComponent },
  // {path: 'events', component: EventListComponent, resolve: [{activated: AuthServiceResolverService}, {events: EventListResolverService}]},
  // {path: 'events/new', component: CreateEventComponent, canDeactivate: ['canDeactivateCreateEvent']},
  {
    path: "anlass/:id",
    component: EventsDetailComponent,
    canActivate: [EventRouteActivatorService],
    data: { roles: ["Admin", "Anmelder"] },
  },
  // {path: 'page404', component: Page404Component},
  {
    path: "teilnehmer",
    loadChildren: () =>
      import("./verein/teilnehmer.module").then((m) => m.TeilnehmerModule),
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
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
