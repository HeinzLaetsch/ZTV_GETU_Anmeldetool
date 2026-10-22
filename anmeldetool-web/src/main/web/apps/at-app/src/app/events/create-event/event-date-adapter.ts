import { Injectable } from '@angular/core';
import { NativeDateAdapter } from '@angular/material/core';
import moment from 'moment';

@Injectable()
export class EventDateAdapter extends NativeDateAdapter {
  override parse(value: unknown): Date | null {
    if (typeof value !== 'string') {
      return super.parse(value);
    }
    const text = value.trim();
    if (!text) {
      return null;
    }
    const parsed = moment(text, ['DD.MM.YYYY', 'D.M.YYYY', moment.ISO_8601], true);
    return parsed.isValid() ? parsed.startOf('day').toDate() : this.invalid();
  }
}
