import { NgModule } from "@angular/core";
import { RouterModule, type Routes } from "@angular/router";
import { AuthRouteActivatorService } from "./core/routing/auth-route-activator.service";
import { Page404Component } from "./error/page404/page404.component";
import { EventRouteActivatorService } from "./events/index";
import { SmQualiViewerComponent } from "./smquali/smquali-viewer/smquali-viewer.component";
import { TeilnehmerGridComponent } from "./verein/teilnehmer/teilnehmer-grid/teilnehmer-grid";

const routes: Routes = [
	{
		path: "anlaesse",
		loadChildren: () =>
			import("./events/events.module").then((m) => m.EventsModule),
		// canActivate: [AuthRouteActivatorService],
	},
	{
		path: "admin",
		loadChildren: () =>
			import("./event-admin/events-admin.module").then(
				(m) => m.EventsAdminModule,
			),
		// canActivate: [AuthRouteActivatorService],
	},

	{
		path: "verein/teilnehmer",
		canActivate: [EventRouteActivatorService],
		data: { breadcrumb: "Teilnehmer" },
		component: TeilnehmerGridComponent,
	},
	{
		path: "rechnungsbuero",
		loadChildren: () =>
			import("./rechnungsbuero/rechnungsbuero.module").then(
				(m) => m.RechnungsbueroModule,
			),
	},
	{
		path: "user",
		loadChildren: () =>
			import("./verein/user.module").then((m) => m.UserModule),
	},
	{
		path: "page404",
		component: Page404Component,
	},
	{
		path: "",
		redirectTo: "anlaesse",
		pathMatch: "full",
		// canActivate: [AuthRouteActivatorService],
	},
	{
		path: "smquali",
		component: SmQualiViewerComponent,
	},
	{ path: "", redirectTo: "anlass", pathMatch: "full" },
];

@NgModule({
	imports: [
		RouterModule.forRoot(routes, {
			enableTracing: false,
			useHash: true,
		}),
	],
	exports: [RouterModule],
})
export class AppRoutingModule {}
