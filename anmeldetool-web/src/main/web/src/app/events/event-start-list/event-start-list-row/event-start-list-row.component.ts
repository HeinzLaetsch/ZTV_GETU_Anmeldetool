import { Component, Input, type OnInit } from '@angular/core';
import { AnzeigeStatusEnum } from 'src/app/core/model/AnzeigeStatusEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmen } from 'src/app/core/model/ITeilnahmen';
import { AuthService } from 'src/app/core/service/auth/auth.service';

@Component({
  selector: 'lxt-event-start-list-row',
  templateUrl: './event-start-list-row.component.html',
  styleUrls: ['./event-start-list-row.component.css'],
  standalone: true,
})
export class EventStartListRowComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  teilnahme: ITeilnahmen;

  constructor(public authService: AuthService) {}

  ngOnInit() {
    // console.log("Anlass: ", this.anlass);
  }

  get administrator(): boolean {
    return this.authService.isAdministratorSig();
  }

  get showDetail(): boolean {
    this.anlass.abteilungFix;

    if (this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED) || this.administrator) {
      return true;
    } else {
      return false;
    }
  }

  get abteilung(): string {
    const abtLength = 'ABTEILUNG_'.length;
    if (this.teilnahme.talDTOList[0].abteilung) {
      return this.teilnahme.talDTOList[0].abteilung.substring(abtLength);
    }
    return '-';
  }
  get anlage(): string {
    const abtLength = 'ANLAGE_'.length;
    if (this.teilnahme.talDTOList[0].anlage) {
      return this.teilnahme.talDTOList[0].anlage.substring(abtLength);
    }
    return '-';
  }
}
