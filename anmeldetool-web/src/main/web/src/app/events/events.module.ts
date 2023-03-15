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
  EventsDetailComponent,
  WertungsrichterChipComponent,
  WertungsrichterSlotComponent,
} from "./events-detail";
import { EventsRoutingModule } from "./events-routing.module";

@NgModule({
  declarations: [
    EventListComponent,
    WertungsrichterChipComponent,
    WertungsrichterSlotComponent,
    EventThumbnailComponent,
    EventsDatesComponent,
    EventsDetailComponent,
    CreateEventComponent,
    EventRegisterSummaryComponent,
    EventStartListComponent,
    EventStartListRowComponent,
    EventStartListHeaderComponent,
    HoverOverDirective,
  ],
  imports: [
    CommonModule,
    EventsRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
  ],
  providers: [],
})
export class EventsModule {}
