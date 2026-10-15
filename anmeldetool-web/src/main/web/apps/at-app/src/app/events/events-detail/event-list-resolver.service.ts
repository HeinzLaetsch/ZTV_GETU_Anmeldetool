import { Injectable } from '@angular/core';
import { Resolve } from '@angular/router';

@Injectable({
  providedIn: 'root',
})
export class EventListResolverService implements Resolve<undefined> {
  resolve(): undefined {
    console.log('resolve');
    // return this.eventService.getEvents().pipe(map(events => events));
    return undefined;
  }
}
