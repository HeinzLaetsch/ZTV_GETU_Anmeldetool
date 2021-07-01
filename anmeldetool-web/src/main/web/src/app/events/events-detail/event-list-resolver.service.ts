import { Injectable } from '@angular/core';
import { Resolve } from '@angular/router';
import { map } from 'rxjs/operators';
import { EventService } from 'src/app/core/service/event/event.service';

@Injectable({
  providedIn: 'root'
})
export class EventListResolverService implements Resolve<any>{

  constructor(private eventService: EventService) { }

  resolve() {
    console.log('resolve');
    return this.eventService.getEvents().pipe(map(events => events));
  }
}
