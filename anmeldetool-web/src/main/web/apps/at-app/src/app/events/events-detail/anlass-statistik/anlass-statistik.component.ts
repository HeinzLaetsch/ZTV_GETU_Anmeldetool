import { ChangeDetectionStrategy, Component, computed, input, output } from '@angular/core';
import { type MatCheckboxChange, MatCheckboxModule } from '@angular/material/checkbox';
import { AnzeigeStatusEnum } from 'src/app/core/model/AnzeigeStatusEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';

@Component({
  selector: 'ztv-anlass-statistik',
  templateUrl: './anlass-statistik.component.html',
  styleUrl: './anlass-statistik.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [MatCheckboxModule],
})
export class AnlassStatistikComponent {
  readonly anlass = input.required<IAnlass>();
  readonly anlassSummary = input.required<IAnlassSummary>();
  readonly startetChanged = output<boolean>();

  readonly isTuAnlass = computed(() => this.anlass().tuAnlass);
  readonly isTiAnlass = computed(() => this.anlass().tiAnlass);
  readonly isBrevet1Anlass = computed(() => this.anlass().brevet1Anlass);
  readonly isBrevet2Anlass = computed(() => this.anlass().brevet2Anlass);
  readonly isStartedCheckboxDisabled = computed(() => {
    const anlass = this.anlass();
    const summary = this.anlassSummary();
    const status = anlass.anzeigeStatus;

    if (!status || status.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN)) {
      return true;
    }

    return (
      status.hasStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED) && new Date(summary.verlaengerungsDate).getTime() < Date.now()
    );
  });

  onStartetChange(change: MatCheckboxChange): void {
    this.startetChanged.emit(change.checked);
  }
}
