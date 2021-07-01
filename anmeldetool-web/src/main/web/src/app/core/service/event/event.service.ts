import { Injectable } from '@angular/core';
import { Subject, Observable } from 'rxjs';
import { IEvent } from 'src/app/events';

const EVENTS: IEvent[] = [
  {
    id: 1,
    name: 'Zürcher kantonaler Frühlingswettkampf Turner',
    start_datum: new Date('01.04.2020'),
    end_datum: new Date('01.04.2020')
  },
  {
    id: 2,
    name: 'Zürcher kantonaler Geräteturnertag',
    start_datum: new Date('14.05.2020'),
    end_datum: new Date('14.05.2020')
  },
  {
    id: 3,
    name: 'Zürcher kantonale Geräteturnmeisterschaften',
    start_datum: new Date('30.08.2020'),
    end_datum: new Date('31.08.2020')
  },
  {
    id: 4,
    name: 'Zürcher kantonaler Geräteturnfinal',
    start_datum: new Date('14.09.2020'),
    end_datum: new Date('14.09.2020')
  }
];

@Injectable({
  providedIn: 'root'
})
export class EventService {

  constructor() { }

  getEvents(): Observable<IEvent[]>  {
    const subject = new Subject<IEvent[]>();
    setTimeout(() => { subject.next(EVENTS); subject.complete(); }, 100);
    return subject;
  }

  getEvent(id: number): IEvent {
    console.log('get Event called:', id);
    return EVENTS.find(event => event.id === id);
  }

  saveEvent(newEvent : IEvent) {
    newEvent.id = 999;
    EVENTS.push(newEvent);
  }
}



