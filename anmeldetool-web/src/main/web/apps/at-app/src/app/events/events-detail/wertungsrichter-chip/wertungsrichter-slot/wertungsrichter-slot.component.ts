import { DatePipe } from '@angular/common';
import { Component, computed, inject, input, output } from '@angular/core';
import { type MatCheckboxChange, MatCheckboxModule } from '@angular/material/checkbox';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { AnzeigeStatusEnum } from 'src/app/core/model/AnzeigeStatusEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IPersonAnlassLink } from 'src/app/core/model/IPersonAnlassLink';
import type { IUser } from 'src/app/core/model/IUser';
import type { IWertungsrichterEinsatz } from 'src/app/core/model/IWertungsrichterEinsatz';
import type { IWertungsrichterSlot } from 'src/app/core/model/IWertungsrichterSlot';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';

@Component({
  selector: 'ztv-wertungsrichter-slot',
  templateUrl: './wertungsrichter-slot.component.html',
  styleUrls: ['./wertungsrichter-slot.component.scss'],
  imports: [MatCheckboxModule, MatProgressSpinnerModule],
  providers: [DatePipe],
})
export class WertungsrichterSlotComponent {
  readonly isVereinsAnmelder = input<boolean>(false);
  readonly isVereinsVerantwortlicher = input<boolean>(false);
  readonly slot = input.required<IWertungsrichterSlot>();
  readonly wertungsrichter = input.required<IUser>();
  readonly wrAnlassLink = input.required<IPersonAnlassLink>();
  readonly einsatz = input<IWertungsrichterEinsatz>();
  readonly anlass = input.required<IAnlass>();
  readonly egalIsAktiv = input<boolean>(false);

  readonly wrEinsatzChange = output<IWertungsrichterEinsatz>();

  private readonly authservice = inject(AuthService);
  private readonly anlassService = inject(CachingAnlassService);
  private readonly datePipe = inject(DatePipe);

  readonly slotText = computed(() => {
    const slot = this.slot();
    const parts = [
      slot.tag ? this.datePipe.transform(slot.tag, 'dd-yyyy-MM') : undefined,
      slot.startzeit ? this.datePipe.transform(slot.startzeit, 'hh:mm') : undefined,
      slot.endzeit ? this.datePipe.transform(slot.endzeit, 'hh:mm') : undefined,
      slot.beschreibung,
    ];

    return parts.filter((part): part is string => !!part).join(' ');
  });

  readonly isCheckboxDisabled = computed(
    () =>
      this.egalIsAktiv() ||
      this.anlass().anzeigeStatus.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN) ||
      this.anlass().anzeigeStatus.hasStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED),
  );

  readonly canEdit = computed(
    () =>
      !this.isCheckboxDisabled() &&
      (this.authservice.isVereinsAnmmelderSig() || this.authservice.isVereinsVerantwortlicherSig()),
  );

  userEingesetztChange(change: MatCheckboxChange): void {
    const einsatz = this.einsatz();
    if (!einsatz) {
      return;
    }

    const updatedEinsatz = { ...einsatz, eingesetzt: change.checked };
    this.anlassService
      .updateWrEinsatz(this.authservice.currentVerein, this.wrAnlassLink(), updatedEinsatz)
      .subscribe((wrEinsatz) => {
        this.wrEinsatzChange.emit(wrEinsatz);
      });
  }
}
