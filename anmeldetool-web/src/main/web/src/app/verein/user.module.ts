import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { SharedComponentsModule } from "../shared/component/shared.components.module";
import { HasChangesComponent } from "./profile/guards/has-changes.component";
import { ProfileComponent } from "./profile/profile.component";
import { RoleChipComponent } from "./profile/role-form/role-chip/role-chip.component";
import { RoleFormComponent } from "./profile/role-form/role-form.component";
import { UserFormComponent } from "./user-form/user-form.component";
import { WertungsrichterFormComponent } from "./profile/wertungsrichter-form/wertungsrichter-form.component";
import { UserRoutes } from "./user.routes";
// import { CoreModule } from "../core/core.module";
import { CommonModule } from "@angular/common";
import { MaterialModule } from "../shared/material-module";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";

@NgModule({
  declarations: [
    ProfileComponent,
    UserFormComponent,
    RoleFormComponent,
    RoleChipComponent,
    WertungsrichterFormComponent,
    HasChangesComponent,
  ],
  imports: [
    CommonModule,
    // CoreModule,
    SharedComponentsModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    RouterModule.forChild(UserRoutes),
  ],
  providers: [],
})
export class UserModule {}
