import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { UserRoutes } from './user.routes';
import { ProfileComponent } from './profile/profile.component';
import { MaterialModule } from '../material-module';
import { SharedComponentsModule } from '../shared/component/shared.components.module';
import { UserFormComponent } from './profile/user-form/user-form.component';
import { RoleFormComponent } from './profile/role-form/role-form.component';
import { WertungsrichterFormComponent } from './profile/wertungsrichter-form/wertungsrichter-form.component';


@NgModule({
  declarations: [
    ProfileComponent,
    UserFormComponent,
    RoleFormComponent,
    WertungsrichterFormComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    SharedComponentsModule,
    RouterModule.forChild(UserRoutes)
  ],
  providers: []
})
export class UserModule { }
