import { Component, type OnInit } from '@angular/core';
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
  selector: 'lxt-nav',
  templateUrl: './nav.component.html',
  styleUrls: ['./nav.component.scss'],
  standalone: true,
  imports: [CommonModule, RouterModule, MaterialModule],
})
export class NavComponent extends SubscriptionHelper implements OnInit {
  anlaesse: IAnlass[];
  anlaesse$!: Observable<IAnlass[]>;

  vereine: IVerein[];
  vereine$!: Observable<IVerein[]>;

  organisator: IVerein;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private router: Router,
  ) {
    super();
    this.anlaesse$ = this.store.pipe(select(selectAnlaesseSortedNew(true)));
    this.vereine$ = this.store.pipe(select(selectVereineSorted()));
    this.router.routeReuseStrategy.shouldReuseRoute = () => false;
  }

  ngOnInit() {
    this.registerSubscription(
      this.anlaesse$.subscribe((data) => {
        this.anlaesse = data;
      }),
    );
    this.registerSubscription(
      this.vereine$.subscribe((data) => {
        this.vereine = data;
      }),
    );
  }

  get eigeneAnlaesse(): IAnlass[] {
    if (this.authService.isAnlassUser()) {
      return this.anlaesse.filter((anlass) => {
        if (anlass.organisatorId === this.authService.currentVerein.id) {
          return true;
        }
        return false;
      });
    } else {
      if (this.authService.isAdministrator()) {
        return this.anlaesse;
      }
      return [];
    }
  }

  getOrganisator(anlass: IAnlass): Observable<IVerein> {
    return this.store.pipe(select(selectVereinById(anlass.organisatorId)));
  }

  setVerein(verein: IVerein) {
    const oldSelectedVerein = this.authService.currentVerein;
    this.authService.selectVerein(verein);
    // this.userService.reset();
    // this.anlassService.reset();
    // this.teilnehmerService.reset(oldSelectedVerein, false);
    // this.teilnehmerService.loadTeilnehmer(verein);
    this.router.navigate(['/']);
  }
}
