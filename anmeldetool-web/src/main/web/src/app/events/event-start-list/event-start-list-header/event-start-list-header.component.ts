import { Component, Input } from "@angular/core";

@Component({
  selector: "app-event-start-list-header",
  templateUrl: "./event-start-list-header.component.html",
  styleUrls: ["./event-start-list-header.component.css"],
})
export class EventStartListHeaderComponent {
  @Input()
  titel: string;
}
