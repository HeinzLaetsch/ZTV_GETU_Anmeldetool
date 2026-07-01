import { CommonModule } from '@angular/common';
import { Component, inject } from '@angular/core';
import type { ProgressBarMode } from '@angular/material/progress-bar';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { select, Store } from '@ngrx/store';
import type { Observable } from 'rxjs';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import type { AppState } from '../../redux/core.state';
import { SnackBarComponent } from './snack-bar/snack-bar.component';
import { ILoading } from '../../redux/busy-indicator-progress-bar/busy-indicator-progress-bar.state';
import {
  selectErrors,
  selectLoading,
  selectTransactions,
} from '../../redux/busy-indicator-progress-bar/busy-indicator-progress-bar.selectors';
import { LoadingActions } from '../../redux/busy-indicator-progress-bar/busy-indicator-progress-bar.actions';

@Component({
  selector: 'ztv-busy-indicator-progress-bar',
  templateUrl: './busy-indicator-progress-bar.component.html',
  styleUrls: ['./busy-indicator-progress-bar.component.scss'],
  standalone: true,
  imports: [CommonModule, MatProgressBarModule, MatSnackBarModule],
})
export class BusyIndicatorProgressBarComponent extends SubscriptionHelper {
  mode: ProgressBarMode = 'determinate';
  durationInSeconds = 5;

  isLoading$: Observable<ILoading[]>;
  isTransactions$: Observable<ILoading[]>;
  isError$: Observable<ILoading[]>;

  private readonly store = inject(Store<AppState>);
  private readonly _snackBar = inject(MatSnackBar);

  constructor() {
    super();
    this.isLoading$ = this.store.pipe(select(selectLoading()));
    this.isTransactions$ = this.store.pipe(select(selectTransactions()));
    this.isError$ = this.store.pipe(select(selectErrors()));

    this.registerSubscription(
      this.isLoading$.subscribe((data) => {
        if (data && data.length > 0) {
          console.log('ProgressBarMode: buffer 1');
          this.mode = 'buffer';
        }
      }),
    );
    this.registerSubscription(
      this.isTransactions$.subscribe((data) => {
        if (data) {
          if (data.length > 0) {
            let isAllFinished = true;
            data.forEach((item) => {
              if (item.isFinished) {
                this.store.dispatch(
                  LoadingActions.loadingEventProcessed({
                    payload: item.id,
                  }),
                );
              } else {
                isAllFinished = false;
              }
            });
          }
        }
      }),
    );
  }

  openSnackBar(data: ILoading): void {
    this._snackBar.openFromComponent(SnackBarComponent, {
      duration: this.durationInSeconds * 1000,
      verticalPosition: 'top',
      data: data.id + ' / ' + data.message,
    });
  }
}
