import { Component, computed, type OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { RouterModule } from '@angular/router';
import { select, Store } from '@ngrx/store';
import type { Observable } from 'rxjs';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import type { IVerein } from 'src/app/verein/verein';
import type { IAnlass } from '../../model/IAnlass';
import { selectAnlaesseSortedNew } from '../../redux/anlass';
import type { AppState } from '../../redux/core.state';
import { selectVereinById, selectVereineSorted } from '../../redux/verein';
import { AuthService } from '../../service/auth/auth.service';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'ztv-navigation',
  templateUrl: './nav.component.html',
  styleUrls: ['./nav.component.scss'],
  standalone: true,
  imports: [CommonModule, RouterModule, MaterialModule],
})
export class NavComponent extends SubscriptionHelper implements OnInit {
  anlaesse: IAnlass[] = [];
  anlaesse$!: Observable<IAnlass[]>;

  readonly vereine = signal<IVerein[]>([]);
  readonly vereinSearch = signal('');
  vereine$!: Observable<IVerein[]>;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private router: Router,
  ) {
    super();
    this.anlaesse$ = this.store.pipe(select(selectAnlaesseSortedNew(true)));
    this.vereine$ = this.store.pipe(select(selectVereineSorted()));
    this.router.routeReuseStrategy.shouldReuseRoute = (): false => false;
  }

  ngOnInit(): void {
    this.registerSubscription(
      this.anlaesse$.subscribe((data) => {
        this.anlaesse = data;
      }),
    );
    this.registerSubscription(
      this.vereine$.subscribe((data) => {
        this.vereine.set(data);
      }),
    );
  }

  get eigeneAnlaesse(): IAnlass[] {
    if (this.authService.isAnlassUserSig()) {
      return this.anlaesse.filter((anlass) => {
        if (anlass.organisatorId === this.authService.currentVerein.id) {
          return true;
        }
        return false;
      });
    } else {
      if (this.authService.isAdministratorSig()) {
        return this.anlaesse;
      }
      return [];
    }
  }

  getOrganisator(anlass: IAnlass): Observable<IVerein | undefined> {
    return this.store.pipe(select(selectVereinById(anlass.organisatorId)));
  }

  readonly filteredVereine = computed(() => {
    const searchTerm = this.vereinSearch().trim().toLocaleLowerCase();
    if (!searchTerm) {
      return this.vereine();
    }

    return this.vereine().filter((verein) => verein.name.toLocaleLowerCase().includes(searchTerm));
  });

  onVereinSearchInput(event: Event): void {
    this.vereinSearch.set((event.target as HTMLInputElement).value);
  }

  resetVereinSearch(): void {
    this.vereinSearch.set('');
  }

  setVerein(verein: IVerein): void {
    this.authService.selectVerein(verein);
    // this.userService.reset();
    // this.anlassService.reset();
    // this.teilnehmerService.reset(oldSelectedVerein, false);
    // this.teilnehmerService.loadTeilnehmer(verein);
    this.router.navigate(['/']);
  }
}
