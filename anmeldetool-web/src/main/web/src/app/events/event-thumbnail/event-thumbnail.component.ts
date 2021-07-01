import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { IEvent } from '../shared';

@Component({
  selector: 'app-event-thumbnail',
  templateUrl: './event-thumbnail.component.html',
  styleUrls: ['./event-thumbnail.component.css']
})
export class EventThumbnailComponent implements OnInit {
  @Input() event: IEvent;
  @Output() eventClick = new EventEmitter();

  someProperty: any = 'some Text';

  constructor() { }

  ngOnInit() {
  }

  handleClickMe() {
    this.eventClick.emit(this.event.name);
  }

  getName(): string {
    console.log('From thumbnail :', this.event.name);
    return this.event.name;
  }

  getStartTimeClass() {
    const isGreen =  this.event.start_datum === new Date('14.05.2020');
    return {green: isGreen  , bold: isGreen};
  }
}