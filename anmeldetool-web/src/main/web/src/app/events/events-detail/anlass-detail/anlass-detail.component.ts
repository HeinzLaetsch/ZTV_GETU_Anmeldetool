import { Component, Input, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { select, Store } from '@ngrx/store';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { AppState } from 'src/app/core/redux/core.state';
import { selectVereinById } from 'src/app/core/redux/verein';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import type { IVerein } from 'src/app/verein/verein';

@Component({
  selector: 'lxt-anlass-detail',
  templateUrl: './anlass-detail.component.html',
  styleUrls: ['./anlass-detail.component.css'],
  standalone: true,
  imports: [CommonModule],
})
export class AnlassDetailComponent extends SubscriptionHelper implements OnInit {
  @Input()
  anlass: IAnlass;

  organisator: IVerein;

  constructor(private store: Store<AppState>) {
    super();
  }
  ngOnInit() {
    this.registerSubscription(
      this.store.pipe(select(selectVereinById(this.anlass.organisatorId))).subscribe((result) => {
        this.organisator = result;
      }),
    );
  }
}
