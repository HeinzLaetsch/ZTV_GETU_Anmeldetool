import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { IEvent } from '../shared';
import { EventService } from 'src/app/core/service/event/event.service';

@Component({
  selector: 'app-events-detail',
  templateUrl: './events-detail.component.html',
  styleUrls: ['./events-detail.component.css']
})
export class EventsDetailComponent implements OnInit {

  event: IEvent;

  constructor(private eventService: EventService , private route: ActivatedRoute) { }

  ngOnInit() {
    const eventId: number =  +this.route.snapshot.params.id;
    //const eventId = 3;
    console.log('url param: ', eventId);
    this.event = this.eventService.getEvent(eventId);
  }

}
