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
import { AnlassStatusComponent } from "./erfassen/anlass-status/anlass-status.component";
import { KategorieStatusComponent } from "./erfassen/anlass-status/kategorie-status/kategorie-status.component";
import { AbteilungStatusComponent } from "./erfassen/anlass-status/abteilung-status/abteilung-status.component";
import { AnlageStatusComponent } from "./erfassen/anlass-status/anlage-status/anlage-status.component";
import { LauflisteStatusComponent } from "./erfassen/anlass-status/laufliste-status/laufliste-status.component";
import { NotenBlattZurueckZiehen } from "./erfassen/row/delete-dialog/delete-notenblatt.component";
import { RechnungsbueroComponent } from "./rechnungsbuero/rechnungsbuero.component";

@NgModule({
  declarations: [
    ErfassenComponent,
    ErfassenHeaderComponent,
    ErfassenRowComponent,
    AnlassStatusComponent,
    KategorieStatusComponent,
    AbteilungStatusComponent,
    AnlageStatusComponent,
    LauflisteStatusComponent,
    NotenBlattZurueckZiehen,
    RechnungsbueroComponent,
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
