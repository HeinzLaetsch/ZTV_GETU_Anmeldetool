import { Injectable } from "@angular/core";
import { Resolve } from "@angular/router";
import { map } from "rxjs/operators";

@Injectable({
  providedIn: "root",
})
export class EventListResolverService implements Resolve<any> {
  constructor() {}

  resolve() {
    console.log("resolve");
    // return this.eventService.getEvents().pipe(map(events => events));
    return undefined;
  }
}
