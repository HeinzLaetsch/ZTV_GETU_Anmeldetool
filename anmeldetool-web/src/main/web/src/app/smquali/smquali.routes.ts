import { RouterModule, Routes } from "@angular/router";
import { AuthRouteActivatorService } from "../core/routing/auth-route-activator.service";
import { NgModule } from "@angular/core";

export const smQualiRoutes: Routes = [];

@NgModule({
  imports: [RouterModule.forChild(smQualiRoutes)],
  exports: [RouterModule],
})
export class SMQualiRoutingModule {}
