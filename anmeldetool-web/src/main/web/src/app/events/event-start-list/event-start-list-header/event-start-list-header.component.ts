import { Component, Input } from "@angular/core";

@Component({
	selector: "lxt-event-start-list-header",
	templateUrl: "./event-start-list-header.component.html",
	styleUrls: ["./event-start-list-header.component.css"],
  standalone: true,
})
export class EventStartListHeaderComponent {
	@Input()
	titel: string;
}
