import { Component, type OnInit } from '@angular/core';
import { select, Store } from '@ngrx/store';
import { combineLatest, forkJoin, type Observable, Subscription } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassExtended } from 'src/app/core/model/IAnlassExtended';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';
import { selectAnlaesseSortedNew } from 'src/app/core/redux/anlass';
import { AnlassSummariesActions, selectAnlassSummaries } from 'src/app/core/redux/anlass-summary';
import type { AppState } from 'src/app/core/redux/core.state';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';

@Component({
  selector: 'lxt-event-list',
  templateUrl: './event-list.component.html',
  styleUrls: ['./event-list.component.css'],
  standalone: true,
})
export class EventListComponent extends SubscriptionHelper implements OnInit {
  // anlaesse: IAnlass[];
  anlaesse$: Observable<IAnlass[]>;

  // anlassSummaries: IAnlassSummary[];
  anlassSummaries$: Observable<IAnlassSummary[]>;

  anlaesseExtended: IAnlassExtended[];

  // loaded = false;
  // subscription: Subscription[] = [];

  constructor(
    public authService: AuthService,
    private store: Store<AppState>, // private anlassService: CachingAnlassService
  ) {
    super();
    this.store.dispatch(AnlassSummariesActions.loadAllAnlasssummariesInvoked());
    this.anlaesse$ = this.store.pipe(select(selectAnlaesseSortedNew(this.authService.isAdministrator())));
    this.anlassSummaries$ = this.store.pipe(select(selectAnlassSummaries()));
  }

  ngOnInit() {
    const anlassExt$ = combineLatest([this.anlaesse$, this.anlassSummaries$]);

    this.registerSubscription(
      anlassExt$.subscribe(([anlaesse, anlassSummaries]) => {
        this.anlaesseExtended = anlaesse.map((anlass) => {
          // ReadOnly ???
          const summary = anlassSummaries.find((anlassSummary) => {
            return anlassSummary.anlassId === anlass.id;
          });
          const anlaesseExtended: IAnlassExtended = {
            anlass,
            summary,
          };
          return anlaesseExtended;
        });
        console.log('AnlaesseExtended: ', this.anlaesseExtended);
      }),
    );
  }

  get showEvents(): boolean {
    return (
      (this.authService.isAuthenticated() && this.authService.isVereinsAnmmelder()) ||
      this.authService.isAdministrator()
    );
    /*
    return (
      (this.authService.isAuthenticated() &&
        this.authService.isVereinsAnmmelder() &&
        !this.authService.isAdministrator()) ||
      (this.authService.isAdministrator() &&
        this.authService.currentVerein.name != "ZTV")
    );
    */
  }
  handleEventClicked(data) {
    console.log('received :', data);
  }

  /*
  ngOnDestroy(): void {
    this.subscription.forEach((s) => s.unsubscribe());
  }*/
}
