import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "src/app/material-module";
import { UserExists } from "./user/user-exists/user-exists.component";
import { UserComponent } from "./user/user.component";

export const COMPONENTS = [UserComponent, UserExists];

@NgModule({
  declarations: [COMPONENTS],
  imports: [CommonModule, FormsModule, ReactiveFormsModule, MaterialModule],
  exports: [COMPONENTS],
})
export class SharedComponentsModule {}
