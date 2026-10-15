import { Component, type OnInit } from '@angular/core';
import { UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import type { IEvent } from '../shared';

@Component({
  selector: 'ztv-create-event',
  templateUrl: './create-event.component.html',
  styleUrls: ['./create-event.component.scss'],
  standalone: true,
})
export class CreateEventComponent implements OnInit {
  newEvent: IEvent;
  isDirty = true;

  newEventForm: UntypedFormGroup;
  name: UntypedFormControl;
  startDate: UntypedFormControl;
  endDate: UntypedFormControl;

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.name = new UntypedFormControl('', Validators.required);
    this.startDate = new UntypedFormControl('', Validators.required);
    this.endDate = new UntypedFormControl('', Validators.required);

    this.newEventForm = new UntypedFormGroup({
      name: this.name,
      start_date: this.startDate,
      end_date: this.endDate,
    });
  }

  cancel(): void {
    console.log('Cancel called');
    this.router.navigate(['/events/']);
  }

  saveEvent(_formValues: unknown): void {
    // this.eventService.saveEvent(formValues);
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
