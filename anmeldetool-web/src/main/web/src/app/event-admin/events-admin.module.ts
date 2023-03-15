import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "src/app/shared/material-module";
import { EinteilungAbteilungComponent } from "./einteilung/einteilung-abteilung/einteilung-abteilung.component";
import { EinteilungAnlageComponent } from "./einteilung/einteilung-anlage/einteilung-anlage.component";
import { EinteilungKategorieComponent } from "./einteilung/einteilung-kategorie/einteilung-kategorie.component";
import { EinteilungStartgeraetComponent } from "./einteilung/einteilung-startgeraet/einteilung-startgeraet.component";
import { EinteilungComponent } from "./einteilung/einteilung.component";
import { EventAdminComponent } from "./event-admin.component";
import { EventsAdminRoutingModule } from "./events-admin-routing.module";
import { Upload } from "./upload-dialog/upload.component";

@NgModule({
  declarations: [
    Upload,
    EventAdminComponent,
    EinteilungComponent,
    EinteilungStartgeraetComponent,
    EinteilungKategorieComponent,
    EinteilungAnlageComponent,
    EinteilungAbteilungComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    EventsAdminRoutingModule,
  ],
})
export class EventsAdminModule {}
