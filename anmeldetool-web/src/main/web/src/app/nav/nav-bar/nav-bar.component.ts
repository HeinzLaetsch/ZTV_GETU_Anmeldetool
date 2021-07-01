import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { EventService } from 'src/app/core/service/event/event.service';
import { Observable } from 'rxjs';
import { IEvent } from 'src/app/events';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrls: ['./nav-bar.component.css']
})
export class NavBarComponent implements OnInit {

  public _events: Observable<IEvent[]>;

  constructor(public authService: AuthService, public eventService: EventService) { }

  ngOnInit() {
    this.getEventsAsync();
    //this.getEventsSub();
  }
  getEventsAsync() {
    this._events = this.eventService.getEvents();
  }
  get events() {
    return this._events;
  }
}
