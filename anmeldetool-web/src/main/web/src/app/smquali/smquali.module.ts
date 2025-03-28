import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "../shared/material-module";
import { SharedComponentsModule } from "../shared/component/shared.components.module";
import { SMQualiRoutingModule } from "./smquali.routes";
import { SmQualiViewerComponent } from "./smquali-viewer/smquali-viewer.component";

@NgModule({
  declarations: [SmQualiViewerComponent],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    SharedComponentsModule,
    SMQualiRoutingModule,
  ],
  providers: [],
})
export class SMQualiModule {}
