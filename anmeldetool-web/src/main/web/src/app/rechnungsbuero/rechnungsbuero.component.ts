import { CommonModule } from '@angular/common';
import { Component, type OnInit } from '@angular/core';
import { MatTabsModule } from '@angular/material/tabs';
import { ActivatedRoute } from '@angular/router';
import { select, Store } from '@ngrx/store';
import type { IAnlass } from '../core/model/IAnlass';
import { selectAnlassById } from '../core/redux/anlass';
import type { AppState } from '../core/redux/core.state';
import { AuthService } from '../core/service/auth/auth.service';
import { ErfassenComponent } from './erfassen/erfassen.component';
import { RanglistenComponent } from './rangliste/ranglisten.component';

@Component({
  selector: 'lxt-rechnungsbuero',
  templateUrl: './rechnungsbuero.component.html',
  styleUrls: ['./rechnungsbuero.component.scss'],
  imports: [CommonModule, MatTabsModule, ErfassenComponent, RanglistenComponent],
})
export class RechnungsbueroComponent implements OnInit {
  anlass!: IAnlass;

  constructor(
    private route: ActivatedRoute,
    private store: Store<AppState>,
    protected authService: AuthService,
  ) {}

  ngOnInit(): void {
    const anlassId = this.route.snapshot.params['id'];
    if (anlassId) {
      this.store.pipe(select(selectAnlassById(anlassId))).subscribe((anlass) => {
        if (anlass) {
          this.anlass = anlass;
        }
      });
    }
  }
}
