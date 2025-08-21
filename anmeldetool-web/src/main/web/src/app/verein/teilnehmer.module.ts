import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterModule } from "@angular/router";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "../shared/material-module";
import { SharedComponentsModule } from "../shared/component/shared.components.module";
import { TeilnehmerComponent } from "./teilnehmer/teilnehmer.component";
import { TeilnehmerRoutes } from "./teilnehmer.routes";
import { TeilnehmerTableComponent } from "./teilnehmer/teilnehmer-table/teilnehmer-table.component";
import { HasChangesComponent } from "./teilnehmer/guards/has-changes.component";
import { DeleteUser } from "./teilnehmer/teilnehmer-table/delete-dialog/delete-user.component";
import { TeilnehmerGridComponent } from "./teilnehmer/teilnehmer-grid/teilnehmer-grid";
import { AgGridModule } from "ag-grid-angular";
import { StoreModule } from "@ngrx/store";
import { EffectsModule } from "@ngrx/effects";
import { teilnahmenFeature } from "../core/redux/teilnahmen/teilnahmen.reducer";
import { TeilnahmenEffects } from "../core/redux/teilnahmen";
import { OtsEffects } from "../core/redux/organisation-teilnahmen";
import { otsFeature } from "../core/redux/organisation-teilnahmen/ots.reducer";
import { TeilnehmerDialog } from "./teilnehmer/teilnehmer-grid/teilnehmer-dialog/teilnehmer-dialog.component";
import { AnlassSummaryEffects } from "../core/redux/anlass-summary";
import { anlassSummariesFeature } from "../core/redux/anlass-summary/anlass-summary.reducer";

@NgModule({
  declarations: [
    TeilnehmerComponent,
    TeilnehmerTableComponent,
    HasChangesComponent,
    DeleteUser,
    TeilnehmerGridComponent,
    TeilnehmerDialog,
  ],
  imports: [
    CommonModule,
    // CoreModule,
    SharedComponentsModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    AgGridModule,
    RouterModule.forChild(TeilnehmerRoutes),
    StoreModule.forFeature(anlassSummariesFeature),
    StoreModule.forFeature(teilnahmenFeature),
    StoreModule.forFeature(otsFeature),
    EffectsModule.forFeature([
      AnlassSummaryEffects,
      TeilnahmenEffects,
      OtsEffects,
    ]),
  ],
  providers: [],
})
export class TeilnehmerModule {}
