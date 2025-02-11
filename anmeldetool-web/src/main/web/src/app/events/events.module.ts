import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { HoverOverDirective } from "../core/directive/hover.directive";
import { MaterialModule } from "../shared/material-module";
import { CreateEventComponent } from "./create-event";
import { EventsDatesComponent } from "./dates/events-dates.component";
import { EventListComponent } from "./event-list";
import { EventRegisterSummaryComponent } from "./event-register-summary";
import {
  EventStartListComponent,
  EventStartListHeaderComponent,
  EventStartListRowComponent,
} from "./event-start-list";
import { EventThumbnailComponent } from "./event-thumbnail";
import {
  AnlassDetailComponent,
  AnlassStatistikComponent,
  EventsDetailComponent,
  WertungsrichterChipComponent,
  WertungsrichterSelektionComponent,
  WertungsrichterSlotComponent,
} from "./events-detail";
import { EventsRoutingModule } from "./events-routing.module";
import { StoreModule } from "@ngrx/store";
import { anlassSummariesFeature } from "../core/redux/anlass-summary/anlass-summary.reducer";
import { EffectsModule } from "@ngrx/effects";
import { AnlassSummaryEffects } from "../core/redux/anlass-summary";

export function checkDirtyState(component: CreateEventComponent) {
  if (component.isDirty) {
    return window.confirm(
      "Anlass nicht gespeichert, wollen Sie wirklich abbrechen"
    );
  }
  return true;
}

@NgModule({
  declarations: [
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
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    EventsRoutingModule,
    StoreModule.forFeature(anlassSummariesFeature),
    EffectsModule.forFeature([AnlassSummaryEffects]),
  ],
  providers: [],
})
export class EventsModule {}
