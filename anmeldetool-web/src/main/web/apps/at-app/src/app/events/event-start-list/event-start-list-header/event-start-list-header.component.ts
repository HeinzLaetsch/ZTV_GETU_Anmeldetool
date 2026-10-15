import { Component, input } from '@angular/core';

@Component({
  selector: 'ztv-event-start-list-header',
  templateUrl: './event-start-list-header.component.html',
  styleUrls: ['./event-start-list-header.component.scss'],
  standalone: true,
})
export class EventStartListHeaderComponent {
  readonly titel = input.required<string>();
}
