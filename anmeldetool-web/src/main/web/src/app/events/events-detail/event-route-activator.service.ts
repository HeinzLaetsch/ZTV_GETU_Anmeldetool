import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Router } from '@angular/router';
import { EventService } from 'src/app/core/service/event/event.service';

@Injectable({
  providedIn: 'root'
})
export class EventRouteActivatorService {

  constructor(private eventService: EventService, private router: Router) { }

  canActivate(route: ActivatedRouteSnapshot) {
    console.log(this.eventService.getEvent(+route.params.id));
    const eventExists = !!this.eventService.getEvent(+route.params.id);
    console.log('canActivate ', eventExists);
    if (!eventExists) {
      this.router.navigate(['/page404']);
    }
    return eventExists;
  }
}
