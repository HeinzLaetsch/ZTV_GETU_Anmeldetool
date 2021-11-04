import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { RouterModule } from "@angular/router";
import { MaterialModule } from "../material-module";
import { SharedComponentsModule } from "../shared/component/shared.components.module";
import { ProfileComponent } from "./profile/profile.component";
import { RoleChipComponent } from "./profile/role-form/role-chip/role-chip.component";
import { RoleFormComponent } from "./profile/role-form/role-form.component";
import { UserFormComponent } from "./profile/user-form/user-form.component";
import { WertungsrichterFormComponent } from "./profile/wertungsrichter-form/wertungsrichter-form.component";
import { UserRoutes } from "./user.routes";

@NgModule({
  declarations: [
    ProfileComponent,
    UserFormComponent,
    RoleFormComponent,
    RoleChipComponent,
    WertungsrichterFormComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    SharedComponentsModule,
    RouterModule.forChild(UserRoutes),
  ],
  providers: [],
})
export class UserModule {}
