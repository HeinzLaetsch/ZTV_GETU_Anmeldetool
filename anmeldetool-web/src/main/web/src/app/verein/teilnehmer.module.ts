import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterModule } from "@angular/router";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MaterialModule } from "../material-module";
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
import {
  teilnehmerFeatureStateName,
  teilnehmerReducers,
} from "../core/redux/teilnehmer";
import { TeilnehmerEffects } from "../core/redux/teilnahme/teilnahme.effects";

@NgModule({
  declarations: [
    TeilnehmerComponent,
    TeilnehmerTableComponent,
    HasChangesComponent,
    DeleteUser,
    TeilnehmerGridComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    SharedComponentsModule,
    AgGridModule,
    RouterModule.forChild(TeilnehmerRoutes),
    StoreModule.forFeature(teilnehmerFeatureStateName, teilnehmerReducers),
    EffectsModule.forFeature([TeilnehmerEffects]),
  ],
  providers: [],
})
export class TeilnehmerModule {}
