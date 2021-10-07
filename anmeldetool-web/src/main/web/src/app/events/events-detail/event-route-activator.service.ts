import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Router } from '@angular/router';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';
import { EventService } from 'src/app/core/service/event/event.service';

@Injectable({
  providedIn: 'root'
})
export class EventRouteActivatorService {

  constructor(private anlassService: CachingAnlassService, private router: Router) { }

  canActivate(route: ActivatedRouteSnapshot) {
    console.log(this.anlassService.getAnlassById(route.params.id));
    const eventExists = !!this.anlassService.getAnlassById(route.params.id);
    console.log('canActivate ', eventExists);
    if (!eventExists) {
      this.router.navigate(['/page404']);
    }
    return eventExists;
  }
}
