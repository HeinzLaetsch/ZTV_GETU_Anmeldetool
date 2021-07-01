import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { IEvent } from '../shared';
import { EventService } from 'src/app/core/service/event/event.service';

@Component({
  selector: 'app-create-event',
  templateUrl: './create-event.component.html',
  styleUrls: ['./create-event.component.css']
})
export class CreateEventComponent implements OnInit {
  newEvent: IEvent;
  isDirty: boolean = true;

  newEventForm: FormGroup;
  name: FormControl;
  startDate: FormControl;
  endDate: FormControl;

  constructor(private router: Router, private eventService: EventService) { }

  ngOnInit() {
    this.name = new FormControl('', Validators.required);
    this.startDate = new FormControl('', Validators.required);
    this.endDate = new FormControl('', Validators.required);

    this.newEventForm = new FormGroup ( {
      name: this.name,
      start_date: this.startDate,
      end_date: this.endDate

    })
  }

  cancel() {
    console.log('Cancel called');
    this.router.navigate(['/events/']);
  }

  saveEvent(formValues) {
    this.eventService.saveEvent(formValues);
    this.isDirty = false;
    this.router.navigate(['/events/']);
  }

  getCurrentDate(): string {
    return Date();
  }

  validateEventName(): boolean {
    //return this.firstName.valid || this.firstName.untouched;
    return false;
  }

  validateEventDate(): boolean {
    return false;
  }
}
