import { DatePipe } from '@angular/common';
import { ChangeDetectionStrategy, Component, inject, input, type OnInit, output } from '@angular/core';
import { Router } from '@angular/router';
import { select, Store } from '@ngrx/store';
import type { AnzeigeStatusEnum } from 'src/app/core/model/AnzeigeStatusEnum';
import type { IAnlassExtended } from 'src/app/core/model/IAnlassExtended';
import type { IOrganisationAnlassLink } from 'src/app/core/model/IOrganisationAnlassLink';
import type { AppState } from 'src/app/core/redux/core.state';
import { HoverOverDirective } from 'src/app/core/directive/hover.directive';
import { selectVereinById } from 'src/app/core/redux/verein';
import { AnlassService } from 'src/app/core/service/anlass/anlass.service';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import type { IVerein } from 'src/app/verein/verein';
import { EventsDatesComponent } from '../dates/events-dates.component';

@Component({
  selector: 'lxt-event-thumbnail',
  templateUrl: './event-thumbnail.component.html',
  styleUrls: ['./event-thumbnail.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: true,
  imports: [DatePipe, HoverOverDirective, EventsDatesComponent],
})
export class EventThumbnailComponent extends SubscriptionHelper implements OnInit {
  readonly anlassExtended = input<IAnlassExtended>();

  readonly anlassClick = output<void>();

  organisator: IVerein | null = null;

  protected readonly authService = inject(AuthService);
  private readonly store = inject<Store<AppState>>(Store);
  private readonly router = inject(Router);
  private readonly anlassService = inject(AnlassService);

  constructor() {
    super();
  }

  get anlassData(): IAnlassExtended | undefined {
    return this.anlassExtended();
  }

  ngOnInit(): void {
    const anlass = this.anlassExtended();
    if (!anlass) {
      return;
    }

    this.registerSubscription(
      this.store.pipe(select(selectVereinById(anlass.anlass.organisatorId))).subscribe((result) => {
        this.organisator = result;
      }),
    );
  }

  isEnabled(): boolean {
    return this.authService.currentVerein.name !== 'ZTV';
  }

  getClassForAnzeigeStatus(anzeigeStatus: AnzeigeStatusEnum): string {
    const anlass = this.anlassExtended();
    if (!anlass) {
      return 'div-green';
    }

    if (anlass.anlass.anzeigeStatus.hasStatus(anzeigeStatus)) {
      return 'div-red';
    }
    return 'div-green';
  }

  getStartedClass(): Record<string, boolean> {
    if (!this.anlassData?.summary?.startet) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }

  get hasTeilnehmer(): boolean {
    if (!this.anlassData?.summary) {
      return false;
    }

    return this.anlassData.summary.startendeBr1 + this.anlassData.summary.startendeBr2 > 0;
  }

  getTeilnehmerClass(): Record<string, boolean> {
    if (this.hasTeilnehmer) {
      return { greenNoMargin: true };
    } else {
      return { redNoMargin: true };
    }
  }

  getWertungsrichterClass(): Record<string, boolean> {
    if (this.hasTeilnehmer) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }

  handleClickMe(): void {
    const anlassId = this.anlassData?.anlass?.id;
    if (!anlassId) {
      return;
    }

    this.anlassClick.emit();
    this.router.navigate(['/anlaesse/', anlassId]);
  }

  vereinStartedClicked(event: MouseEvent): void {
    if (!this.anlassData?.summary) {
      return;
    }

    console.log(event);
    event.cancelBubble = true;
    const organisationAnlassLink: IOrganisationAnlassLink = {
      anlassId: this.anlassData.anlass.id,
      organisationsId: this.authService.currentVerein.id,
      startet: this.anlassData.summary.startet,
      verlaengerungsDate: this.anlassData.summary.verlaengerungsDate,
    };
    // Sollte ersetzt werden
    this.registerSubscription(
      this.anlassService.updateVereinsStart(organisationAnlassLink).subscribe((result) => {
        console.log('Clicked: ', result);
      }),
    );
  }

  get isWertungsrichterOk(): boolean {
    if (!this.anlassData?.summary) {
      return false;
    }

    if (this.hasTeilnehmer) {
      return this.anlassData.summary.br1Ok && this.anlassData.summary.br2Ok;
    }
    return true;
  }
}
