import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterModule } from "@angular/router";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "../material-module";
import { SharedComponentsModule } from "../shared/component/shared.components.module";
import { ErfassenComponent } from "./erfassen/erfassen.component";
import { RechnungsbueroRoutes } from "./rechnungsbuero.routes";
import { ErfassenHeaderComponent } from "./erfassen/header/erfassen-header.component";
import { ErfassenRowComponent } from "./erfassen/row/erfassen-row.component";
import { LauflistenStatusComponent } from "./erfassen/laufliste-status/lauflisten-status.component";

@NgModule({
  declarations: [
    ErfassenComponent,
    ErfassenHeaderComponent,
    ErfassenRowComponent,
    LauflistenStatusComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    SharedComponentsModule,
    RouterModule.forChild(RechnungsbueroRoutes),
  ],
  providers: [],
})
export class RechnungsbueroModule {}
