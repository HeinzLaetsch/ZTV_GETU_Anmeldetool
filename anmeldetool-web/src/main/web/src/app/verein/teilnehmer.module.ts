import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { EffectsModule } from '@ngrx/effects';
import { StoreModule } from '@ngrx/store';
import { AgGridModule } from 'ag-grid-angular';
import { AnlassSummaryEffects } from '../core/redux/anlass-summary';
import { anlassSummariesFeature } from '../core/redux/anlass-summary/anlass-summary.reducer';
import { OtsEffects } from '../core/redux/organisation-teilnahmen';
import { otsFeature } from '../core/redux/organisation-teilnahmen/ots.reducer';
import { TeilnahmenEffects } from '../core/redux/teilnahmen';
import { teilnahmenFeature } from '../core/redux/teilnahmen/teilnahmen.reducer';
import { SharedComponentsModule } from '../shared/component/shared.components.module';
import { MaterialModule } from '../shared/material-module';
import { TeilnehmerGridComponent } from './teilnehmer/teilnehmer-grid/teilnehmer-grid';
import { TeilnehmerRoutes } from './teilnehmer.routes';

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    // CoreModule,
    SharedComponentsModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    TeilnehmerGridComponent,
    AgGridModule,
    RouterModule.forChild(TeilnehmerRoutes),
    StoreModule.forFeature(anlassSummariesFeature),
    StoreModule.forFeature(teilnahmenFeature),
    StoreModule.forFeature(otsFeature),
    EffectsModule.forFeature([AnlassSummaryEffects, TeilnahmenEffects, OtsEffects]),
  ],
  providers: [],
})
export class TeilnehmerModule {}
