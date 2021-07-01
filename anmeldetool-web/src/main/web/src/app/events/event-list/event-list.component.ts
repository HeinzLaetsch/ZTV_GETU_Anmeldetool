import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { IEvent } from '../shared';
import { EventService } from 'src/app/core/service/event/event.service';
import { ToastrService } from 'src/app/core/service/toastr/toastr.service';

@Component({
  selector: 'app-event-list',
  templateUrl: './event-list.component.html',
  styleUrls: ['./event-list.component.css']
})
export class EventListComponent implements OnInit {
  events: IEvent[];

  constructor(private eventService: EventService,
    private toastrService: ToastrService,
    private router: ActivatedRoute) { }

  ngOnInit() {
    this.events = this.router.snapshot.data.events;
    //this.events = this.eventService.getEvents().subscribe(events => {this.events = events; });
  }

  handleEventClicked(data) {
    console.log('received :' , data);
  }

  handleThumbnailClick(eventName) {
    this.toastrService.success(eventName);
  }
}
