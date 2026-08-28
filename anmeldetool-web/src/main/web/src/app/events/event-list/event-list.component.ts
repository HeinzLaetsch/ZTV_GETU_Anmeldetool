import { ChangeDetectionStrategy, Component, computed, inject } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { select, Store } from '@ngrx/store';
import { switchMap } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassExtended } from 'src/app/core/model/IAnlassExtended';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';
import { selectAnlaesseSortedNew } from 'src/app/core/redux/anlass';
import { AnlassSummariesActions, selectAnlassSummaries } from 'src/app/core/redux/anlass-summary';
import type { AppState } from 'src/app/core/redux/core.state';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { EventThumbnailComponent } from '../event-thumbnail/event-thumbnail.component';

@Component({
  selector: 'lxt-event-list',
  templateUrl: './event-list.component.html',
  styleUrls: ['./event-list.component.css'],
  standalone: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [MatProgressSpinnerModule, EventThumbnailComponent],
})
export class EventListComponent {
  private readonly authService = inject(AuthService);

  private readonly store = inject<Store<AppState>>(Store);

  private readonly adminStatus$ = toObservable(this.authService.isAdministratorSig);

  readonly anlaesseSig = toSignal(
    this.adminStatus$.pipe(
      switchMap((isAdministrator) => this.store.pipe(select(selectAnlaesseSortedNew(isAdministrator)))),
    ),
    {
      initialValue: null as IAnlass[] | null,
    },
  );

  readonly anlassSummariesSig = toSignal(this.store.pipe(select(selectAnlassSummaries())), {
    initialValue: [] as IAnlassSummary[],
  });

  readonly anlaesseExtended = computed<IAnlassExtended[]>(() => {
    const anlaesse = this.anlaesseSig() ?? [];
    const anlassSummaries = this.anlassSummariesSig();

    return anlaesse.map((anlass) => {
      const summary = anlassSummaries.find((anlassSummary) => anlassSummary.anlassId === anlass.id);
      return {
        anlass,
        summary,
      };
    });
  });

  constructor() {
    this.store.dispatch(AnlassSummariesActions.loadAllAnlasssummariesInvoked());
  }

  readonly showEvents = computed(() => this.authService.isVereinsAnmmelderSig());
}
