import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { EffectsModule } from '@ngrx/effects';
import { StoreModule } from '@ngrx/store';
import { HoverOverDirective } from '../core/directive/hover.directive';
import { AnlassSummaryEffects } from '../core/redux/anlass-summary';
import { anlassSummariesFeature } from '../core/redux/anlass-summary/anlass-summary.reducer';
import { TeilnahmenEffects } from '../core/redux/teilnahmen';
import { teilnahmenFeature } from '../core/redux/teilnahmen/teilnahmen.reducer';
import { MaterialModule } from '../shared/material-module';
import { CreateEventComponent } from './create-event';
import { EventsDatesComponent } from './dates/events-dates.component';
import { EventListComponent } from './event-list';
import { EventRegisterSummaryComponent } from './event-register-summary';
import { EventStartListComponent, EventStartListHeaderComponent, EventStartListRowComponent } from './event-start-list';
import { EventThumbnailComponent } from './event-thumbnail';
import {
  AnlassDetailComponent,
  AnlassStatistikComponent,
  EventsDetailComponent,
  WertungsrichterChipComponent,
  WertungsrichterSelektionComponent,
  WertungsrichterSlotComponent,
} from './events-detail';
import { EventsRoutingModule } from './events-routing.module';

export function checkDirtyState(component: CreateEventComponent): boolean {
  if (component.isDirty) {
    return window.confirm('Anlass nicht gespeichert, wollen Sie wirklich abbrechen');
  }
  return true;
}

@NgModule({
  imports: [
    CommonModule,
    EventsRoutingModule,
    EventListComponent,
    WertungsrichterChipComponent,
    WertungsrichterSlotComponent,
    WertungsrichterSelektionComponent,
    EventThumbnailComponent,
    EventsDatesComponent,
    EventsDetailComponent,
    CreateEventComponent,
    EventRegisterSummaryComponent,
    EventStartListComponent,
    EventStartListRowComponent,
    EventStartListHeaderComponent,
    HoverOverDirective,
    AnlassDetailComponent,
    AnlassStatistikComponent,
    StoreModule.forFeature(anlassSummariesFeature),
    StoreModule.forFeature(teilnahmenFeature),
    // StoreModule.forFeature(otsFeature),
    EffectsModule.forFeature([
      AnlassSummaryEffects,
      TeilnahmenEffects,
      // OtsEffects,
    ]),
  ],
  providers: [],
})
export class EventsModule {}
