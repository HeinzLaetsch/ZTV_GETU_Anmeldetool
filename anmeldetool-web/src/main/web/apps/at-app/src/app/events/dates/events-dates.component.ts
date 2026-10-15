import { DatePipe } from '@angular/common';
import { ChangeDetectionStrategy, Component, computed, effect, input, output } from '@angular/core';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import type { MatDatepickerInputEvent } from '@angular/material/datepicker';
import moment from 'moment';
import { AnzeigeStatusEnum } from 'src/app/core/model/AnzeigeStatusEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'ztv-events-dates',
  templateUrl: './events-dates.component.html',
  styleUrls: ['./events-dates.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [DatePipe, ReactiveFormsModule, MaterialModule],
})
export class EventsDatesComponent {
  readonly anlass = input.required<IAnlass>();
  readonly anlassSummary = input.required<IAnlassSummary>();
  readonly viewOnly = input.required<boolean>();

  readonly verlaengertChanged = output<Date>();

  protected readonly verlaengerungControl = new FormControl<Date | null>(null);

  protected readonly nochNichtOffenClass = computed(() => this.getStatusClass(AnzeigeStatusEnum.NOCH_NICHT_OFFEN));
  protected readonly erfassenGeschlossenClass = computed(() => this.getStatusClass(AnzeigeStatusEnum.ERFASSEN_CLOSED));
  protected readonly crossKategorieGeschlossenClass = computed(() =>
    this.getStatusClass(AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED),
  );
  protected readonly inKategorieGeschlossenClass = computed(() =>
    this.getStatusClass(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED),
  );
  protected readonly alleMutationenGeschlossenClass = computed(() =>
    this.getStatusClass(AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED),
  );
  protected readonly geschlossenClass = computed(() => this.getStatusClass(AnzeigeStatusEnum.CLOSED));
  protected readonly hasStatusVerlaengert = computed(() =>
    moment(this.anlassSummary().verlaengerungsDate).isSameOrAfter(moment.now()),
  );

  private readonly syncExtensionDate = effect(() => {
    this.verlaengerungControl.setValue(this.anlassSummary().verlaengerungsDate, { emitEvent: false });
  });

  private getStatusClass(anzeigeStatus: AnzeigeStatusEnum): string {
    if (this.anlass().anzeigeStatus.hasStatus(anzeigeStatus)) {
      return 'div-red';
    }

    return 'div-green';
  }

  protected onExtensionDateChanged(event: MatDatepickerInputEvent<Date>): void {
    if (event.value) {
      this.verlaengertChanged.emit(event.value);
    }
  }
}
