import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "../shared/material-module";
import { EinteilungAbteilungComponent } from "./einteilung/einteilung-abteilung/einteilung-abteilung.component";
import { EinteilungAnlageComponent } from "./einteilung/einteilung-anlage/einteilung-anlage.component";
import { EinteilungKategorieComponent } from "./einteilung/einteilung-kategorie/einteilung-kategorie.component";
import { EinteilungStartgeraetComponent } from "./einteilung/einteilung-startgeraet/einteilung-startgeraet.component";
import { EinteilungComponent } from "./einteilung/einteilung.component";
import { EventAdminComponent } from "./event-admin.component";
import { Upload } from "./upload-dialog/upload.component";
import { ContestUpload } from "./contest-upload-dialog/contest-upload.component";
import { RouterModule } from "@angular/router";
import { EventAdminRoutes } from "./events-admin-routing.module";

@NgModule({
  declarations: [
    Upload,
    ContestUpload,
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
    RouterModule.forChild(EventAdminRoutes),
  ],
})
export class EventsAdminModule {}
