import { DatePipe } from '@angular/common';
import { Component, inject, input } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { Store } from '@ngrx/store';
import { distinctUntilChanged, switchMap } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { AppState } from 'src/app/core/redux/core.state';
import { selectVereinById } from 'src/app/core/redux/verein';
import type { IVerein } from 'src/app/verein/verein';

@Component({
  selector: 'ztv-anlass-detail',
  templateUrl: './anlass-detail.component.html',
  styleUrl: './anlass-detail.component.scss',
  imports: [DatePipe],
})
export class AnlassDetailComponent {
  readonly anlass = input.required<IAnlass>();

  private readonly store = inject(Store<AppState>);

  readonly organisator = toSignal(
    toObservable(this.anlass).pipe(
      distinctUntilChanged(),
      switchMap((anlass) => this.store.select(selectVereinById(anlass.organisatorId))),
    ),
    { initialValue: undefined as IVerein | undefined },
  );
}
